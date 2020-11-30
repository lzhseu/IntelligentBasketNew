//
//  HikVisionViewModel.swift
//  IntelligentBasket
//
//  Created by 卢卓桓 on 2019/11/11.
//  Copyright © 2019 zhineng. All rights reserved.
//

import UIKit

class HikVisionViewModel {
    lazy var vedioList = [HikVisionVideoModel]()
    //var vedioListInfo = HkviVideoListInfoModel()
    var vedioTotal: Int = 0
    var cameraId: String = ""
}

// MARK: - 网络请求
extension HikVisionViewModel {
    func requestAccessToken(appKey: String, appSecret: String, viewController: UIViewController, finishedCallBack: @escaping () -> (), errorCallBack: @escaping () -> ()) {
        
        //let parameters = ["appKey": appKey, "appSecret": appSecret] as [String : String]

        HttpTools.requestDataURLEncoding(URLString: getHVAccessTokenURL + "?appKey=\(appKey)&appSecret=\(appSecret)", method: .POST, parameters: nil, finishedCallBack: { (result) in
            //print(result)
            
            guard let resDict = result as? [String: Any] else { return }
            
            let code = resDict["code"] as! String
            if code != "200" {
                viewController.view.showTip(tip: "百胜吊篮：视频令牌请求失败！", position: .bottomCenter)
                return
            }
            
            guard let data = resDict["data"] as? [String: Any] else { return }
            let token = data["accessToken"] as! String
            let expireTime = data["expireTime"] as! Double
            UserDefaultStorage.storeHIKVISIONAccessToken(token: token)
            UserDefaultStorage.storekHIKVISIONAExpireTime(expire: expireTime / 1000)
            finishedCallBack()
            
        }) { (error) in
            print("requestHVAccessToken error: \(error)")
            errorCallBack() //错误回调
        }
    }
    
    
    func requestVideoList(accessToken: String, pageStart: Int, pageSize: Int, viewController: UIViewController, finishedCallBack: @escaping () -> (), errorCallBack: @escaping () -> ()) {
        
        let URLStr = getHVVideoListURL + "?accessToken=\(accessToken)&pageStart=\(pageStart)&pageSize=\(pageSize)"
        
        HttpTools.requestDataURLEncoding(URLString: URLStr, method: .POST, parameters: nil, finishedCallBack: { (result) in
            //print(result)
            
            guard let resDict = result as? [String: Any] else { return }
            
            let code = resDict["code"] as! String
            if(code != "200") {
                viewController.view.showTip(tip: "百胜吊篮：视频列表请求失败！", position: .bottomCenter)
                return
            }
            /*
            guard let page = resDict["page"] as? [String: Any] else {
                viewController.view.showTip(tip: "百胜吊篮：获取视频列表信息失败！", position: .bottomCenter)
                return
            }
            
            guard let total = page["total"] as? Int else {
                viewController.view.showTip(tip: "百胜吊篮：获取视频列表信息失败！", position: .bottomCenter)
                return
            }
            self.vedioTotal = total
            */
            guard let dataList = resDict["data"] as? [[String: Any]] else { return }
            for dict in dataList {
                guard let vedioModel = try? DictConvertToModel.JSONModel(HikVisionVideoModel.self, withKeyValues: dict) else {
                    print("HikVisionVideoModel: Json To Model Failed")
                    continue
                }
                self.vedioList.append(vedioModel)
            }
            
            finishedCallBack()
            
        }) { (error) in
            print("requestHVVideoList error: \(error)")
            errorCallBack() //错误回调
        }
    }
    
    func requestVideoListInfo(accessToken: String, finishedCallBack: @escaping () -> (), errorCallBack: @escaping () -> ()) {
        
        let URLStr = getHVVideoListURL + "?accessToken=\(accessToken)&pageStart=\(0)&pageSize=\(1)"
        
        HttpTools.requestDataURLEncoding(URLString: URLStr, method: .POST, parameters: nil, finishedCallBack: { (result) in
            //print(result)
            
            guard let resDict = result as? [String: Any] else { return }
            
            let code = resDict["code"] as! String
            if(code != "200") {
                return
            }
            
            guard let page = resDict["page"] as? [String: Any] else {
                return
            }
            
            guard let total = page["total"] as? Int else {
                return
            }
            self.vedioTotal = total
            
            finishedCallBack()
            
        }) { (error) in
            print("requestVideoListInfo error: \(error)")
            errorCallBack() //错误回调
        }
    }
    
    
    func requestDeviceSerial(deviceId: String, type: Int, viewController: UIViewController, finishedCallBack: @escaping () -> (), errorCallBack: @escaping () -> ()) {
        
        let URLStr = getElectricBoxConfig + "?deviceId=\(deviceId)&type=\(type)"
        let token = UserDefaultStorage.getToken() ?? ""
        
        HttpTools.requestDataURLEncoding(URLString: URLStr, method: .GET, parameters: nil, token: token, finishedCallBack: { (result) in
            //print(result)
            
            guard let resDict = result as? [String: Any] else { return }
            
            guard let isLogin = resDict["isLogin"] as? Bool else { return }
            if !isLogin {
                return
            }
            
            guard let electricBoxConfig = resDict["electricBoxConfig"] as? [String: Any] else {
                viewController.view.showTip(tip: "百胜吊篮：获取摄像头序列号失败！", position: .bottomCenter)
                return
            }
            guard let cameraId = electricBoxConfig["cameraId"] as? String else {
                viewController.view.showTip(tip: "百胜吊篮：获取摄像头序列号失败！", position: .bottomCenter)
                return
            }
            self.cameraId = cameraId
            
            finishedCallBack()
            
        }) { (error) in
            print("requestDeviceSerial error: \(error)")
            errorCallBack() //错误回调
        }
    }
}
