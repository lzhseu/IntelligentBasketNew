//
//  HikVisionVideoModel.swift
//  IntelligentBasket
//
//  Created by 卢卓桓 on 2019/11/11.
//  Copyright © 2019 zhineng. All rights reserved.
//

import UIKit

class HikVisionVideoModel: Codable {

    // MARK: - 模型属性
    var deviceSerial: String?
    var channelNo: Int?
    var deviceName: String?
    var rtmpUrl: String?
    var rtmpHdUrl: String?
    var status: Int?
    var exception: Int?
    
    enum CodingKeys: String, CodingKey {
        case deviceSerial
        case channelNo
        case deviceName
        case rtmpUrl = "rtmp"
        case rtmpHdUrl = "rtmpHd"
        case status
        case exception
    }
}
