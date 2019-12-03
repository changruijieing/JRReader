//
//  HTTP.swift
//  TextbookUnlimited
//
//  Created by xhgc01 on 2018/7/13.
//  Copyright © 2018年 yangjx. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import Reachability
// swiftlint:disable line_length
final class HTTP: NSObject {
    private static let reachability: Reachability! = Reachability()
    static let shared: HTTP = HTTP()
    private var `default`: SessionManager = {
        let configuration                       = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders     = SessionManager.defaultHTTPHeaders
        configuration.timeoutIntervalForRequest = 30
        return SessionManager(configuration: configuration)
    }()
    private var moreTimeManager: SessionManager = {
        let configuration                       = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders     = SessionManager.defaultHTTPHeaders
        configuration.timeoutIntervalForRequest = 300
        return SessionManager(configuration: configuration)
    }()
}
// MARK: - 配置方法
extension HTTP {

    // MARK: setCookiePolicy
    static func setCookiePolicy() {
        self.clearCookies()
        self.clearCaches()
        let cookieStorage = HTTPCookieStorage.shared
        cookieStorage.cookieAcceptPolicy = .never
        URLCache.shared.memoryCapacity = 0
        URLCache.shared.diskCapacity = 0
    }

    /// 清除网络缓存
    static func clearCaches() {
        let cach = URLCache.shared
        cach.removeAllCachedResponses()
    }

    /// 清除Cookies
    static func clearCookies() {
        let cookieStorage = HTTPCookieStorage.shared
        let cookies = cookieStorage.cookies
        //删除cookie
        if cookies != nil {
            for pCookie in cookies! {
                cookieStorage.deleteCookie(pCookie)
            }
        }
    }
    /// 网络监听
    static func monitorNetworkStatus() {
        NotificationCenter.default.addObserver(self, selector: #selector(reachabilityChanged(note:)), name: NSNotification.Name.reachabilityChanged, object: reachability)
        do {
            try reachability.startNotifier()
        } catch {
            dPrint("could not start reachability notifier")
        }
    }
    /// 停止网络监听
    static func stopMonitorNetworkStatus() {
        self.reachability.stopNotifier()
        NotificationCenter.default.removeObserver(self, name: Notification.Name.reachabilityChanged, object: reachability)
    }

    /// 状态改变
    @objc private static func reachabilityChanged(note: Notification) {

        switch reachability.connection {
        case .wifi:
            dPrint("Reachable via WiFi")
            NotificationCenter.default.post(name: NSNotification.Name.networkStatusChanged, object: true)
        case .cellular:
            dPrint("Reachable via Cellular")
            NotificationCenter.default.post(name: NSNotification.Name.networkStatusChanged, object: true)
        case .none:
            dPrint("Network not reachable")
            NotificationCenter.default.post(name: NSNotification.Name.networkStatusChanged, object: false)
        }
    }
}

// MARK: - 请求方法
extension HTTP {
    /// GET 请求
    ///
    /// - Parameters:
    ///   - urlString: 请求地址
    ///   - params: 请求参数
    ///   - headers: 请求头
    ///   - isMainQueue: 回调是否用主线程
    ///   - success: 请求成功回调
    ///   - failure: 请求失败回调
    @objc static func get(urlString: String, params: Parameters? = nil, headers: HTTPHeaders? = nil, isMainQueue: Bool = true, success : @escaping (_ response: Any)->Void, failure : @escaping (_ error: Error)->Void) {
        HTTP.baseRequest(urlString: urlString, params: params, headers: headers, isMainQueue: isMainQueue, method: HTTPMethod.get, success: success, failure: failure)
    }
    /// POST 请求
    ///
    /// - Parameters:
    ///   - urlString: 请求地址
    ///   - params: 请求参数
    ///   - headers: 请求头
    ///   - isMainQueue: 回调是否用主线程
    ///   - success: 请求成功回调
    ///   - failure: 请求失败回调
    static func post(urlString: String, params: Parameters? = nil, headers: HTTPHeaders? = nil, isMainQueue: Bool = true, encoding: ParameterEncoding = URLEncoding.default, success : @escaping (_ response: Any)->Void, failure : @escaping (_ error: Error)->Void) {
        HTTP.baseRequest(urlString: urlString, params: params, headers: headers, isMainQueue: isMainQueue, method: HTTPMethod.post, encoding: encoding, success: success, failure: failure)
    }

