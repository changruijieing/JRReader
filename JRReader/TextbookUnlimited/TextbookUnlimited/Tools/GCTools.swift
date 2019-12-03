//
//  GCTool.swift
//  TextbookUnlimited
//
//  Created by xhgc01 on 2018/8/3.
//  Copyright © 2018年 xhgc. All rights reserved.
//

import UIKit
import SwiftyJSON

// MARK: - 全局函数
public func dPrint(_ items: Any..., separator: String = " ", terminator: String = "\n", file: String = #file, funcName: String = #function, lineNum: Int = #line) {
    #if DEBUG
    let fileName    = file.components(separatedBy: "/").last ?? ""
    let info        = "文件名-->"+fileName+", 函数名-->"+funcName+", 行数-->"+"\(lineNum)"
    var infos       = items
    infos.insert(info, at: 0)
    print(infos)
    #endif
}

public enum AppVersionType: String {

    /// 测试版本
    case orderedAscending       = "测试版本"

    /// 最新版本
    case orderedSame            = "最新版本"

    /// 低版本
    case orderedDescending      = "低版本"

}

/// GCTools工具
final class GCTools: NSObject {

    static let shared: GCTools          = GCTools()
    var currentVersionNumber: String    = Conf.appVersion
    var newVersionNumber: String        = ""
    var downloadUrl: String             = ""
    var feature: String                 = ""
    var appVersionType: AppVersionType  = AppVersionType.orderedSame

    //只能用于引导页判断
    static var firstLogin: String {
        set {
            GCTools.saveKey(newValue, key: "firstLogin")
        }
        get {
            return GCTools.getKey("firstLogin")
        }
    }
    static var username: String {
        set {
            GCTools.saveKey(newValue, key: "username")
        }
        get {
            return GCTools.getKey("username")
        }
    }
    static var password: String {
        set {
            GCTools.saveKey(newValue, key: "password")
        }
        get {
            return GCTools.getKey("password")
        }
    }
    // MARK: token
    static var refreshToken: String {
        get {

            return GCTools.getKey("refreshToken")
        }
        set {
            GCTools.saveKey(newValue, key: "refreshToken")
        }
    }
    static var token: String {
        get {
            return GCTools.getKey("saveToken")
        }
        set {
            GCTools.saveKey(newValue, key: "saveToken")
        }
    }
    static var orgCode: String {
        get {
            return GCTools.getKey("orgCode")
        }
        set {
            GCTools.saveKey(newValue, key: "orgCode")
        }
    }
    static var albumDefaultResCode: String {
        set {

            GCTools.saveKey(newValue, key: "albumDefaultResCode")
        }
        get {
            return GCTools.getKey("albumDefaultResCode")
        }
    }
    static var alreadySubscribedFirstSubject: String {
        set {
            GCTools.saveKey(newValue, key: "AlreadySubscribedSubjectFirst")
        }
        get {
            return GCTools.getKey("AlreadySubscribedSubjectFirst")
        }
    }
}

// MARK: - 界面操作
extension GCTools {
    static func getNavVC() -> UINavigationController {
        let pNav = UIApplication.shared.keyWindow?.rootViewController as! UINavigationController
        return pNav
    }

    static func getCurrentNavVC() -> UINavigationController? {
        let pNav = UIApplication.shared.keyWindow?.rootViewController as! UINavigationController
        guard let tabVC = pNav.childViewControllers.last as? UITabBarController else {
            return nil
        }
        guard let nav = tabVC.selectedViewController as? UINavigationController else {
            return nil
        }
        return nav
    }

    static func pushView(_ pVC: UIViewController) {
        let pNav = getCurrentNavVC()
        pNav?.pushViewController(pVC, animated: true)
    }
    static func showView(_ pVC: UIViewController) {
        let pNav = getNavVC()
        pNav.pushViewController(pVC, animated: false)
    }
}

