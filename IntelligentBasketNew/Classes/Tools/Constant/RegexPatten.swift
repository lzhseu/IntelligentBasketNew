//
//  RegexPatten.swift
//  IntelligentBasket
//
//  Created by 卢卓桓 on 2019/8/19.
//  Copyright © 2019 zhineng. All rights reserved.
//

import Foundation

//Email验证
let emailPatten = "^([a-z0-9_\\.-]+)@([\\da-z\\.-]+)\\.([a-z\\.]{2,6})$"

//手机号码验证
let mobilePattenLoose = "^1[0-9]{10}$"
let mobilePattenStrict = "^1([38][0-9]|4[579]|5[0-3,5-9]|6[6]|7[0135678]|9[89])\\d{8}$"


