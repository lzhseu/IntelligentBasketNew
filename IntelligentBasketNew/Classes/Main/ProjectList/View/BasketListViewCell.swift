//
//  BasketListViewCell.swift
//  IntelligentBasket
//
//  Created by 卢卓桓 on 2019/10/17.
//  Copyright © 2019 zhineng. All rights reserved.
//

import UIKit
import LxFTPRequest

private let requestDeviceSerial_type: Int = 1

class BasketListViewCell: UICollectionViewCell {
    
    // MARK: - 自定义属性
    var usingBasketModel: UsingBasketModel? {
        didSet {
            if let storeState = usingBasketModel?.storageState {
                switch storeState {
                case 0:
                    isUsingLabel.text = "未出库"
                    isUsingLabel.textColor = primaryColor
                case 1:
                    isUsingLabel.text = "待安装"
                    isUsingLabel.textColor = primaryColor
                case 11, 12, 13, 14, 15, 16, 17, 18, 19:
                    isUsingLabel.text = "安装中"
                    isUsingLabel.textColor = primaryColor
                case 2:
                    isUsingLabel.text = "待审核"
                    isUsingLabel.textColor = primaryColor
                case 21, 22, 23, 24, 25, 26, 27, 28, 29:
                    isUsingLabel.text = "审核中"
                    isUsingLabel.textColor = primaryColor
                case 3:
                    isUsingLabel.text = "使用中"
                    isUsingLabel.textColor = primaryColor
                case 4:
                    isUsingLabel.text = "待报停"
                    isUsingLabel.textColor = primaryColor
                case 5:
                    isUsingLabel.text = "报停审核"
                    isUsingLabel.textColor = primaryColor
                default:
                    isUsingLabel.text = "吊篮状态未知"
                    isUsingLabel.textColor = UIColor.red
                }
            } else {
                isUsingLabel.text = "吊篮状态未知"
                isUsingLabel.textColor = UIColor.red
            }
            deviceIdLabel.text = usingBasketModel?.deviceId
        }
    }
    
    var superController: BaseViewController?
    
    var total: Int = 0
    var deviceSerial: String = ""
    
    // MARK: - 懒加载属性
    //private lazy var basketDetailVM = BasketDetailViewModel()
    private lazy var HikVisionVM = HikVisionViewModel()
    private lazy var photoVM = PhotoViewModel()
    
    // MARK: - 控件属性
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var vedio1ImageView: UIImageView!
    @IBOutlet weak var vedio2ImageView: UIImageView!
    @IBOutlet weak var isUsingLabel: UILabel!
    @IBOutlet weak var deviceIdLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        photoImageView.isUserInteractionEnabled = true
        photoImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(photoImageViewTapped)))
        vedio1ImageView.isUserInteractionEnabled = true
        vedio1ImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(vedio1ImageViewTapped)))
        vedio2ImageView.isUserInteractionEnabled = true
        vedio2ImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(vedio2ImageViewTapped)))
    }
    
}

// MARK: - 事件监听函数
extension BasketListViewCell {
    
