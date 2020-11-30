//
//  CommonConstant.swift
//  LiveApp
//
//  Created by 卢卓桓 on 2019/7/21.
//  Copyright © 2019 zhineng. All rights reserved.
//

import UIKit


let kScreenW = UIScreen.main.bounds.width
let kScreenH = UIScreen.main.bounds.height
let kStatusBarH = UIApplication.shared.statusBarFrame.height  //状态栏高度


let kNavigationTitleFontSize: CGFloat = 22

/// 登录注册页面的控件参数
let kButtonCornerRadius: CGFloat = 6                         //按钮的圆角弧度
let kCheckBoxWH: CGFloat = 20                                //复选框的宽高
let kTextFieldWithIcon_IconWH: CGFloat = 0.045 * kScreenH    //输入框中icon的宽高
let kMenuTitleH : CGFloat = 40                               //下拉菜单每个选项的高度
let kMenuOptionH: CGFloat = 35                               //下拉菜单标题高度
let kSpaceBetweenModule: CGFloat = 20                        //模块之间的距离

let kWorkTypeArr = ["涂料", "幕墙", "内装", "土建", "车辆", "其他"]

let kPageMenuH: CGFloat = 40    // 标签页菜单的高度


enum UserRole: String {
    case AreaAdmin = "areaAdmin"
    case RentAdmin = "rentAdmin"
    case Worker = "worker"
    case Inspector = "inspector"
    case Manager = "manager"
    case GovAdmin = "govAdmin"
}

let kNetWorkErrorTip = "百胜吊篮：网络请求失败！"
