//
//  AppDelegate.swift
//  IntelligentBasketNew
//
//  Created by 卢卓桓 on 2020/7/10.
//  Copyright © 2020 卢卓桓. All rights reserved.
//

import UIKit


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,BMKGeneralDelegate,BMKLocationAuthDelegate{

    var window: UIWindow?
//    百度地图新增
//    懒加载
    private lazy var mapManager :BMKMapManager = {
        return BMKMapManager()
    }()
    
    //百度地图新增

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        UITabBar.appearance().tintColor = primaryColor
        
        //百度地图新增
        //初始化定位sdk 并进行权鉴
        BMKLocationAuth.sharedInstance()?.checkPermision(withKey: "L7eLkW0d0GiPmei3g84WINM0ZORKH5Rs", authDelegate: nil)
        //如果需要关注网络及授权验证事件,请设定generalDelegate参数
        let ret = mapManager.start("L7eLkW0d0GiPmei3g84WINM0ZORKH5Rs", generalDelegate: nil)
        if ret == false {
            print("manager start failed!")
        }
        //百度地图新增
        
        return true
    }
    
    //鉴权结果回调
    func onGetPermissionState(_ iError: Int32) {
        if 0 == iError {
            print("授权成功")
        } else {
            print("授权失败：%d", iError)
        }
    }

//    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
//        // Override point for customization after application launch.
//        return true
//    }

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
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

}