    @objc private func photoImageViewTapped() {
        guard let deviceId = self.usingBasketModel?.deviceId else {
            self.superController?.view.showTip(tip: "百胜吊篮：设备号无效！")
            return
        }
        let photoVc = PhotoBrowserViewController()
        photoVc.deviceId = deviceId
        superController!.pushViewController(viewController: photoVc, animated: true)
        
        photoVM.requestCameraId(deviceId: deviceId, finishedCallBack: { (cameraId) in
            
            photoVc.cameraId = cameraId
            
            // 获取图片
            self.photoVM.getPhotos(cameraId: cameraId, success: { (result) in
                                
                guard let images = result as? [String] else { return }
                photoVc.imageArr = images
                
            }, getResourceListError: { (getRLError) in
                
                /// 获取资源列表失败
                photoVc.view.hideLoading()
                switch getRLError {
                case 550:
                    photoVc.view.showTip(tip: "百胜吊篮：没有更多图片！", position: .bottomCenter)
                default:
                    photoVc.view.showTip(tip: "百胜吊篮：图片数据请求失败！", position: .bottomCenter)
                }
                
            }) { (dError) in
                /// 下载某张图片失败
            }
            
        }) {
            photoVc.view.hideLoading()
            photoVc.view.showTip(tip: "百胜吊篮：获取摄像头失败！", position: .bottomCenter)
        }
        
        
        /*
        photoVM.getPhotos(deviceId: deviceId, success: { (result) in
            
            guard let images = result as? [String] else { return }
            photoVc.imageArr = images
            
        }, getResourceListError: { (getRLError) in
            
            /// 获取资源列表失败
            photoVc.view.hideLoading()
            switch getRLError {
            case 550:
                photoVc.view.showTip(tip: "百胜吊篮：没有更多图片！", position: .bottomCenter)
            default:
                photoVc.view.showTip(tip: "百胜吊篮：图片数据请求失败！", position: .bottomCenter)
            }
            
        }) { (dError) in
            /// 下载某张图片失败
        }
        */
        
        
        /*
        basketDetailVM.getPhotos(deviceId: deviceId, success: { (result) in
            guard let images = result as? [String] else { return }
            photoVc.imageArr = images
        }) { (error) in
           print("**********&&&&&&&&&&^^^^^^^^^^^^")
            photoVc.view.hideLoading()
            switch error {
            case 550:
                photoVc.view.showTip(tip: "百胜吊篮：没有更多图片！", position: .bottomCenter)
            default:
                photoVc.view.showTip(tip: "百胜吊篮：图片数据请求失败！", position: .bottomCenter)
            }
        }
        */
        
    }
    
    @objc private func vedio1ImageViewTapped() {
        
        UserDefaultStorage.removeHIHIKVISIONAExpireTime()
        
        guard let deviceId = usingBasketModel?.deviceId else {
            superController?.view.showTip(tip: "百胜吊篮：设备号无效！", position: .bottomCenter)
            return
        }
        
        let token = UserDefaultStorage.getToken() ?? ""
        HttpTools.requestDeviceVideo(deviceId: deviceId, token: token, finishedCallBack: { (result) in
            if (result as! String) == "success" {
                /// 进入播放视频页面
                let playUrl = baseRtmpURL + "/" + deviceId
                let playerViewController = PLPlayerViewController(playUrl: playUrl)
                playerViewController.modalPresentationStyle = .fullScreen
                self.superController?.present(playerViewController, animated: true, completion: nil)
            } else {
                self.superController?.view.showTip(tip: "百胜吊篮：获取设备视频失败！", position: .bottomCenter)
            }
            
        }) { (error) in
            print("get vedio: \(error)")
            self.superController?.view.showTip(tip: "百胜吊篮：获取设备视频失败！", position: .bottomCenter)
        }
        
    }
    
    @objc private func vedio2ImageViewTapped() {
        
        requestVedio2()
        
        
        /*
        var isRetakeToken = false
        let expireTime = UserDefaultStorage.getHIKVISIONAExpireTime()
        if expireTime == nil {
            isRetakeToken = true
        } else if (expireTime! - Date().timeIntervalSince1970) < 600.0 {
            // 剩下 10 分钟的时候重新获取token
            isRetakeToken = true
        }
        
        /// 重新获取token
        if isRetakeToken {
            
            HikVisionVM.requestAccessToken(appKey: HikVisonAppKey, appSecret: HikVisonAppSecret, viewController: superController!, finishedCallBack: {
                print("海康威视：获取AT成功")
            }) {
                //error
                print("海康威视：获取AT失败")
                self.superController?.view.showTip(tip: "百胜吊篮：获取设备令牌失败！", position: .bottomCenter)
            }
        }
        
        let accessToken = UserDefaultStorage.getHIKVISIONAccessToken() ?? ""
        HikVisionVM.requestVideoList(accessToken: accessToken, pageStart: 0, pageSize: 10, viewController: superController!, finishedCallBack: {
            /// 这里认为只有一台设备
            //print("获取视频列表：")
            //print(self.HikVisionVM.vedioList)
            if(self.HikVisionVM.vedioList.count > 0) {
                let rtmpUrl = self.HikVisionVM.vedioList[0].rtmpUrl ?? ""
                self.superController?.present(PLPlayerViewController(playUrl: rtmpUrl), animated: true, completion: nil)
            }
            
        }) {
            //error
            print("海康威视：获取视频列表失败")
            self.superController?.view.showTip(tip: "百胜吊篮：获取设备视频失败！", position: .bottomCenter)
        }
        */
    }
    
}

