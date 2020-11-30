//
//  DictConvertToModel.swift
//  LiveApp
//
//  Created by 卢卓桓 on 2019/7/31.
//  Copyright © 2019 zhineng. All rights reserved.
//

import UIKit

class DictConvertToModel {

    // MARK: - 字典 转 模型
    class func JSONModel<T>(_ type: T.Type, withKeyValues data:[String:Any]) throws -> T where T: Decodable {
        let jsonData = try JSONSerialization.data(withJSONObject: data, options: [])
        let model = try JSONDecoder().decode(type, from: jsonData)
        return model
    }
    
    // MARK: - 字典数组 转 模型数组
    class func JSONModels<T>(_ type: T.Type, withKeyValuesArray datas: [[String:Any]]) throws -> [T]  where T: Decodable {
        var temp: [T] = []
        for data in datas {
            let model = try JSONModel(type, withKeyValues: data)
            temp.append(model)
        }
        return temp
    }
}