    /// 上传单张图片
    ///
    /// - Parameters:
    ///   - urlString: 请求地址
    ///   - name: 图片名
    ///   - image: 图片
    ///   - params: 请求参数
    ///   - headers: 请求头
    ///   - isMainQueue: 回调是否用主线程
    ///   - success: 请求成功回调
    ///   - failure: 请求失败回调
    static func uploadSingleImage(urlString: String, name: String, image: UIImage, params: Parameters? = nil, headers: HTTPHeaders? = nil, isMainQueue: Bool = true, success : @escaping (_ response: Any)->Void, failure : @escaping (_ error: Error)->Void) {
        let imgData = UIImageJPEGRepresentation(image, 0.5) ?? Data()
        let multipartData = [(name: name, file: imgData)]
        HTTP.uploadMultipartDataRequest(urlString: urlString, params: params, headers: headers, isMainQueue: isMainQueue, multipartData: multipartData, success: success, failure: failure)
    }

    /// 下载文件
    ///
    /// - Parameters:
    ///   - urlString: 请求地址
    ///   - params: 请求参数
    ///   - headers: 请求头
    ///   - method: 请求方法
    ///   - success: 请求成功回调
    ///   - failure: 请求失败回调
    static func downloadRequest(urlString: String, params: Parameters? = nil, headers: HTTPHeaders? = nil, method: HTTPMethod = .get, success : @escaping (_ response: URL)->Void, failure : @escaping (_ error: Error)->Void) {
        HTTP.networkActivityIndicatorVisible()
        let defaultSessionManager = HTTP.shared.moreTimeManager
        let urlStr = urlString.getUTF8String()
        var parameters: Parameters = [:]
        if params != nil {
            parameters += params ?? [:]
        }
        parameters += ["platform": "ios"]
        let fileName = URL.init(string: urlStr)?.lastPathComponent ?? ""
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let fileURL = documentsURL.appendingPathComponent(fileName)
        let destination: DownloadRequest.DownloadFileDestination = { _, _ in
            return (fileURL, [.removePreviousFile, .createIntermediateDirectories])
        }
        defaultSessionManager.download(urlStr, method: method, parameters: parameters, encoding: URLEncoding.default, headers: headers, to: destination).response { (response) in
            HTTP.networkActivityIndicatorInvisible()

            if response.error == nil, let fileURL = response.destinationURL {
                success(fileURL)
            } else {
                failure(response.error!)
            }
        }
    }
}

// MARK: - 私有方法
extension HTTP {
    private static func networkActivityIndicatorVisible() {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    private static func networkActivityIndicatorInvisible() {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    private static func baseRequest(urlString: String, params: Parameters? = nil, headers: HTTPHeaders? = nil, isMainQueue: Bool = true, method: HTTPMethod = .get, encoding: ParameterEncoding = URLEncoding.default, success : @escaping (_ response: Any)->Void, failure : @escaping (_ error: Error)->Void) {
        HTTP.networkActivityIndicatorVisible()
        let defaultSessionManager = HTTP.shared.default
        let urlStr = urlString.getUTF8String()
        var queue = DispatchQueue.main
        if !isMainQueue {
            queue = DispatchQueue.global()
        }

        defaultSessionManager.request(urlStr, method: method, parameters: params, encoding: encoding, headers: headers).responseJSON(queue: queue) { (response) in
            HTTP.networkActivityIndicatorInvisible()
            switch response.result {
            case .success(let value):
                success(value)

            case .failure(let error):
                failure(error)

            }
        }
    }
    private static func uploadMultipartDataRequest(urlString: String, params: Parameters? = nil, headers: HTTPHeaders? = nil, isMainQueue: Bool = true, multipartData: [(name: String, file: Data)], success : @escaping (_ response: Any)->Void, failure : @escaping (_ error: Error)->Void) {

        HTTP.networkActivityIndicatorVisible()
        let defaultSessionManager = HTTP.shared.moreTimeManager
        let urlStr = urlString.getUTF8String()
        var queue = DispatchQueue.main
        if !isMainQueue {
            queue = DispatchQueue.global()
        }
        defaultSessionManager.upload(multipartFormData: { (multipartFormData) in
            for multiData in multipartData {
                multipartFormData.append(multiData.file, withName: "file", fileName: multiData.name, mimeType: "image/jpeg")
            }
            if let para = params {
                for (key, value) in para {
                    if let v = value as? String {
                        multipartFormData.append(v.data(using: String.Encoding.utf8)!, withName: key)
                    }

                }
            }

        }, to: urlStr, method: HTTPMethod.post, headers: headers) { (encodingResult) in
            networkActivityIndicatorInvisible()

            switch encodingResult {

            case .success(let request, _, _):
                request.responseJSON(queue: queue, completionHandler: { (response) in
                    switch response.result {

                    case .success(let value):
                        success(value)

                    case .failure(let error):
                        failure(error)

                    }
                })
            case .failure(let encodingError):
                failure(encodingError)
            }
        }
    }
}

// swiftlint:enable line_length