// MARK: - 存储操作
extension GCTools {
    static func saveKey(_ strIn: String?, key: String) {
        var strSave = strIn
        if strSave == nil {
            strSave=""
        }
        UserDefaults.standard.set(strSave, forKey: key)
        UserDefaults.standard.synchronize()
    }
    static func getKey(_ key: String) -> String {
        let token=UserDefaults.standard.object(forKey: key)
        if token != nil && token is String {
            let ret=token as! String
            return ret
        }
        return  ""
    }
}
// MARK: 操作流程工具
extension GCTools {
    public static func isLogin() -> Bool {
        return !(self.token.isEmpty || self.token == "")
    }
    //判断是否登陆,未登录则弹框提示,
    public static func checkLogin(_ parentVC: UIViewController) -> Bool {
        if self.token.isEmpty {
            let pAlert=GCTools.alert(title: "你未登录,请登录后操作", msg: "", strOk: "好的", strCamcel: "取消", clickOK: {
                NotificationCenter.default.post(name: Notification.Name("showLogin"), object: nil)
            })
            parentVC.present(pAlert, animated: true, completion: {

            })
            return false
        }
        return true
    }
    /// 检查应用版本
    ///
    /// - Parameter complete:  完成回调
    static func checkAppVersion(_ complete: @escaping (_ error: String?)->Void) {
        let shared = GCTools.shared
        let appUniversalUrl = "https://itunes.apple.com/cn/lookup"

        let para = [
            "id": Conf.appleId
        ]
        HTTP.get(urlString: appUniversalUrl, params: para, success: { (vaule) in
            let result = JSON(vaule)
            let appsInfo = result["results"].arrayValue

            if appsInfo.count > 0 {
                let appInfo = appsInfo.first!
                let version = appInfo["version"].stringValue
                let url     = appInfo["trackViewUrl"].stringValue
                let feature = appInfo["releaseNotes"].stringValue

                shared.newVersionNumber = version
                shared.downloadUrl      = url
                shared.feature          = feature

                let result = shared.currentVersionNumber.compare(version, options: .numeric, range: nil, locale: nil)

                if result == .orderedAscending {
                    shared.appVersionType = AppVersionType.orderedDescending
                } else if result == .orderedSame {
                    shared.appVersionType = AppVersionType.orderedSame
                } else if result == .orderedDescending {
                    shared.appVersionType = AppVersionType.orderedAscending
                }
            }
            complete(nil)

        }) { (error) in
            dPrint(error)
            complete(error.localizedDescription)
        }
    }
}

