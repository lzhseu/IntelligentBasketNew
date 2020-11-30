//
//  LocalFileTools.swift
//  IntelligentBasket
//
//  Created by 卢卓桓 on 2019/8/29.
//  Copyright © 2019 zhineng. All rights reserved.
//

import UIKit

class LocalFileTools {
    
    /// 判断文件或文件夹夹是否存在
    class func isDirExistInCache(dir: String) -> Bool {
        let dirPath = NSHomeDirectory() + dir
        let fileManager = FileManager.default
        return fileManager.fileExists(atPath: dirPath)
    }
    
    /// 创建文件夹
    class func createDirInCache(dir: String) {
        let dirPath = NSHomeDirectory() + dir
        let fileManager = FileManager.default
        
        do {
            try fileManager.createDirectory(atPath: dirPath, withIntermediateDirectories: true, attributes: nil)
        } catch {
            print(error)
        }
        
    }
    
    /// 遍历文件夹中的文件
    class func getAllFilesInCache(dir: String) -> [String]{
        let dirPath = NSHomeDirectory() + dir
        let fileManager = FileManager.default
        var contents: [String]
    
        do {
            try contents = fileManager.contentsOfDirectory(atPath: dirPath)
            return contents
        } catch {
            print(error)
        }
    
        return []
    }
    
    /// 删除文件夹
    class func deleteDirInCache(dir: String) -> Bool {
        let dirPath = NSHomeDirectory() + dir
        let fileManager = FileManager.default
        
        do {
            try fileManager.removeItem(atPath: dirPath)
            return true
        } catch {
            print(error)
        }
        return false
    }
    
    /// 获取文件大小
    class func getFileSizeInCache(filePath: String) -> UInt64 {
        var fileSize : UInt64 = 0
        let dirPath = NSHomeDirectory() + filePath
        
        if !isDirExistInCache(dir: filePath) {
            return 0
        }
        
        do {
            let attr = try FileManager.default.attributesOfItem(atPath: dirPath)
            fileSize = attr[FileAttributeKey.size] as! UInt64
            
            let dict = attr as NSDictionary
            fileSize = dict.fileSize()
        } catch {
            print("Error: \(error)")
        }
        
        return fileSize
    }

}
