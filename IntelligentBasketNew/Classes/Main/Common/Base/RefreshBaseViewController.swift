//
//  RefreshBaseViewController.swift
//  IntelligentBasket
//
//  Created by 卢卓桓 on 2019/8/23.
//  Copyright © 2019 zhineng. All rights reserved.
//

/*
 * 需要下拉刷新和上拉刷新的页面可以继承此控制器
 */

import UIKit
import MJRefresh


class RefreshBaseViewController: RoleBaseViewController {
    
    let kRefreshCellIID = "kRefreshCellIID"
    private var itemSizeH: CGFloat = 0
    private var itemSizeW: CGFloat = kScreenW
    
    // MARK: - 懒加载属性
    lazy var collectionView: UICollectionView = { [unowned self] in
        /// 创建布局
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: itemSizeW, height: itemSizeH)//self.view.bounds.size
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        
        /// 创建UICollectionView
        let collectionView = UICollectionView(frame: self.view.bounds, collectionViewLayout: layout)
        collectionView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        collectionView.backgroundColor = contentBgColor
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: kRefreshCellIID)
        
        return collectionView
    }()
    
    private lazy var refreshHeader = MJRefreshNormalHeader()
    
    private lazy var refreshFooter = MJRefreshAutoNormalFooter()

    override func viewDidLoad() {
        super.viewDidLoad()
        itemSizeH = kScreenH - kStatusBarH - self.getNavigationBarH() - kPageMenuH -  (tabBarController?.tabBar.frame.height ?? 0)
        view.addSubview(collectionView)
        //setRefreshHeader()
        //setRefreshFooter()
    }
    
    
}


// MARK: - 设置下拉、上拉刷新
extension RefreshBaseViewController {
    func setRefreshHeader() {
        refreshHeader.setTitle("下拉刷新数据", for: .idle)
        refreshHeader.setTitle("请松开", for: .pulling)
        refreshHeader.setTitle("刷新...", for: .refreshing)
        refreshHeader.lastUpdatedTimeLabel?.isHidden = true
        refreshHeader.setRefreshingTarget(self, refreshingAction: #selector(headerRefresh))
        collectionView.mj_header = refreshHeader
    }
    
    func setRefreshFooter() {
        //refreshFooter.setTitle("点击或上拉刷新数据", for: .idle)
        refreshFooter.setTitle("", for: .idle)
        refreshFooter.setTitle("正在加载数据", for: .refreshing)
        refreshFooter.setTitle("数据加载完毕", for: .noMoreData)
        refreshFooter.setRefreshingTarget(self, refreshingAction: #selector(footerRefresh))
        //是否自动加载（默认为true，即表格滑到底部就自动加载）
        refreshFooter.isAutomaticallyRefresh = false
        collectionView.mj_footer = refreshFooter
    }
    
    @objc func headerRefresh(){
        //print("header refresh...")
        //重现加载表格数据
        collectionView.reloadData()
        //结束刷新
        collectionView.mj_header?.endRefreshing()
    }

    @objc func footerRefresh(){
        //print("foter refresh...")
        //重现加载表格数据
        collectionView.reloadData()
        //结束刷新
        collectionView.mj_footer?.endRefreshing()
    }
    
    func headerEndRefreshing() {
        collectionView.mj_header?.endRefreshing()
    }
    
    func footerEndRefreshing() {
        collectionView.mj_footer?.endRefreshing()
    }
    
    func disablFooter() {
        collectionView.mj_footer?.isHidden = true;
    }
    
    func enabelFooter() {
        collectionView.mj_footer?.isHidden = false;
    }
    
    func disableHeader() {
        collectionView.mj_header?.isHidden = true;
    }
    
    func enableHeader() {
        collectionView.mj_header?.isHidden = false;
    }
}


extension RefreshBaseViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kRefreshCellIID, for: indexPath)
        return cell
    }
    
}

// MARK: - 对外暴露的方法
extension RefreshBaseViewController {
    
    func registerCollectoinViewCell(cellClass: AnyClass?) {
        collectionView.register(cellClass, forCellWithReuseIdentifier: kRefreshCellIID)
    }
    
    func registerCollectionViewCell(nibName: String) {
        collectionView.register(UINib(nibName: nibName, bundle: nil), forCellWithReuseIdentifier: kRefreshCellIID)
    }
    
    func setItemSizeH(itemSizeH: CGFloat) {
        self.itemSizeH = itemSizeH
    }
    
    func setItemSizeW(itemSizeW: CGFloat) {
        self.itemSizeW = itemSizeW
    }
}

