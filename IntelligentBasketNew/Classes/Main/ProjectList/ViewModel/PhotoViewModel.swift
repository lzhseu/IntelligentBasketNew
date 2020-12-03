//
//  PhotoViewModel.swift
//  IntelligentBasket
//
//  Created by 卢卓桓 on 2020/4/30.
//  Copyright © 2020 zhineng. All rights reserved.
//

import Foundation

//private let kPrefetchingPhotoNum = 9 // 预取的照片数
private let kRefreshPhotoNum = 6      // 刷新下载的照片数
private let kMaxPhotoNumsFromLoaclFiles = 12 // 从本地拿照片显示时，一次最多显示15张
let NO_MORE_PHOTO: Int = 1014

let CAMERA_ID_ERROR: Int = -1


class PhotoViewModel {
    
    var photosName = [String]()
    static var photosDisplayed = [String]()   //用于存储已经显示的图片
    
    
    /*
     * 获取图片
     */
    func getPhotos(cameraId: String, success: @escaping (_ result: Any) -> (), getResourceListError: @escaping (_ error: Int) -> (), downloadError: @escaping (_ error: Int) -> ()) {
                
        /// 判断文件夹是否存在，不存在则创建
        let dirPath = "/" + localFileAppendingBaseURL + "/" + cameraId
        if !LocalFileTools.isDirExistInCache(dir: dirPath) {
            LocalFileTools.createDirInCache(dir: dirPath)
        }
        
        /// 打印路径 调试用
        //print(localFileBaseURL)
        //print(dirPath)
        
        /// 获取文件夹中的所有图片
        let localFiles = LocalFileTools.getAllFilesInCache(dir: dirPath)
        var imagesPath = [String]()
        
        PhotoViewModel.photosDisplayed = []
        
        /// 若文件夹中有图片，则直接展示
        if localFiles.count > 0 {
            
            print("get photos from local file.")
            /// 一次显示15张
            for (idx, image) in localFiles.enumerated() {
                if idx == kMaxPhotoNumsFromLoaclFiles {
                    break
                }
                imagesPath.append(NSHomeDirectory() + dirPath + "/" + image)
                PhotoViewModel.photosDisplayed.append(image)
            }
            
            /// 成功回调
            success(imagesPath)
            
        } else {
            
            /// 本地没有图片的话，则从服务器拿
            /// 先获取资源列表
            
            print("get photos from ftp server.")
            
            let dGroup = DispatchGroup()
            
            
            FtpTools_v2.FtpResourceList(deviceId: cameraId, finishedCallBack: { (result) in
                print("======= resource list...  =======")
                
                /// 拿到资源列表
                guard let resArr = result as? [[String: Any]] else { return }
                
                /// 拿到每张图片的名称
                for dict in resArr {
                    let photoName = dict["kCFFTPResourceName"] as! String
                    if photoName.hasSuffix(".jpg") || photoName.hasSuffix(".jpeg") || photoName.hasSuffix(".png") {
                        self.photosName.append(photoName)
                    }
                    /// 预拿9张，减少开销，因为FTP没那么快，拿多了也没用
                    if self.photosName.count == FtpMaxClient {
                        break
                    }
                }
                
                /// 开始下载
                for  (idx, file) in self.photosName.enumerated() {
                    
                    let appendingURL = photoDirFtpURL + "/" + cameraId + "/" + file
                    let localFilePath = localFileAppendingBaseURL + "/" + cameraId + "/" + file
                    
                    dGroup.enter()
                    FtpTools_v2.FtpDownload(appendingURL: appendingURL, localFilePath: localFilePath, finishedCallBack: { (result) in
                        
                        guard let image = result as? String else {
                            downloadError(-1)
                            dGroup.leave()
                            return
                        }
                        imagesPath.append(image)
                        
                        //20200506 新增：下载后也需要把图片加入已显示图片的数组
                        let lastIndex = image.positionOf(sub: "/", backwards: true)
                        let imageName = image.subString(start: lastIndex+1)
                        PhotoViewModel.photosDisplayed.append(imageName)
                        ///////////////////////////////////////////////
                        
                        dGroup.leave()
                        
                    }, finishWithError: { (error) in
                        
                        print("======= download error =======")
                        downloadError(error)
                        dGroup.leave()
                    })
                    
                    
                    /// 一次下载9张
                    if idx == FtpMaxClient - 1 {
                        break
                    }
                }
                
                /// 所有并行请求都结束后
                dGroup.notify(queue: .main) {
                    /// 将结果回调
                    print("ftp download photos ooooooooook")
                    success(imagesPath)
                }
                
            }) { (error) in
                print("======= get resource list error =======")
                getResourceListError(error)
            }
            
        }
    }
    
    
    /*
     * 刷新时获取图片
     */
    func getRefreshPhotos(cameraId: String, success: @escaping (_ result: Any) -> (), finishWithError: @escaping (_ error: Int) -> ()) {
        
        if cameraId == ""  {
            finishWithError(CAMERA_ID_ERROR)
            return
        }
        
        /// 需要知道此时已经有哪些照片了
        /// 需要有一个变量来记录
        /// 获取文件夹中的所有图片
        let dirPath = "/" + localFileAppendingBaseURL + "/" + cameraId
        let localFiles = LocalFileTools.getAllFilesInCache(dir: dirPath)
        
        photosName = []
        var imagesPath = [String]()
        
        let dGroup = DispatchGroup()
        
        /// 先看本地有没有剩余的图片
        if localFiles.count > PhotoViewModel.photosDisplayed.count {
            
            print("get photos from local file.")
            
            /// 一次显示15张
            let displayedCount = PhotoViewModel.photosDisplayed.count
            for idx in displayedCount ..< localFiles.count {
                if idx == kMaxPhotoNumsFromLoaclFiles + displayedCount {
                    break
                }
                imagesPath.append(NSHomeDirectory() + dirPath + "/" + localFiles[idx])
                PhotoViewModel.photosDisplayed.append(localFiles[idx])
            }
            success(imagesPath)
            
        } else {
            
            print("get photos from ftp server.")
            
            /// 先获取资源列表
            FtpTools_v2.FtpResourceList(deviceId: cameraId, finishedCallBack: { (result) in
                
                /// 拿到资源列表
                guard let resArr = result as? [[String: Any]] else { return }
                print(result)
                
                /// 如果本地图片的数量已经等于服务器图片
                if localFiles.count >= resArr.count {
                    finishWithError(NO_MORE_PHOTO)
                    return
                }
                
                /// 拿本地没有的文件
                for idx in localFiles.count ..< resArr.count {
                    let dict = resArr[idx]
                    let photoName = dict["kCFFTPResourceName"] as! String
                    if photoName.hasSuffix(".jpg") || photoName.hasSuffix(".jpeg") || photoName.hasSuffix(".png") {
                        
                        self.photosName.append(photoName)
                    }
                    
                    if idx == localFiles.count + kRefreshPhotoNum {
                        break
                    }
                }
                
                /// 开始下载
                for  (idx, file) in self.photosName.enumerated() {
                    let appendingURL = photoDirFtpURL + "/" + cameraId + "/" + file
                    let localFilePath = localFileAppendingBaseURL + "/" + cameraId + "/" + file
                    
                    dGroup.enter()
                    FtpTools_v2.FtpDownload(appendingURL: appendingURL, localFilePath: localFilePath, finishedCallBack: { (result) in
                        
                        guard let image = result as? String else {
                            dGroup.leave()
                            return
                        }
                        
                        imagesPath.append(image)
                        
                        //20200506 新增：下载后也需要把图片加入已显示图片的数组
                        let lastIndex = image.positionOf(sub: "/", backwards: true)
                        let imageName = image.subString(start: lastIndex+1)
                        PhotoViewModel.photosDisplayed.append(imageName)
                        ///////////////////////////////////////////////
                        
                        dGroup.leave()
                        
                    }, finishWithError: { (error) in
                        
                        dGroup.leave()
                        
                    })
                    
                    if idx == kRefreshPhotoNum - 1 {
                        break
                    }
      
                }
                
                /// 所有并行请求都结束后
                dGroup.notify(queue: .main) {
                    /// 将结果回调
                    print("ftp refresh photos ooooooooook")
                    success(imagesPath)
                }
                
            }) { (error) in
                
                finishWithError(error)
            }
            
        }
    }
    
    /**
     * 请求 cameraId
     */
    func requestCameraId(deviceId: String, finishedCallBack: @escaping (_ result: String) -> (), errorCallBack: @escaping () -> ()) {
        
        let parameters = ["deviceId": deviceId]
        let token = UserDefaultStorage.getToken() ?? ""
             
        HttpTools.requestDataURLEncoding(URLString: getInstallInfoURL, method: .GET, parameters: parameters, token: token, finishedCallBack: { (result) in
          
            guard let resDict = result as? [String: Any] else {
                errorCallBack()
                return
            }
            
            guard let installInfo = resDict["installInfo"] as? [String: Any] else {
                errorCallBack()
                return
            }
            
            guard let deviceInfo = installInfo["deviceInfo"] as? [String: Any] else {
                errorCallBack()
                return
            }
            
            guard let cameraId = deviceInfo["camera_id"] as? String else {
                errorCallBack()
                return
            }
            
            finishedCallBack(cameraId)
            
            //finishedCallBack("E57241589")
            
        }) { (error) in
            print(error)
            errorCallBack()
        }
    }
}
