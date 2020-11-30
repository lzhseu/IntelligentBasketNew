//
//  ProjectInfoModel.swift
//  IntelligentBasket
//
//  Created by 卢卓桓 on 2019/10/22.
//  Copyright © 2019 zhineng. All rights reserved.
//

/*
 * 由于在此前的版本中已经有 ProjectModel 这个文件
 * 模型的内容其实是一致的
 * 但为了使思路更加清晰 故此处命名为 ProjectInfoModel 最终版本确立后，可能会删除以前版本的文件
 */

import UIKit

class ProjectInfoModel: Codable {
    
    // MARK: - 模型属性
    var projectId: String?
    var projectName: String?
    var projectState: String?
    var projectStart: String?
    var projectEnd: String?
    var projectContractUrl: String?
    var projectCertUrl: String?
    var adminAreaId: String?
    var adminRentId: String?
    var adminProjectId: String?
    var boxList: String?
    var companyName: String?
    var coordinate: String?
    var region: String?
    var deviceNum: Int?
    var workerNum: Int?
    
    // MARK: - 自定义属性
    var deviceIds: [String]?
    var latitude: String?   //纬度
    var longitude: String?  //经度
    var size: Int?
    
    enum CodingKeys: String, CodingKey {
        case projectId
        case projectName
        case projectState
        case projectStart
        case projectEnd
        case projectContractUrl
        case projectCertUrl
        case adminAreaId
        case adminRentId
        case adminProjectId
        case boxList
        case companyName
        case coordinate
        case region
        case deviceNum
        case workerNum
    }
    
}
