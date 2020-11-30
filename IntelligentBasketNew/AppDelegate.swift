//
//  AppDelegate.swift
//  IntelligentBasketNew
//
//  Created by 卢卓桓 on 2020/7/10.
//  Copyright © 2020 卢卓桓. All rights reserved.
//

import UIKit


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
//    //百度地图新增
//    //懒加载
//    private lazy var mapManager :BMKMapManager = {
//        return BMKMapManager()
//    }()
//    
//    //百度地图新增
//
//    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
//        UITabBar.appearance().tintColor = primaryColor
//        
//        //百度地图新增
//        //初始化定位sdk 并进行权鉴
//        BMKLocationAuth.sharedInstance()?.checkPermision(withKey: "BYOmg3k7exPGcPm0XdUu9GvDWYeQa9ZE", authDelegate: nil)
//        //如果需要关注网络及授权验证事件,请设定generalDelegate参数
//        let ret = mapManager.start("BYOmg3k7exPGcPm0XdUu9GvDWYeQa9ZE", generalDelegate: nil)
//        if ret == false {
//            print("manager start failed!")
//        }
//        //百度地图新增
//        
//        return true
//    }
//    
//    //鉴权结果回调
//    func onGetPermissionState(_ iError: Int32) {
//        if 0 == iError {
//            print("授权成功")
//        } else {
//            print("授权失败：%d", iError)
//        }
//    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }

    // MARK: UISceneSession Lifecycle

    /*
    @available(iOS 13.0, *)
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    @available(iOS 13.0, *)
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    */

}

