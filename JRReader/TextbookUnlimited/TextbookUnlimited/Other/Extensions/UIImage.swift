//
//  UIImage.swift
//  TextbookUnlimited
//
//  Created by xhgc01 on 2018/7/10.
//  Copyright © 2018年 yangjx. All rights reserved.
//

import UIKit
import Accelerate

extension UIImage {

    func scaleToSize(_ img: UIImage, toSize size: CGSize) -> UIImage? {
        UIGraphicsBeginImageContext(size)
        img.draw(in: CGRect.init(x: 0, y: 0, width: size.width, height: size.height))
        let imgRet=UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return imgRet
    }
    /// 生成指定颜色的图片
    static func filled(with color: UIColor) -> UIImage {
        let pixelScale = UIScreen.main.scale
        let pixelSize = 1 / pixelScale
        let fillSize = CGSize(width: pixelSize, height: pixelSize)
        let fillRect = CGRect(origin: CGPoint.zero, size: fillSize)
        UIGraphicsBeginImageContextWithOptions(fillRect.size, false, pixelScale)
        let graphicsContext = UIGraphicsGetCurrentContext()
        graphicsContext!.setFillColor(color.cgColor)
        graphicsContext!.fill(fillRect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }

    /// 模糊图片
    func blurImage(level: CGFloat, complete:@escaping (UIImage?)->Void) {

        DispatchQueue.global().async {
            var boxSize = Int(level*40)
            boxSize = boxSize - (boxSize % 2) + 1
            let img = self.cgImage
            let inProvider = img?.dataProvider
            let inBitmapData = inProvider?.data
            var inBuffer = vImage_Buffer.init()
            var outBuffer = vImage_Buffer.init()
            inBuffer.width = vImagePixelCount(img?.width ?? 0)
            inBuffer.height = vImagePixelCount(img?.height ?? 0)
            inBuffer.rowBytes = img?.bytesPerRow ?? 0
            inBuffer.data = UnsafeMutableRawPointer(mutating: CFDataGetBytePtr(inBitmapData))

            if let pixelBuffer = malloc(inBuffer.rowBytes * Int(inBuffer.height)) {
                outBuffer.data = pixelBuffer
                outBuffer.width = vImagePixelCount(img?.width ?? 0)
                outBuffer.height = vImagePixelCount(img?.height ?? 0)
                outBuffer.rowBytes = img?.bytesPerRow ?? 0

                let error = vImageBoxConvolve_ARGB8888(&inBuffer, &outBuffer, nil, 0, 0, UInt32(boxSize), UInt32(boxSize), nil, vImage_Flags(kvImageEdgeExtend))

                if error == 0 {
                    let colorSpace = CGColorSpaceCreateDeviceRGB()
                    let ctx = CGContext.init(data: outBuffer.data, width: Int(outBuffer.width), height: Int(outBuffer.height), bitsPerComponent: 8, bytesPerRow: outBuffer.rowBytes, space: colorSpace, bitmapInfo: CGImageAlphaInfo.noneSkipLast.rawValue)
                    let imageRef = ctx?.makeImage()
                    let returnImage = UIImage.init(cgImage: imageRef!)
                    free(pixelBuffer)
                    DispatchQueue.main.async {
                        complete(returnImage)
                    }
                }

            }
        }

    }
}
