//
//  UsingBasketModel.swift
//  IntelligentBasket
//
//  Created by 卢卓桓 on 2019/8/23.
//  Copyright © 2019 zhineng. All rights reserved.
//

/*
 * 区域管理员 -> 项目 -> 使用中 的模型
 */

import UIKit

class UsingBasketModel: Codable {
    
    // MARK: - 模型属性
    var workingState: Int?
    var storageState: Int?
    var alarm: Int?
    var date: String?
    var deviceId: String?
    var projectId: String?
    //var storeIn: String
    
    enum CodingKeys: String, CodingKey {
        case workingState
        case storageState
        case alarm
        case date
        case deviceId
        case projectId
        //case storeIn
    }
}
