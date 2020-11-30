//
//  RegularMatchingTool.swift
//  IntelligentBasket
//
//  Created by 卢卓桓 on 2019/8/19.
//  Copyright © 2019 zhineng. All rights reserved.
//

import Foundation

/// 封装一个基于 NSRegularExpression 的正则匹配工具类
class RegularMatchingTool {

    private let regex: NSRegularExpression?
    
    init(patten: String) {
        regex = try? NSRegularExpression(pattern: patten, options: .caseInsensitive)
    }
    
    func match(input: String) -> Bool {
        if let matches = regex?.matches(in: input, options: [], range: NSMakeRange(0, (input as NSString).length)) {
                return matches.count > 0
            } else {
            return false
        }
    }
    
}