// MARK: - 字符串操作
extension GCTools {
    @objc public class func getOldTimeTxt(_ pOldDate: NSDate) -> String? {
        let nDate1 = abs(Int(pOldDate.timeIntervalSinceNow))
        if nDate1 > 3600*24 {
            return GCTools.date2String(pOldDate as Date, "yyyy-MM-dd")
        } else if nDate1 > 3600 {
            let nTime = nDate1/3600
            return "\(nTime)小时前"
        } else if nDate1 > 60 {
            let nTime = nDate1/60
            return "\(nTime)分钟前"
        }
        return nil
    }
    @objc public class func date2String(_ pDate: Date, _ strFormat: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = strFormat
        return dateFormatter.string(from: pDate)
    }
    public static func getUrlParams(_ strUrl: String) -> [String: AnyObject]? {
        // 判断是否有参数
        guard let start = strUrl.range(of: "?") else {
            return nil
        }
        var params = [String: AnyObject]()
        // 截取参数
        let index =  strUrl.index(after: start.lowerBound)
        let paramsString = strUrl.substring(from: index)
        // 判断参数是单个参数还是多个参数
        if paramsString.index(of: "&") != nil {
            // 多个参数，分割参数
            let urlComponents = paramsString.components(separatedBy: "&")
            // 遍历参数
            for keyValuePair in urlComponents {
                // 生成Key/Value
                let pairComponents = keyValuePair.components(separatedBy: "=")
                let key = pairComponents.first?.removingPercentEncoding
                let value = pairComponents.last?.removingPercentEncoding
                // 判断参数是否是数组
                // 已存在的值，生成数组
                let oldValue = params[key!]
                if  oldValue != nil {
                    //                        if oldValue is String{
                    //                            let strOldValue = oldValue as! String
                    //                            params[key!] = [strOldValue!]
                    //                        }else if oldValue is Array<Any>{
                    //                        params[key!] = value! as AnyObject
                    //                        }
                    //                    } else {
                    params[key!] = value as AnyObject
                }
            }
        } else {
            // 单个参数
            let pairComponents = paramsString.components(separatedBy: "=")
            // 判断是否有值
            if pairComponents.count == 1 {
                return nil
            }
            let key = pairComponents.first?.removingPercentEncoding
            let value = pairComponents.last?.removingPercentEncoding
            if let key = key, let value = value {
                params[key] = value as AnyObject
            }
        }
        return params
    }
    // MARK: 全局函数
    public static func srcTypeName2DisplayName(_ strType: String) -> String {
//        let nIndex = g_SrcTypeName.index(of: strType)
//        if nIndex == nil {
//            return "未知资源类型"
//        }
//        let name = g_SrcTypeDisplayName[nIndex!]
        return "未知资源类型"
    }
    public static func srcDisplayName2TypeName(_ strType: String) -> String {
//        let nIndex = g_SrcTypeDisplayName.index(of: strType)
//        if nIndex == nil {
//            return "未知资源类型"
//        }
//        let name = g_SrcTypeName[nIndex!]
        return "未知资源类型"
    }
    public static func dealArrayToString(pArray: NSArray) -> NSMutableString {
        let resultStr = NSMutableString()
        for i in 0..<pArray.count {
            let pStr: NSString = pArray[i] as! NSString
            if i != pArray.count - 1 {
                resultStr.append("\(pStr),")
            } else if i == pArray.count - 1 {
                resultStr.append("\(pStr)")
            }
        }
        return resultStr
    }
    public static func getTxtSize(_ attrTxt: NSAttributedString) -> CGSize {
        // let textW=AppStyle.width
        let szBounds=CGSize.init(width: AppStyle.width, height: 400)
        let size = getTxtSize(attrTxt: attrTxt, BoundingSize: szBounds)
        return size

    }
    public static func getTxtSize(attrTxt: NSAttributedString, BoundingSize: CGSize) -> CGSize {
        var size = CGSize.zero
        if !attrTxt.isEqual(nil) {
            size = attrTxt.boundingRect(with: BoundingSize, options: [NSStringDrawingOptions.usesLineFragmentOrigin, .usesFontLeading], context: nil).size
        }
        return size
    }
    public static func getPlainTxtSize(_ pTxt: String) -> CGSize {
        if !pTxt.isEmpty {
            let attrTxt = NSAttributedString.init(string: pTxt as String)
            return getTxtSize(attrTxt)
        }
        return CGSize.zero
    }
    // MARK: 值转换
    public static func html2AttrTxt(_ strHtml: String?, _ nFontSize: Int) -> NSAttributedString? {
        if  strHtml == nil {
            return nil
        }
        let Data = strHtml!.data(using: String.Encoding.utf8)
        let dicOption = [NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.html.rawValue, NSAttributedString.DocumentReadingOptionKey.characterEncoding: String.Encoding.utf8.rawValue] as [NSAttributedString.DocumentReadingOptionKey: Any]
        var strAttr = try?NSAttributedString.init(data: Data!, options: dicOption, documentAttributes: nil)
        if strAttr != nil {
            //设置富文本图片宽度不超过屏幕宽度
            var oldAttr = NSMutableAttributedString.init(attributedString: strAttr!)
            strAttr?.enumerateAttribute(NSAttributedStringKey.attachment, in: NSRange.init(location: 0, length: (strAttr?.length)!), options: NSAttributedString.EnumerationOptions.reverse, using: { (value, _, _) in
                if value != nil {
                    let  pAttachment = value as! NSTextAttachment
                    //    let rtFrame = pAttachment.bounds
                    let img = pAttachment.image
                    pAttachment.bounds=CGRect.init(x: 0, y: 0, width: pAttachment.bounds.size.width/2, height: pAttachment.bounds.size.height/2)
                    if img != nil {
                        dPrint(AppStyle.width)
                    }
                }
            })
            //添加字体大小
            oldAttr.addAttribute(NSAttributedStringKey.font, value: UIFont.systemFont(ofSize: CGFloat(nFontSize)), range: NSRange(location: 0, length: oldAttr.length))
            //去掉结尾换行符
            while oldAttr.string.hasSuffix("\n")||oldAttr.string.hasSuffix("\0") {
                let subRange = NSRange.init(location: 0, length: oldAttr.length-1)
                oldAttr = oldAttr.attributedSubstring(from: subRange) as! NSMutableAttributedString
            }
            strAttr = oldAttr
        }
        return strAttr
    }

