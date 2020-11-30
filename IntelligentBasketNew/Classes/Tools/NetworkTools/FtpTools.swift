//
//  FtpTools.swift
//  IntelligentBasket
//
//  Created by 卢卓桓 on 2019/8/28.
//  Copyright © 2019 zhineng. All rights reserved.
//

import UIKit
import LxFTPRequest

class FtpTools {
    
    static var request: LxFTPRequest?

    /// 基础：列出文件夹里所有文件
    /// 这个功能需要提供的URL格式为：URL(string: YourURL)?.appendingPathComponent("")
    /// eg. URL(string: "ftp://47.100.1.211/nacelleRent/workPhoto/others")?.appendingPathComponent("")
    class func FtpResourceList(baseURL: String, finishedCallBack: @escaping (_ result: Any) -> (), finishWithError: @escaping (_ error: Int) -> ()) {
        request = LxFTPRequest.resourceList()
        FtpRequest(request: request, baseURL: baseURL, finishedCallBack: finishedCallBack, finishWithError: finishWithError)
    }
    
    /// 基础：下载文件夹里的某一份文件
    /// 这个功能需要提供的URL格式为：URL(string: baseURL)?.appendingPathComponent(appendingURL)
    /// eg. URL(string: "ftp://47.100.1.211")?.appendingPathComponent("nacelleRent/workPhoto/others")
    class func FtpDownload(appendingURL: String, localFilePath: String, finishedCallBack: @escaping (_ result: Any) -> (), finishWithError: @escaping (_ error: Int) -> ()) {
        request = LxFTPRequest.download()
        request?.localFileURL = URL(fileURLWithPath: NSHomeDirectory()).appendingPathComponent(localFilePath)
        //print(request?.localFileURL)
        FtpRequest(request: request, appendingURL: appendingURL, finishedCallBack: finishedCallBack, finishWithError: finishWithError)
    }
    
    /// 基础的ftp请求
    class func FtpRequest(request: LxFTPRequest?, baseURL: String = baseFtpURL, appendingURL: String = "", username: String = FtpUsername, password: String = FtpPassword, finishedCallBack: @escaping (_ result: Any) -> (), finishWithError: @escaping (_ error: Int) -> ()) {
        
        request?.serverURL = URL(string: baseURL)?.appendingPathComponent(appendingURL)
        request?.username = username
        request?.password = password
        
        /*?.progressAction = { (totalSize, finishedSize, finishedPercent) in
            print("totalSize: \(totalSize),  finishedSize: \(finishedSize),  finishedPercent: \(finishedPercent)")
        }*/
        
        request?.successAction = { (resultClass, result) in
            //print("ftp nice!!!!")
            guard let result = result else {
                print("result is nil")
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
