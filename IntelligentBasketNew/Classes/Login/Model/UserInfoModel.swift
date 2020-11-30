//
//  UserInfoModel.swift
//  IntelligentBasket
//
//  Created by 卢卓桓 on 2019/8/20.
//  Copyright © 2019 zhineng. All rights reserved.
//

import UIKit

class UserInfoModel: Codable {
    
    var checked = false
    var userId: String?
    var userName: String?
    var userPassword: String?
    var userPhone: String?
    var userRole: String?
    var userPerm: String?   //用户权限
    var userImage: String?


    enum CodingKeys: String, CodingKey {
        case checked
        case userId
        case userName
        case userPassword
        case userPhone
        case userRole
        case userPerm
        case userImage
    }
}