    public static func addLineSpaceForText(_ textStr: NSString) -> NSAttributedString {
        let style = NSMutableParagraphStyle()
        style.lineSpacing = 5
        let attributeStr = NSMutableAttributedString.init(string: textStr as String)
        attributeStr.addAttribute(NSAttributedStringKey.paragraphStyle, value: style, range: NSRange(location: 0, length: textStr.length))
        return attributeStr
    }

    public static func array2String(_ aryAnswer: NSArray?) -> String? {
        if aryAnswer == nil || aryAnswer?.count == 0 {
            return nil
        }
        let strRet: NSMutableString = NSMutableString.init(capacity: 4)
        for index in 0...aryAnswer!.count-1 {
            let strOptionPos =  aryAnswer![index] as! String
            let nOptionPos: Int = Int(strOptionPos)!
            let nAscii = nOptionPos+65
            let strOption = Character(UnicodeScalar(nAscii)!)
            strRet.append(String(strOption))
            if index != aryAnswer!.count-1 {
                strRet.append(",")
            }
        }
        return strRet as String
    }
    public static func int2AttrString(_ index: Int) -> NSMutableAttributedString {
        let nAscii = index+65
        let pOption = Character(UnicodeScalar(nAscii)!)
        let strOption = String(pOption)
        let strAttr = NSMutableAttributedString.init(string: strOption)
        return strAttr
    }
    public static func percent2Float(_ strPercent: String) -> Float {
        let strNum = strPercent.substring(to: String.Index.init(encodedOffset: strPercent.count-1))
        let fRet = Float(strNum )!/100
        return fRet
    }
}
// MARK: 时间格式
extension GCTools {
    public static func getSyatemNowTimeString() -> String {
        let date = NSDate()
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "yyyMMddHHmmss"
        let strNowTime = timeFormatter.string(from: date as Date) as String
        return strNowTime
    }
    public static func dateFormat(_ strIn: String) -> String {
        if !strIn.isEmpty {
            let df: DateFormatter=DateFormatter.init()
            df.dateFormat="yyyy-MM-dd'T'HH:mm:ss.SSSZ"
            let date: Date=df.date(from: strIn)!
            let tz: TimeZone=NSTimeZone.local //TimeZone.init(identifier: "UTC")!
            df.timeZone=tz
            df.dateFormat="yyyy-MM-dd HH:mm:ss"
            return df.string(from: date)
        }
        return ""
    }
    public static func dateFormat(_ strIn: String, format strFormat: String) -> String {
        if !strIn.isEmpty && !strFormat.isEmpty {
            let df: DateFormatter=DateFormatter.init()
            df.dateFormat="yyyy-MM-dd'T'HH:mm:ss.SSSZ"
            let date: Date=df.date(from: strIn)!
            let tz: TimeZone=NSTimeZone.local //TimeZone.init(identifier: "UTC")!
            df.timeZone=tz
            df.dateFormat=strFormat
            return df.string(from: date)
        }
        return ""
    }
    public static func dateFormatStandard(_ strIn: String) -> String {
        if !strIn.isEmpty {
            let df: DateFormatter=DateFormatter.init()
            df.dateFormat="yyyy-MM-dd'T'HH:mm:ss.SSSZ"
            let date: Date=df.date(from: strIn)!
            let tz: TimeZone=NSTimeZone.local //TimeZone.init(identifier: "UTC")!
            df.timeZone=tz
            df.dateFormat="yyyy-MM-dd HH:mm:ss"
            return df.string(from: date)
        }
        return ""
    }
    public static func dateFormatStandard(_ strIn: String, format strFormat: String) -> String {
        if !strIn.isEmpty && !strFormat.isEmpty {
            let df: DateFormatter=DateFormatter.init()
            df.dateFormat="yyyy-MM-dd'T'HH:mm:ss.SSSZ"
            let date: Date=df.date(from: strIn)!
            let tz: TimeZone=NSTimeZone.local //TimeZone.init(identifier: "UTC")!
            df.timeZone=tz
            df.dateFormat=strFormat
            return df.string(from: date)
        }
        return ""
    }
}

