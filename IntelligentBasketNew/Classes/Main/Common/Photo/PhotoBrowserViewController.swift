//
//  PhotoBrowserViewController.swift
//  IntelligentBasket
//
//  Created by 卢卓桓 on 2019/8/27.
//  Copyright © 2019 zhineng. All rights reserved.
//

import UIKit
import YBImageBrowser
import LxFTPRequest
import MJRefresh
import SDWebImage
import SwiftyFloatingView

private let kPhotoCellID = "kPhotoCellID"
private let PhotoCollectionViewTag = 2
private let kClearBtnW: CGFloat = 75
private let kClearBtnH: CGFloat = 20
private let kClearBtnX: CGFloat = 10



class PhotoBrowserViewController: BaseViewController {

    var imageArr: [String]? {
        didSet {
            ///设置待展示的照片数据
            imageDatas = []
            photoBrowserCollectionView.reloadData()
            for (idx, data) in imageArr!.enumerated() {
                let imageData = YBIBImageData()
                imageData.imageName = data
                imageData.projectiveView = viewAtIndex(index: idx)
                imageDatas.append(imageData)
            }
            view.hideLoading()
            photoBrowserCollectionView.reloadData()
        }
    }
    
    var deviceId = ""
    
    private lazy var refreshFooter = MJRefreshAutoNormalFooter()
    
    private lazy var refreshHeader = MJRefreshNormalHeader()

    private lazy var  imageDatas = [YBIBImageData]()
    
    //private lazy var basketDetailVM = BasketDetailViewModel()
    private lazy var photoVM = PhotoViewModel()

    // MARK: - 懒加载属性
    private lazy var photoBrowserCollectionView: UICollectionView = { [unowned self] in
        /// 创建布局
        let padding: CGFloat = 5
        let itemSizeWH: CGFloat = (UIScreen.main.bounds.width - padding * 2) / 3
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: itemSizeWH, height: itemSizeWH)
        layout.sectionInset = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0

        /// 创建UICollectionView
        let frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - (self.tabBarController?.tabBar.frame.height ?? 0))
        let collectionView = UICollectionView(frame: frame, collectionViewLayout: layout)
        collectionView.tag = PhotoCollectionViewTag
        collectionView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        collectionView.backgroundColor = UIColor.white
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UINib(nibName: "PhotoViewCell", bundle: nil), forCellWithReuseIdentifier: kPhotoCellID)

        return collectionView
    }()
    
    //清除缓存按钮
    // 暂时不用
    /*
    private lazy var clearBtn: SwiftyFloatingView = {
        let normalButton:UIButton = UIButton(type: UIButton.ButtonType.system)
        normalButton.backgroundColor = primaryColor_0_5
        normalButton.frame = CGRect(x: 0, y: 0, width: kClearBtnWH, height: kClearBtnWH)
        normalButton.layer.cornerRadius = kClearBtnWH / 2
        normalButton.setTitle("清除", for: .normal)
        normalButton.setTitleColor(UIColor.white, for: .normal)
        normalButton.addTarget(self, action: #selector(clearBtnClicked), for: .touchUpInside)
        var floatingView = SwiftyFloatingView(with: normalButton)
        floatingView.delegate = self
        floatingView.setFrame(CGRect(x: (UIScreen.main.bounds.width - normalButton.frame.width) * 0.95, y: (UIScreen.main.bounds.height - normalButton.frame.height) * 0.95, width: normalButton.frame.width, height: normalButton.frame.height))
        return floatingView
    }()
    */
    private lazy var clearBtn: UIButton = {
        let normalButton: UIButton = UIButton(type: UIButton.ButtonType.system)
        normalButton.backgroundColor = primaryColor_0_5
        normalButton.frame = CGRect(x: kClearBtnX, y: (kScreenH - kClearBtnH - kStatusBarH - getNavigationBarH()) * 0.95, width: kClearBtnW, height: kClearBtnH)
        normalButton.layer.cornerRadius = 3
        normalButton.setTitle("清除缓存", for: .normal)
        normalButton.setTitleColor(UIColor.white, for: .normal)
        normalButton.addTarget(self, action: #selector(clearBtnClicked), for: .touchUpInside)
        
        return normalButton
    }()

    // MARK: - 系统回调函数
    override func viewDidLoad() {
        //setItemSizeH(itemSizeH: kScreenH - kStatusBarH - getNavigationBarH())
        //setRefreshFooter()
        //setMyRefreshFooter()
        
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
        
        view.addSubview(photoBrowserCollectionView)
        view.addSubview(clearBtn)
        
        //setRefreshHeader()
        setRefreshFooter()
        
        /// 进来后先等待数据
        view.showLoadingHUD()
        //view.showFullLoading()
    }
    
    
    func viewAtIndex(index: Int) -> UIView? {
        let cell = photoBrowserCollectionView.cellForItem(at: IndexPath(row: index, section: 0))
        return cell?.contentView
    }
    

    func setRefreshHeader() {
        refreshHeader.setTitle("下拉刷新数据", for: .idle)
        refreshHeader.setTitle("请松开", for: .pulling)
        refreshHeader.setTitle("刷新...", for: .refreshing)
        refreshHeader.lastUpdatedTimeLabel?.isHidden = true
        refreshHeader.setRefreshingTarget(self, refreshingAction: #selector(headerRefresh))
        photoBrowserCollectionView.mj_header = refreshHeader
    }

    func setRefreshFooter() {
        refreshFooter.setTitle("点击或上拉刷新数据", for: .idle)
        refreshFooter.setTitle("正在加载数据", for: .refreshing)
        refreshFooter.setTitle("数据加载完毕", for: .noMoreData)
        refreshFooter.setRefreshingTarget(self, refreshingAction: #selector(footerRefresh))
        //是否自动加载（默认为true，即表格滑到底部就自动加载）
        refreshFooter.isAutomaticallyRefresh = false
        photoBrowserCollectionView.mj_footer = refreshFooter
    }
}


// MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension PhotoBrowserViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView.tag == PhotoCollectionViewTag {
            //return imageArr?.count ?? 0
            return imageDatas.count
        } else {
            return 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView.tag == PhotoCollectionViewTag {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kPhotoCellID, for: indexPath) as! PhotoViewCell
            //cell.image = imageArr![indexPath.item]
            cell.image = imageDatas[indexPath.item].imageName
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kPhotoCellID, for: indexPath)
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView.tag == PhotoCollectionViewTag {
            let imageBrowser = YBImageBrowser()
            imageBrowser.dataSourceArray = imageDatas
            imageBrowser.currentPage = indexPath.item
            imageBrowser.show()
        }
    }
}


