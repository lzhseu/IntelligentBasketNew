//
//  NetworkTools.swift
//  LiveApp
//
//  Created by 卢卓桓 on 2019/7/30.
//  Copyright © 2019 zhineng. All rights reserved.
//

import UIKit
import Alamofire
import PromiseKit

enum MethodType{
    case GET
    case POST
}

class HttpTools {
    
    /// 默认的请求方法(使用json发送参数)
    /// 无Token
    class func requestDataJsonEncoding(URLString: String, method: MethodType, parameters: [String: Any]? = nil, finishedCallBack: @escaping (_ result: Any) -> (), finishWithError: @escaping (_ error: Any) -> ()){
        
        let headers: HTTPHeaders = ["Accept": "*/*", "Content-Type": "application/json;charset=utf-8"]
        
        var methodType = HTTPMethod.get
        
        switch method {
        case .GET:
            methodType = HTTPMethod.get
        case .POST:
            methodType = HTTPMethod.post
        }
        
        Alamofire.request(URLString, method: methodType, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON()
            .done { (json, response) in
                finishedCallBack(json)  //回调结果
            }.catch { (error) in
                finishWithError(error)  //回调错误
        }
    }
    
    
    
    /// 携带Token
    class func requestDataJsonEncoding(URLString: String, method: MethodType, parameters: [String: Any]? = nil, token: String, finishedCallBack: @escaping (_ result: Any) -> (), finishWithError: @escaping (_ error: Any) -> ()){
        
        let headers: HTTPHeaders = ["Accept": "*/*", "Content-Type": "application/json;charset=utf-8", "Authorization": token]
        
        var methodType = HTTPMethod.get
        
        switch method {
        case .GET:
            methodType = HTTPMethod.get
        case .POST:
            methodType = HTTPMethod.post
        }
        
        Alamofire.request(URLString, method: methodType, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON()
            .done { (json, response) in
                finishedCallBack(json)  //回调结果
            }.catch { (error) in
                finishWithError(error)  //回调错误
        }
    }
    
    /// 无Token
    class func requestDataURLEncoding(URLString: String, method: MethodType, parameters: [String: Any]? = nil, finishedCallBack: @escaping (_ result: Any) -> (), finishWithError: @escaping (_ error: Any) -> ()){
        
        let headers: HTTPHeaders = ["Accept": "*/*", "Content-Type": "application/json;charset=utf-8"]
        
        var methodType = HTTPMethod.get
        
        switch method {
        case .GET:
            methodType = HTTPMethod.get
        case .POST:
            methodType = HTTPMethod.post
        }
        
        Alamofire.request(URLString, method: methodType, parameters: parameters, headers: headers).responseJSON()
            .done { (json, response) in
                finishedCallBack(json)  //回调结果
            }.catch { (error) in
                finishWithError(error)  //回调错误
        }
    }
    
    /// 携带Token
    class func requestDataURLEncoding(URLString: String, method: MethodType, parameters: [String: Any]? = nil, token: String, finishedCallBack: @escaping (_ result: Any) -> (), finishWithError: @escaping (_ error: Any) -> ()){
        
        let headers: HTTPHeaders = ["Accept": "*/*", "Content-Type": "application/json;charset=utf-8", "Authorization": token]
        
        var methodType = HTTPMethod.get
        
        switch method {
        case .GET:
            methodType = HTTPMethod.get
        case .POST:
            methodType = HTTPMethod.post
        }
        
        Alamofire.request(URLString, method: methodType, parameters: parameters, headers: headers).responseJSON()
            .done { (json, response) in
                finishedCallBack(json)  //回调结果
            }.catch { (error) in
                finishWithError(error)  //回调错误
        }
    }
    
    ///
    class func requestDeviceVideo(deviceId: String, token: String, finishedCallBack: @escaping (_ result: Any) -> (), finishWithError: @escaping (_ error: Any) -> ()) {
        
        let headers: HTTPHeaders = ["Accept": "*/*", "Content-Type": "application/json;charset=utf-8", "Authorization": token]
        
        let http_str = "/server.command?command=start_rtmp_stream&pipe=0&url=rtmp://47.96.103.244:1935/rtmplive/" + deviceId
        
        let parameters = ["type": "getVideo", "http_str": http_str, "device_id": deviceId]
        
        Alamofire.request(sendToDeviceURL, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseString()
            .done { (result, response) in
                finishedCallBack(result)
            }.catch { (error) in
                finishWithError(error)
        }
    }
}
