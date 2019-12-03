//
//  String.swift
//  TextbookUnlimited
//
//  Created by xhgc01 on 2018/7/10.
//  Copyright © 2018年 yangjx. All rights reserved.
//

import Foundation
extension String {
    init(ASCII: UInt8) {
        self.init(format: "%c", ASCII)

    }
    func getUTF8String() -> String {
        return CFURLCreateStringByAddingPercentEscapes(nil, self as CFString, "!*'();:@&=+$,/?%#[]" as CFString, nil, CFStringBuiltInEncodings.UTF8.rawValue) as String
    }
    func index(from: Int) -> Index {
        return self.index(startIndex, offsetBy: from)
    }

    func substring(from: Int) -> String {
        let fromIndex = index(from: from)
        return String(self[fromIndex...])
    }

    func substring(to: Int) -> String {
        let toIndex = index(from: to)
        return String(self[..<toIndex])
    }

    func substring(with r: Range<Int>) -> String {
        let startIndex = index(from: r.lowerBound)
        let endIndex = index(from: r.upperBound)
        return String(self[startIndex..<endIndex])
    }
    func convertHtml(withFont: UIFont? = nil, align: NSTextAlignment = .left, insertPrefix: String = "", insertSuffix: String = "", firstLineHeadIndentStr: String = "", headIndentStr: String = "") -> NSAttributedString {
        if let data = self.data(using: .utf8, allowLossyConversion: true),
            let attributedText = try? NSAttributedString(
                data: data,
                options: [.documentType: NSAttributedString.DocumentType.html,
                          NSAttributedString.DocumentReadingOptionKey(rawValue: "CharacterEncoding"): String.Encoding.utf8.rawValue],
                documentAttributes: nil
            ) {
            let newStr = insertPrefix+attributedText.string.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)+insertSuffix
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = align

            let fullRange = NSRange(location: 0, length: newStr.count)
            let mutableAttributeText = NSMutableAttributedString(string: newStr)
            var attributes = [NSAttributedStringKey: Any]()
            if let font = withFont {
                attributes[.font] = font
                //                mutableAttributeText.enumerateAttribute(.font, in: fullRange, options: .longestEffectiveRangeNotRequired, using: { attribute, range, _ in
                //                    if let attributeFont = attribute as? UIFont {
                //                        let traits: UIFontDescriptorSymbolicTraits = attributeFont.fontDescriptor.symbolicTraits
                //                        var newDescripter = attributeFont.fontDescriptor.withFamily(font.familyName)
                //                        if (traits.rawValue & UIFontDescriptorSymbolicTraits.traitBold.rawValue) != 0 {
                //                            newDescripter = newDescripter.withSymbolicTraits(.traitBold)!
                //                        }
                //                        if (traits.rawValue & UIFontDescriptorSymbolicTraits.traitItalic.rawValue) != 0 {
                //                            newDescripter = newDescripter.withSymbolicTraits(.traitItalic)!
                //                        }
                //                        let scaledFont = UIFont(descriptor: newDescripter, size: attributeFont.pointSize)
                //                        mutableAttributeText.addAttribute(.font, value: scaledFont, range: range)
                //                    }
                //                })
            }
            paragraphStyle.firstLineHeadIndent = (firstLineHeadIndentStr as NSString).size(withAttributes: attributes).width
            paragraphStyle.headIndent = (headIndentStr as NSString).size(withAttributes: attributes).width
            attributes[.paragraphStyle] = paragraphStyle
            mutableAttributeText.addAttributes(attributes, range: fullRange)
            return mutableAttributeText
        }

        return NSAttributedString()
    }
}

extension String {
    //将原始的url编码为合法的url
    func urlEncoded() -> String {
        let encodeUrlString = self.removingPercentEncoding?.addingPercentEncoding(withAllowedCharacters:
            .urlQueryAllowed)
        return encodeUrlString ?? ""
    }

    //将编码后的url转换回原始的url
    func urlDecoded() -> String {
        return self.removingPercentEncoding ?? ""
    }
}

extension CharacterSet {
    func allCharacters() -> [Character] {
        var result: [Character] = []
        for plane: UInt8 in 0...16 where self.hasMember(inPlane: plane) {
            for unicode in UInt32(plane) << 16 ..< UInt32(plane + 1) << 16 {
                if let uniChar = UnicodeScalar(unicode), self.contains(uniChar) {
                    result.append(Character(uniChar))
                }
            }
        }
        return result
    }
}

/// 富文本相加
func + (left: NSAttributedString, right: NSAttributedString) -> NSAttributedString {
    let result = NSMutableAttributedString()
    result.append(left)
    result.append(right)
    return result
}
