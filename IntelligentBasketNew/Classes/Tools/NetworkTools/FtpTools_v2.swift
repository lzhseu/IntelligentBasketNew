//
//  FtpTools_v2.swift
//  IntelligentBasket
//
//  Created by 卢卓桓 on 2020/4/30.
//  Copyright © 2020 zhineng. All rights reserved.
//

import UIKit
import LxFTPRequest

/**
 * 注意：新版的FTP服务器改为主动模式，此文件代码不变。需要改变的是 LxFTPRequest.m 的源码
 */
class FtpTools_v2 {
    
    /*
     * 获取资源列表
     */
    class func FtpResourceList(deviceId: String, finishedCallBack: @escaping (_ result: Any) -> (), finishWithError: @escaping (_ error: Int) -> ()) {
        
        let request = LxFTPRequest.resourceList()
   

//        request?.serverURL = URL(string: baseFtpURL)?.appendingPathComponent("/nacelleRent/workPhoto/").appendingPathComponent(deviceId).appendingPathComponent("/")
            
         request?.serverURL = URL(string: baseFtpURL)?.appendingPathComponent(photoDirFtpURL).appendingPathComponent(deviceId).appendingPathComponent("/")
        request?.username = FtpUsername
        request?.password = FtpPassword
        
        
        request?.successAction = { (resultClass, result) in
            guard let result = result else {
                print("result is nil")
                finishWithError(-1)
                return
            }
            finishedCallBack(result)
        }
        
        request?.failAction = { (domain, error, errorMessage) in
            print("domain: \(domain)")
            print("error: \(error)")
            print("errorMessage: \(errorMessage ?? "")")
            finishWithError(error)
        }
        request?.start()
        
    }
    
    
    /*
     * 下载一个文件
     */
    class func FtpDownload(appendingURL: String, localFilePath: String, finishedCallBack: @escaping (_ result: Any) -> (), finishWithError: @escaping (_ error: Int) -> ()) {
        
        let request = LxFTPRequest.download()
        
        
        request?.serverURL = URL(string: baseFtpURL)?.appendingPathComponent(appendingURL)
        
        request?.username = FtpUsername
        request?.password = FtpPassword
        
        request?.localFileURL = URL(fileURLWithPath: NSHomeDirectory()).appendingPathComponent(localFilePath)
        
       
        
        request?.successAction = { (resultClass, result) in
            //print(result!)
            guard let result = result else {
                print("result is nil")
                finishWithError(-1)
                return
            }
            finishedCallBack(result)
        }
        
        request?.failAction = { (domain, error, errorMessage) in
            print("domain: \(domain)")
            print("error: \(error)")
            print("errorMessage: \(errorMessage ?? "")")
            finishWithError(error)
        }
        
        request?.start()
    }
    
}
