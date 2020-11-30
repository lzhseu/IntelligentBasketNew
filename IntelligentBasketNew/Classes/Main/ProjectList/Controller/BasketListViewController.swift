//
//  BasketListViewController.swift
//  IntelligentBasket
//
//  Created by 卢卓桓 on 2019/10/17.
//  Copyright © 2019 zhineng. All rights reserved.
//

import UIKit

private let kItemW = kScreenW
private let kItemH: CGFloat = 148//kItemW / 3 + 10

class BasketListViewController: RefreshBaseViewController {

    // MARK: - 自定义属性
    var projectId: String?
    var projectName: String?
    
    // MARK: - 懒加载属性
    private lazy var usingBasketVM = UsingBasketViewModel()
        
    private lazy var usingBasketGroup = [UsingBasketModel]()
    
    
    
    // MARK: - 系统回调函数
    override func viewDidLoad() {
        /// 注册cell
        setItemSizeH(itemSizeH: kItemH)
        registerCollectionViewCell(nibName: "BasketListViewCell")
        
        /// 加载页面
        super.viewDidLoad()
        
        /// 设置UI
        setUI()
        
        // 设置上拉刷新
        setRefreshFooter()
        
        /// 请求数据
        loadData(isRefresh: false)
    }
    
    init(projectId: String?, projectName: String?) {
        super.init(nibName: nil, bundle: nil)
        self.projectId = projectId
        self.projectName = projectName
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setUI() {
        setNavigationBarTitle(title: projectName)
    }
}


// MARK: - 请求网络数据
extension BasketListViewController {
    private func loadData(isRefresh: Bool) {
        
        guard let projectId = projectId else {
            self.LoadNoBasketPage()
            disablFooter()
            return
        }
        
        usingBasketVM.requestAllBasket(projectId: projectId, viewController: self, finishedCallBack: {
            
            ///拿到数据
            self.usingBasketGroup = self.usingBasketVM.usingBasketGroup
            
            if self.usingBasketGroup.count == 0 {
                self.LoadNoBasketPage()
                self.disablFooter()
            } else {
                self.removeNoBasketPage()
                self.enabelFooter()
            }
            
            /// 刷新表格数据
            self.collectionView.reloadData()
            
            if isRefresh {
                self.footerEndRefreshing()  //如果是刷新数据（不是第一次请求），那么刷新后要手动停止刷新
            }
        }) {
            self.view.showTip(tip: kNetWorkErrorTip, position: .bottomCenter)
        }
    }
    
}


// MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension BasketListViewController  {
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return usingBasketGroup.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kRefreshCellIID, for: indexPath) as! BasketListViewCell
        cell.usingBasketModel = usingBasketGroup[indexPath.item]
        cell.superController = self
        //print(cell.usingBasketModel?.workingState)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        //let deviceId = usingBasketGroup[indexPath.item].deviceId
        //navigationController?.pushViewController(BasketDetailViewController(deviceId: deviceId), animated: true)
    }
    
}


// MARK: - 事件监听函数
extension BasketListViewController {
    /// 下拉刷新
    override func headerRefresh() {
    }
    
    /// 上拉刷新
    override func footerRefresh() {
        loadData(isRefresh: true)
    }
}
