//
//  URLConstant.swift
//  IntelligentBasket
//
//  Created by 卢卓桓 on 2019/8/19.
//  Copyright © 2019 zhineng. All rights reserved.
//

import Foundation

let baseURL = "http://39.98.115.183:80"   //公网地址

// 这是线路1的地址，线路1现在已经废弃
let baseRtmpURL = "rtmp://47.96.103.244:1935/rtmplive"

// MARK: - 用户接口
/// 登录注册
let registerURL = baseURL + "/checkRegister"
let loginURL = baseURL + "/login"

/// 获取人员信息
let userDetailURL = baseURL + "/androidGetUserInfo"



// MARK: - 项目接口
/// 获取区域管理员负责的所有项目信息，以便出库
let getAllProjectURL = baseURL + "/getAllProject"

/// 获取某一项目的吊篮列表
let getBasketListURL = baseURL + "/getBasketList"

/// 获取指定项目的详细信息
let projectDetailInfoURL = baseURL + "/projectDetailInfo"

/// 获取不同层级的项目列表
let getProjectListByKeyURL = baseURL + "/getProjectListByKey"

/// 按照项目名或地区模糊查找项目
let getProjectByVagueURL = baseURL + "/getProjectByVague"

/// 获取吊篮安装信息【用于获取 cameraId，进一步获取吊篮图片】
let getInstallInfoURL = baseURL + "/getInstallInfo"



// MARK: - 通讯服务器接口
/// 移动端向吊篮发起命令：
let sendToDeviceURL = baseURL + ":8081/sendToDevice"


/// FTP
let baseFtpURL = "ftp://39.99.158.73"
let photoDirFtpURL = "/HikVision/"
let localFileBaseURL = NSHomeDirectory()
let localFileAppendingBaseURL = "Library/Caches/nacelleRent/workPhoto"

let FtpUsername = "root"
let FtpPassword = "BASServer2020"
let FtpMaxClient = 9  // 最大连接数，也即一次并行下载的最大图片数


/// 海康威视接口
let baseHikVisonURL = "https://open.ys7.com"
let getHVAccessTokenURL = baseHikVisonURL + "/api/lapp/token/get"
let getHVVideoListURL = baseHikVisonURL + "/api/lapp/live/video/list"
let HikVisonAppKey = "6747c45b0baf43868d88e34748c742e7"
let HikVisonAppSecret = "3b3d8db1a048dd9e197711b37ecb6c42"

/// 获取海康威视摄像头序列号
let getElectricBoxConfig = baseURL + "/getElectricBoxConfig"
