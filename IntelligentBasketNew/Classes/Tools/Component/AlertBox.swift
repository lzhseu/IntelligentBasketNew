//
//  AlertBox.swift
//  IntelligentBasket
//
//  Created by 卢卓桓 on 2019/8/19.
//  Copyright © 2019 zhineng. All rights reserved.
//

import UIKit

class AlertBox {
    
    class func create(title: String?, message: String?, viewController: UIViewController!){
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        let sureAction = UIAlertAction(title: "确定", style: .default) { (action) in
            //点击确定后可以有的操作
        }
        alertController.addAction(cancelAction)
        alertController.addAction(sureAction)
        viewController.present(alertController, animated: true, completion: nil)
    }
    
    class func createForInvalidToken(title: String?, message: String?, viewController: UIViewController!){
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        let sureAction = UIAlertAction(title: "确定", style: .default) { (action) in
            //点击确定后可以有的操作
            UserDefaultStorage.removeToken()
            viewController.dismiss(animated: false, completion: nil)
        }
        alertController.addAction(cancelAction)
        alertController.addAction(sureAction)
        viewController.present(alertController, animated: true, completion: nil)
    }
}