// MARK: - 事件监听函数
extension PhotoBrowserViewController {
    
    /// 下拉刷新
    @objc func headerRefresh() {
        
        photoVM.getRefreshPhotos(deviceId: deviceId, success: { (result) in
            
            guard let images = result as? [String] else { return }
            self.imageArr = (self.imageArr ?? []) + images
            self.photoBrowserCollectionView.mj_header?.endRefreshing()
            
        }) { (error) in
            
            self.photoBrowserCollectionView.mj_header?.endRefreshing()
            if error == NO_MORE_PHOTO {
                self.view.showTip(tip: "百胜吊篮：尚无更多图片！", position: .bottomCenter)
            } else {
                self.view.showTip(tip: "百胜吊篮：图片数据请求失败！", position: .bottomCenter)
            }
            
        }
        
        /*
        basketDetailVM.getRefreshPhotos(deviceId: deviceId, success: { (result) in
            //print("刷新请求数据： \(result)")
            guard let images = result as? [String] else { return }
            self.imageArr = (self.imageArr ?? []) + images
            self.photoBrowserCollectionView.mj_header?.endRefreshing()
        }) { (error) in
            self.photoBrowserCollectionView.mj_header?.endRefreshing()
            if error == NO_MORE_PHOTO {
                self.view.showTip(tip: "百胜吊篮：尚无更多图片！", position: .bottomCenter)
            } else {
                self.view.showTip(tip: "百胜吊篮：图片数据请求失败！", position: .bottomCenter)
            }
            
        }
        */
    }
    
    /// 上拉刷新
    @objc func footerRefresh() {
        
        photoVM.getRefreshPhotos(deviceId: deviceId, success: { (result) in
            
            guard let images = result as? [String] else { return }
            self.imageArr = (self.imageArr ?? []) + images
            self.photoBrowserCollectionView.mj_footer?.endRefreshing()
            
        }) { (error) in
            
            self.photoBrowserCollectionView.mj_footer?.endRefreshing()
            if error == NO_MORE_PHOTO {
                self.view.showTip(tip: "百胜吊篮：尚无更多图片！", position: .bottomCenter)
            } else {
                self.view.showTip(tip: "百胜吊篮：图片数据请求失败！", position: .bottomCenter)
            }
            
        }
        
        
        /*
        basketDetailVM.getRefreshPhotos(deviceId: deviceId, success: { (result) in
            //print("刷新请求数据： \(result)")
            guard let images = result as? [String] else { return }
            self.imageArr = (self.imageArr ?? []) + images
            self.photoBrowserCollectionView.mj_footer?.endRefreshing()
        }) { (error) in
            self.photoBrowserCollectionView.mj_footer?.endRefreshing()
            if error == NO_MORE_PHOTO {
                self.view.showTip(tip: "百胜吊篮：尚无更多图片！", position: .bottomCenter)
            } else {
                self.view.showTip(tip: "百胜吊篮：图片数据请求失败！", position: .bottomCenter)
            }
            
        }
        */
        
    }
    
    @objc private func clearBtnClicked() {
        SDImageCache.shared.clearMemory()
        SDImageCache.shared.clearDisk {
            self.view.ybib_showHookToast("清理完成")
        }
    }
}

// MARK: - FloatingViewDelegate
extension PhotoBrowserViewController: FloatingViewDelegate {
    
    func viewDraggingDidBegin(view: UIView, in window: UIWindow?) {
        UIView.animate(withDuration: 0.4) {
            view.alpha = 0.8
        }
    }
    
    func viewDraggingDidEnd(view: UIView, in window: UIWindow?) {
        (view as? UIButton)?.cancelTracking(with: nil)
        UIView.animate(withDuration: 0.4) {
            view.alpha = 1.0
        }
    }
    
}
