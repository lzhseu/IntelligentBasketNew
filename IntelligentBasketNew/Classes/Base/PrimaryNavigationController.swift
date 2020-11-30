//
//  PrimaryNavigationController.swift
//  IntelligentBasketNew
//
//  Created by 卢卓桓 on 2020/7/10.
//  Copyright © 2020 卢卓桓. All rights reserved.
//

import UIKit

class PrimaryNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - 属性重写
    /// 以下两个属性是为了能够在子控制器中拿到 statusBar 的使用权
    override var childForStatusBarHidden: UIViewController? {
        return self.topViewController
    }
    
    override var childForStatusBarStyle: UIViewController? {
        return self.topViewController
    }
    

}

