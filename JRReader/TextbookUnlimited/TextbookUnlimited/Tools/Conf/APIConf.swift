//
//  APIConf.swift
//  TextbookUnlimited
//
//  Created by xhgc01 on 2018/7/12.
//  Copyright © 2018年 yangjx. All rights reserved.
//

import Foundation

// MARK: - 本地地址
// yangjx
//private let baseURL = "http://192.168.50.222:3010/";
//private let baseUserURL = "http://192.168.50.222:3017/api/";
// changrj
//private let baseURL = "http://192.168.50.111:3010/";
//private let baseUserURL = "http://192.168.50.111:3017/api/";

// MARK: - 开发地址
//private let baseURL = "http://teach.dev.xhgc/"
//private let baseUserURL = "http://ucenter.teach.dev.xhgc/api/"
//private let baseFileURL = "http://file.dev.xhgc/"

private let configPath       = Bundle.main.path(forResource: "Configuration", ofType: "plist")
private let configDic   = NSDictionary.init(contentsOfFile: configPath!)
private let baseURL = configDic?["baseURL"] as? String ?? ""
private let baseUserURL = configDic?["baseUserURL"] as? String ?? ""
private let baseFileURL = configDic?["baseFileURL"] as? String ?? ""

//private let appBundleId      = Bundle.main.infoDictionary?["CFBundleIdentifier"] as? String ?? ""

// MARK: - 线上地址
//private let baseURL = "http://teach.aijiaocai.com/";
//private let baseUserURL = "http://ucenter.aijiaocai.com/api/";
//private let baseFileURL = "http://f.teach.aijiaocai.com/";

enum API: String {

    // MARK: - 用户相关(独立用户中心接口)
    case userRegister = "user/register" // 用户注册
    case userRegisterPhone = "user/register-phone" // 手机号注册
    case userSms = "user/sms-code" // 发送验证码
    case userSmsCheck = "user/sms-code-check" // 校验验证码
    case userLogin = "user/login/mobile" // 登录
    case userLogout = "user/logout" // 登出
    case userRefreshToken = "user/token/refresh" // 生成新token
    case userCur = "user/cur" // 用户信息
    case userUpdate = "user/update" // 更新个人信息
    case userAvatarUpdate = "user/avatar/update" // 更新头像
    case userPhoneUpdate = "user/phone-update" // 修改手机号
    case userPriv = "user/priv" // 用户权限
    case userPwdReset = "user/pwd-reset" // 用户重置密码
    case userPwdUpdate = "user/pwd-update" // 用户修改密码

    // MARK: - 用户相关(非独立用户中心接口)
    case userFavoriteResList = "user/favorite/res/list" // 用户感兴趣的资源列表
    case userFavoriteCategory = "user/favorite/category" // 用户感兴趣的分类
    case userFavoriteCategorySave = "user/favorite/category/save" // 保存用户感兴趣的分类

    // MARK: - 试题
    case exerciseMistakeScreening = "exercise/mistake-screening" // 错题本分类筛选
    case exerciseCommitAnswer = "exercise/commit-answer" // 试题提交
    case exerciseDetail = "exercise/detail" // 试题信息
    case exerciseMistakeDistribute = "exercise/mistake-distribute" // 错题分布
    case exerciseRes = "exercise/res" // 资源关联测验
    case exerciseAllAnswer = "exercise/get-all-answer"; // 试题答案
    case exerciseMistakeList = "exercise/mistake-list"; // 错题本
    case exerciseMistakeDetail = "exercise/mistake-detail"; // 错题详情
    case exerciseDeleteAnswer = "exercise/delete-answer"; // 删除试题

    // MARK: - 试卷
    case exerciseSetAllInfo = "exercise/exercises-set/all-info" // 所有试题试卷
    case exerciseSetCommitAnswer = "exercise/exercise-set/commit-answer" // 试卷提交
    case exerciseSetAllAnswer = "exercise/exercise-set/get-all-answer" // 试卷答案
    case exerciseSetReAnswer = "exercise/exercise-set/re-answer" // 重新作答
    case exerciseSetDetail = "exercise/exercise-set/detail" // 试卷详情
    case exerciseSetUserList = "exercise/exercise-set/user-list" // 答题记录列表
    case exerciseSetUserListCategory = "exercise/exercise-set/user-list-category" // 学科分类

    // MARK: - 资源
    case resDetailApi = "res/detailApi" // 资源详情

    // MARK: - 资源-我的板书
    case resNoteAdd = "res/note/add" // 添加板书
    case resNoteAddAlbum = "res/note/add/album" // 创建板书相薄
    case resNoteMyAlbumList = "res/note/my/album/all" // 我的相薄列表
    case resNoteMyNote = "res/note/my/note" // 我的板书照片
    case resNoteMyAlbumNote = "res/note/my/album/note" // 我的板书-相薄-照片
    case resNoteUpdateNote = "res/note/update/note" // 更新板书
    case resNoteDeleteNote = "res/note/delete/note" // 删除板书
    case resNoteDeleteAlbum = "res/note/delete/album" // 删除相薄
    case resNoteBelongNote = "res/note/update/note/belong" // 移动板书

    // MARK: - 资源-收藏
    case resCollectMy = "res/collect/my" // 我收藏的资源
    case resCollectDelete = "res/collect/delete" // 取消收藏的资源
    case resCollectAdd = "res/collect/add" // 添加收藏
    case resCollectGet = "res/collect/get" // 获取收藏资源

    // MARK: - 资源-我的板书
    case resCategoryList = "res/category/list" // 获取所有学科分类

    // MARK: - 资源-未知
    case resStatCollect = "res/stat/collect" // 收藏量接口

    // MARK: - 检索接口
    case searchQuery = "search/query" // 检索接口
    case searchStatKeywordAdd = "search/stat/keyword/add" // 添加检索词
    case searchStatKeywordDelete = "search/stat/keyword/delete" // 删除历史检索词
    case searchStatKeywordHistory = "search/stat/keyword/get" // 获取检索历史

    // MARK: - 知识点
    case knowledgeList = "knowledge/list" // 推荐标签列表
    case knowledgeAdd = "knowledge/add" // 添加标签
//    case knowledgeSearch = "knowledge/list" // 搜索标签

    // MARK: - 教材
    case syllabusListCategory = "syllabus/index/list/category" // 分类教材

    // MARK: - 发现
    case discoverCategory = "discover/category" // 发现分类
    case discoverNew = "discover/new" // 发现新资源
    case discoverHot = "discover/hot" // 发现热点资源

    // MARK: - 上传
    case uploadImage = "upload"; // 上传照片

    // MARK: - 完整url字符串
    var url: String {
        switch self {
        case .userRegister, .userRegisterPhone, .userSms, .userSmsCheck,
             .userLogin, .userLogout, .userRefreshToken,
             .userCur, .userUpdate, .userAvatarUpdate, .userPhoneUpdate, .userPriv, .userPwdReset, .userPwdUpdate:
            return baseUserURL + self.rawValue
        case .uploadImage:
            return baseFileURL + self.rawValue + "/:" + GCTools.orgCode + "/:" + GCTools.username
        default:
            return baseURL + GCTools.orgCode + "/" + self.rawValue
        }
    }
    // MARK: - 是否需要token
    var isNeedToken: Bool {
        switch self {
        case .userLogin, .userRefreshToken, .uploadImage:
            return false
        default:
            return true
        }
    }

}
