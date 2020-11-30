//
//  UserDefaultStorage.swift
//  IntelligentBasket
//
//  Created by 卢卓桓 on 2019/8/23.
//  Copyright © 2019 zhineng. All rights reserved.
//

/*
 * 使用 UserDefault 进行小容量数据存取
 */

import UIKit

private let kTokenKey = "MyToken"
private let kCurrentProKey = "kCurrentProKey"
private let kUserIdKey = "kUserIdKey"
private let kUserNameKey = "kUserNameKey"
private let kUserPermKey = "kUserPermKey"
private let kHIKVISIONAccessToken = "kHIKVISIONAccessToken"
private let kHIKVISIONAExpireTime = "kHIKVISIONAExpireTime"


class UserDefaultStorage {
    
    /// 存取 Token
    class func storeToken(token: String) {
        UserDefaults.standard.set(token, forKey: kTokenKey)
    }
    
    class func getToken() -> String? {
        return UserDefaults.standard.object(forKey: kTokenKey) as? String
    }
    
    class func removeToken() {
        UserDefaults.standard.removeObject(forKey: kTokenKey)
    }
    
    /// 存取 userId
    class func storeUserId(userId: String) {
        UserDefaults.standard.set(userId, forKey: kUserIdKey)
    }
    
    class func getUserId() -> String? {
        return UserDefaults.standard.object(forKey: kUserIdKey) as? String
    }
    
    /// 存取 userName
    class func storeUserName(userName: String) {
        UserDefaults.standard.set(userName, forKey: kUserNameKey)
    }
    
    class func getUserName() -> String? {
        return UserDefaults.standard.object(forKey: kUserNameKey) as? String
    }
    
    /// 存取 userPrem
    class func storeUserPerm(userName: String) {
        UserDefaults.standard.set(userName, forKey: kUserPermKey)
    }
    
    class func getUserPerm() -> String? {
        return UserDefaults.standard.object(forKey: kUserPermKey) as? String
    }
    
    /// 存取当前项目名（区域管理员 用到）
    class func storeCurrentProjectId(projectId: String) {
        UserDefaults.standard.set(projectId, forKey: kCurrentProKey)
    }
    
    class func getCurrentProjectId() -> String? {
        return UserDefaults.standard.object(forKey: kCurrentProKey) as? String
    }
    
    /// 存取海康威视摄像头的AccessToken
    class func storeHIKVISIONAccessToken(token: String) {
        UserDefaults.standard.set(token, forKey: kHIKVISIONAccessToken)
    }
    
    class func getHIKVISIONAccessToken() -> String? {
        return UserDefaults.standard.object(forKey: kHIKVISIONAccessToken) as? String
    }
    
    class func removeHIKVISIONAccessToken() {
        UserDefaults.standard.removeObject(forKey: kHIKVISIONAccessToken)
    }
    
    /// 存取海康威视摄像头AT的过期时间
    class func storekHIKVISIONAExpireTime(expire: Double) {
        UserDefaults.standard.set(expire, forKey: kHIKVISIONAExpireTime)
    }
    
    class func getHIKVISIONAExpireTime() -> Double? {
        return UserDefaults.standard.object(forKey: kHIKVISIONAExpireTime) as? Double
    }
    
    class func removeHIHIKVISIONAExpireTime() {
        UserDefaults.standard.removeObject(forKey: kHIKVISIONAExpireTime)
    }
}