// MARK: - 网络请求函数
extension BasketListViewCell {
    
    private func requestVedio2() {
        guard let deviceId = self.usingBasketModel?.deviceId else {
            self.superController?.view.showTip(tip: "百胜吊篮：设备号无效！")
            return
        }
        HikVisionVM.requestDeviceSerial(deviceId: deviceId, type: requestDeviceSerial_type, viewController: superController!, finishedCallBack: {
            //成功得到摄像头序列号
            self.deviceSerial = self.HikVisionVM.cameraId
            //获取海康威视Token
            self.requestHVAT()
        }) {
            print(self.deviceSerial)
            self.superController?.view.showTip(tip: "百胜吊篮：获取摄像头序列号失败！")
        }
        
    }
    
    private func requestHVAT() {
     
        var isRetakeToken = false
        let expireTime = UserDefaultStorage.getHIKVISIONAExpireTime()
        if expireTime == nil {
            isRetakeToken = true
        } else if (expireTime! - Date().timeIntervalSince1970) < 600.0 {
            // 剩下 10 分钟的时候重新获取token
            isRetakeToken = true
        }
        
        /// 重新获取token
        let dGroup = DispatchGroup()
        if isRetakeToken {
            dGroup.enter()
            HikVisionVM.requestAccessToken(appKey: HikVisonAppKey, appSecret: HikVisonAppSecret, viewController: superController!, finishedCallBack: {
                print("海康威视：获取AT成功")
                dGroup.leave()
            }) {
                //error
                print("海康威视：获取AT失败")
                dGroup.leave()
                self.superController?.view.showTip(tip: "百胜吊篮：获取设备令牌失败！", position: .bottomCenter)
            }
        }
        dGroup.notify(queue: .main) {
            self.requestVedio2List(AT: UserDefaultStorage.getHIKVISIONAccessToken() ?? "")
        }
        
        
    }
    
    
    // TODO: 先采用暴力算法，把所有视频列表拿出来，然后寻找
    private func requestVedio2List(AT: String) {
        
        var pageStart: Int = 0
        var sum: Int = 0
        let pageSize: Int = 30
        var rtmpUrl: String?
        var isFound = false
        
        HikVisionVM.requestVideoListInfo(accessToken: AT, finishedCallBack: {
            
            self.total = self.HikVisionVM.vedioTotal
            if self.total == 0 {
                print("total = 0")
                self.superController?.view.showTip(tip: "百胜吊篮：获取设备视频失败！", position: .bottomCenter)
                return
            }
            // 拿视频列表
            let dGroup = DispatchGroup()
            //let vedioList = [HikVisionVideoModel]()
            while sum < self.total && !isFound {
                dGroup.enter()
                self.HikVisionVM.requestVideoList(accessToken: AT, pageStart: pageStart, pageSize: pageSize, viewController: self.superController!, finishedCallBack: {
                    
                    // 在视频列表中查找对应的设备ID
                    for HVModel in self.HikVisionVM.vedioList {
                        
                        guard let deviceSerial = HVModel.deviceSerial else {
                            continue
                        }
                        //找到
                        if deviceSerial == self.deviceSerial {
                            rtmpUrl = HVModel.rtmpUrl
                            isFound = true
                            break
                        }
                    }
                    dGroup.leave()
                }) {
                    print("海康威视：获取视频列表失败")
                    dGroup.leave()
                    self.superController?.view.showTip(tip: "百胜吊篮：获取设备视频失败！", position: .bottomCenter)
                }
                
                sum += pageSize
                pageStart += 1
            }
            
            dGroup.notify(queue: .main, execute: {
                if !isFound {
                    self.superController?.view.showTip(tip: "百胜吊篮：获取设备视频失败！", position: .bottomCenter)
                } else {
                    guard let rtmpURL = rtmpUrl else {
                        print("海康威视：播放地址无效！")
                        self.superController?.view.showTip(tip: "百胜吊篮：播放地址无效！", position: .bottomCenter)
                        return
                    }
                    let playerViewController = PLPlayerViewController(playUrl: rtmpURL)
                    playerViewController.modalPresentationStyle = .fullScreen
                    self.superController?.present(playerViewController, animated: true, completion: nil)
                }
                
            })
            
        }) {
            print("海康威视：获取视频个数失败")
        }
        
        
    }
}