// MARK: - 弹框
extension GCTools {
    public static func alert(title str1: String, msg str2: String, strOk str3: String, strCamcel str4: String, clickOK:@escaping () -> Void)->UIAlertController {
        let pAlert=UIAlertController.init(title: str1, message: str2, preferredStyle: UIAlertControllerStyle.alert)
        let OKAction: UIAlertAction=UIAlertAction.init(title: str3, style: UIAlertActionStyle.default) { (_) in
            clickOK()
        }
        let cancelAction: UIAlertAction=UIAlertAction.init(title: str4, style: UIAlertActionStyle.cancel) { (_) in
        }
        pAlert.addAction(OKAction)
        pAlert.addAction(cancelAction)
        //设置弹出框对齐方式:居左对齐
        let attrMsg = NSMutableAttributedString.init(string: str2)
        let paragraph: NSMutableParagraphStyle=NSMutableParagraphStyle.init()
        paragraph.alignment=NSTextAlignment.left
        attrMsg.addAttribute(NSAttributedStringKey.font, value: UIFont.systemFont(ofSize: 15), range: NSRange(location: 0, length: attrMsg.length))
        attrMsg.addAttribute(NSAttributedStringKey.paragraphStyle, value: paragraph, range: NSRange(location: 0, length: attrMsg.length))
        pAlert.setValue(attrMsg, forKey: "attributedMessage")
        return pAlert
    }
    public static func alert(title str1: String, msg str2: String, strOk str3: String, clickOK:@escaping () -> Void)->UIAlertController {
        let pAlert=UIAlertController.init(title: str1, message: str2, preferredStyle: UIAlertControllerStyle.alert)
        let OKAction: UIAlertAction=UIAlertAction.init(title: str3, style: UIAlertActionStyle.default) { (_) in
            clickOK()
        }
        pAlert.addAction(OKAction)
        return pAlert
    }
    public static func showAddTextfieldCancelAndSureAlert(pTitle: NSString, pContentStr: NSString, pCancelStr: NSString, pSureStr: NSString, cancelBlock:@escaping (()->Void), sureBlock:@escaping ((_ pTfStr: String) -> Void)) {

//        var pInputTf = UITextField()
//        _ = LEEAlert.alert().config.leeTitle(pTitle as String)?.leeAddTextField({(ptextfield: UITextField?) in
//            ptextfield?.placeholder = "输入\(pTitle as String)"
//            ptextfield?.backgroundColor = Colors.fontGrayLight
//            pInputTf = ptextfield!
//            dPrint("\(String(describing: ptextfield?.text))")
//        })?.leeAddAction({(pCancel: LEEAction?) in
//            pCancel?.title = pCancelStr as String
//            pCancel?.titleColor = UIColor.white
//            pCancel?.backgroundColor = Colors.fontGray
//            pCancel?.clickBlock = {() in
//                cancelBlock()
//            }
//        })?.leeAddAction({(pSure: LEEAction?) in
//            pSure?.title = pSureStr as String
//            pSure?.titleColor = UIColor.white
//            pSure?.backgroundColor = Colors.viewBgRed
//            pSure?.clickBlock = {() in
//                sureBlock(pInputTf.text!)
//            }
//        })?.leeShow()

    }
    //弹框提示
    public static func showCancelAndSureAlert(pTitle: NSString, pContentStr: NSString, pCancelStr: NSString, pSureStr: NSString, cancelBlock:@escaping (()->Void), sureBlock:@escaping (() -> Void)) {
        //弹出相簿提示
//        _ = LEEAlert.alert().config.leeTitle(pTitle as String)?.leeContent(pContentStr as String)?.leeAddAction({(pCancelAction: LEEAction?) in
//            pCancelAction?.title = pCancelStr as String
//            pCancelAction?.backgroundColor = Colors.viewBgRed
//            pCancelAction?.titleColor = UIColor.white
//            pCancelAction?.clickBlock = {() in
//                cancelBlock()
//            }
//        })?.leeAddAction({(pAction: LEEAction?) in
//            pAction?.title = pSureStr as String
//            pAction?.backgroundColor = Colors.fontGray
//            pAction?.titleColor = UIColor.white
//            pAction?.clickBlock = {() in
//                sureBlock()
//            }
//        })?.leeShow()
    }
}
