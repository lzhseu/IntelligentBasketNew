//
//  UsingBasketViewModel.swift
//  IntelligentBasket
//
//  Created by 卢卓桓 on 2019/8/23.
//  Copyright © 2019 zhineng. All rights reserved.
//

/*
 * 区域管理员 -> 项目 -> 使用中
 */

import UIKit

class UsingBasketViewModel {
    lazy var usingBasketGroup = [UsingBasketModel]()
}

// MARK: - 请求网络数据
extension UsingBasketViewModel {
    
    func requestAllBasket(projectId: String, viewController: RoleBaseViewController, finishedCallBack: @escaping () -> (), errorCallBack: @escaping () -> ()) {
        
        let token = UserDefaultStorage.getToken() ?? ""
        let parameters = ["projectId": projectId]
        
        
        usingBasketGroup = []  //每次请求之前先把历史数据清零
     
        HttpTools.requestDataURLEncoding(URLString: getBasketListURL, method: .GET, parameters: parameters, token: token, finishedCallBack: { (result) in
            //print(result)
            guard let resDict = result as? [String: Any] else { return }
            
            let isAllowed = resDict["isAllowed"] as! Bool
            if isAllowed == false {
                //AlertBox.create(title: "警告", message: "令牌无效！", viewController: viewController)
                AlertBox.createForInvalidToken(title: "警告", message: "令牌无效！", viewController: viewController)
                return
            }
            
            guard let basketList = resDict["basketList"] as? String else { return }
            let basketArr: [String] = basketList.split(separator: ",").compactMap{ "\($0)" }
            
            let keyBase = "storage"
            for index in 0..<basketArr.count {
                let key = keyBase + String(index)
                guard let baseketDetailDict = resDict[key] as? [String: Any] else { continue }
                
                guard let model = try? DictConvertToModel.JSONModel(UsingBasketModel.self, withKeyValues: baseketDetailDict) else {
                    print("UsingBasketModel: Json To Model Failed")
                    continue
                }
                self.usingBasketGroup.append(model)
            }
            
            finishedCallBack()
        }) { (error) in
            print(error)
            errorCallBack()
        }
    }
    
}
