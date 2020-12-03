//
//  ProjectListViewController.swift
//  IntelligentBasket
//
//  Created by 卢卓桓 on 2019/10/17.
//  Copyright © 2019 zhineng. All rights reserved.
//

import UIKit
import SnapKit
import SideMenu
import MJRefresh
import SwiftyFloatingView

private let kItemW = kScreenW
private let kItemH: CGFloat = 180  //kItemW / 3 + 40
private let kSearchBoxH: CGFloat = 60
private let kToTopBtnWH: CGFloat = 50
let kSearchByAreaType: Int = 1
let kSearchByPageType: Int = 2
let kUsingProjectType: Int = 32
let kInstallingProjectType: Int = 31
let kCompletedProjectType: Int = 30
let kEmptyKeyWord = "  "
let kFirstPageIndex: Int = 1
private let kTableCellID = "ProjectTableCell"
private let kProjectInfoCell = "projectInfoCell"


class ProjectListViewController: RoleBaseViewController {

    // MARK: - 懒加载属性
    private lazy var sideMenuViewController = MoreInfoViewController()
    private lazy var projectListVM = ProjectListViewModel()
    private lazy var projectListSearchByPage = [ProjectInfoModel]()
    private lazy var projectListSearchByArea = [ProjectInfoModel]()
    private lazy var projectListUsing = [ProjectInfoModel]()
    private lazy var projectListInstalling = [ProjectInfoModel]()
    private lazy var projectListCompleted = [ProjectInfoModel]()
    private lazy var refreshHeader = MJRefreshNormalHeader()
    private lazy var refreshFooter = MJRefreshAutoNormalFooter()
    private lazy var toTopFlowBtn: SwiftyFloatingView = {
        let normalButton:UIButton = UIButton(type: UIButton.ButtonType.system)
        normalButton.backgroundColor = primaryColor_0_5
        normalButton.frame = CGRect(x: 0, y: 0, width: kToTopBtnWH, height: kToTopBtnWH)
        normalButton.layer.cornerRadius = kToTopBtnWH / 2
        normalButton.setTitle("置顶", for: .normal)
        normalButton.setTitleColor(UIColor.white, for: .normal)
        normalButton.addTarget(self, action: #selector(toTopBtnClicked), for: .touchUpInside)
        var floatingView = SwiftyFloatingView(with: normalButton)
        floatingView.delegate = self
        floatingView.setFrame(CGRect(x: (UIScreen.main.bounds.width - normalButton.frame.width) * 0.95, y: (UIScreen.main.bounds.height - normalButton.frame.height) * 0.95, width: normalButton.frame.width, height: normalButton.frame.height))
        return floatingView
    }()
    private lazy var tableView: UITableView = { [unowned self] in
        let tableView = UITableView(frame: self.view.bounds, style: .plain)
        tableView.backgroundColor = contentBgColor
        tableView.dataSource = self
        tableView.delegate = self
        //tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        //tableView.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: 44, right: 0)
        tableView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        tableView.rowHeight = kItemH
        tableView.register(UINib(nibName: "ProjectInfoViewCell", bundle: nil), forCellReuseIdentifier: kProjectInfoCell)
        tableView.tableFooterView = UIView(frame: .zero)
        tableView.separatorStyle = .none
        //tableView.contentInsetAdjustmentBehavior = .never
        //以下代码关闭估算行高,从而解决底下留白的bug
        tableView.estimatedRowHeight = 0;
        tableView.estimatedSectionHeaderHeight = 0;
        tableView.estimatedSectionFooterHeight = 0;
        // 改变索引的颜色
        //tableView.sectionIndexColor = UIColor.black
        // 改变索引背景颜色
        //tableView.sectionIndexBackgroundColor = UIColor.clear
        // 改变索引被选中的背景颜色
        // table.sectionIndexTrackingBackgroundColor = UIColor.green
        return tableView
    }()


    // MARK: - 自定义属性
    static var pageIndx4Area: Int = kFirstPageIndex
    static var pageIndx4Page: Int = kFirstPageIndex
    static var pageIndx4Using: Int = kFirstPageIndex
    static var pageIndx4Installing: Int = kFirstPageIndex
    static var pageIndx4Completed: Int = kFirstPageIndex
    private var lastKeyWord = kEmptyKeyWord
    private var searchType: Int = kSearchByPageType
    private var searchController: LZHSearchController?
    private var isInSearchState: Bool = false
    private var type: Int = 0
    private var userPerm: String = ""
    private var tableViewOffsety: CGFloat = 0;

    private var isSearch: Bool = false

    private let searchDataGroup = OperationQueue.main

    // MARK: - 系统回调函数
    override func viewDidLoad() {
        /// 加载页面
        super.viewDidLoad()


        /// 设置其他UI
        setUI()
        setSideMenu()

        // 设置上拉刷新
        setRefreshFooter()

        /// 请求数据
        isSearch = false
        lastKeyWord = userPerm
        loadData(isRefresh: false, keyWord: userPerm, type: type, isSearch: isSearch, pageNum: ProjectListViewController.pageIndx4Page)
    }

    override func viewWillAppear(_ animated: Bool) {
        toTopFlowBtn.show()
    }

    override func viewWillDisappear(_ animated: Bool) {
        toTopFlowBtn.hide()
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    init(type: Int, userPerm: String) {
        super.init(nibName: nil, bundle: nil)
        self.type = type
        self.userPerm = userPerm
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - 重新父类方法
    override func setUI() {
        setNavigationBar(title: "")            //设置导航栏
        view.backgroundColor = contentBgColor  //设置背景颜色
        searchController = LZHSearchController(searchResultsController: nil)
        searchController?.obscuresBackgroundDuringPresentation = false
        searchController?.lzhDelegate = self
        self.definesPresentationContext = true //这是能push成功的关键
        tableView.tableHeaderView = searchController?.searchBar
        view.addSubview(tableView)
    }

    override func setNavigationBar(title: String?) {
        super.setNavigationBar(title: title)
        /*
        let btn = UIButton()
        btn.setTitle("项目列表", for: .normal )
        btn.titleLabel?.font = UIFont.systemFont(ofSize: kNavigationTitleFontSize)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: btn)
        */

        // 设置右边的按钮
        let moreItem = UIBarButtonItem(image: UIImage(named: "more"), style: .plain, target: self, action: #selector(moreBtnClick))
        //let searchItem = UIBarButtonItem(image: UIImage(named: "search"), style: .plain, target: self, action: #selector(searchBtnClick))
        //navigationItem.rightBarButtonItems = [moreItem, searchItem]
        let mapItem = UIBarButtonItem(image: UIImage(named: "Map-Pin"), style: .plain, target: self, action: #selector(mapBtnClick))
        navigationItem.rightBarButtonItems = [moreItem, mapItem]

    }

}

// MARK: - 搜索栏代理 LZHSearchControllerDelegate
extension ProjectListViewController: LZHSearchControllerDelegate {

    func lzhDidSearch() {
        guard let keyWord = searchController?.searchBar.text else {
            view.showTip(tip: "百胜吊篮：输入无效！", position: .bottomCenter)
            return
        }
        lastKeyWord = keyWord
        ProjectListViewController.pageIndx4Area = kFirstPageIndex
        isSearch = true



        searchData(patten: keyWord, isRefresh: false)

        // 20200523注释
        //loadData(isRefresh: false, keyWord: keyWord, type: type, isSearch: isSearch, pageNum: ProjectListViewController.pageIndx4Area)


        tableViewOffsety = tableView.bounds.origin.y  //记录tableView y 方向的偏移量
    }


    func lzhCancelSearch() {
        searchType = type
        lastKeyWord = userPerm
        ProjectListViewController.pageIndx4Area = kFirstPageIndex
        isSearch = false

        switch searchType {
        case kUsingProjectType:
            if projectListUsing.count != 0 {
                self.removeNoProjectPage()
                self.enabelFooter()
            } else {
                self.loadNoProjectPage()
                self.disablFooter()
            }
        case kInstallingProjectType:
            if projectListInstalling.count != 0 {
                self.removeNoProjectPage()
                self.enabelFooter()
            } else {
                self.loadNoProjectPage()
                self.disablFooter()
            }
        case kCompletedProjectType:
            if projectListCompleted.count != 0 {
                self.removeNoProjectPage()
                self.enabelFooter()
            } else {
                self.loadNoProjectPage()
                self.disablFooter()
            }
        default:
            break
        }

        isInSearchState = false
        tableView.reloadData()
    }

    func lzhBeginEdit() {
        isInSearchState = true
    }

}


// MARK: - 事件监听函数
extension ProjectListViewController {
    @objc private func moreBtnClick() {
        self.present(SideMenuManager.default.rightMenuNavigationController!, animated: true, completion: nil)
        
    }

    @objc private func mapBtnClick() {
        var proList: [ProjectInfoModel]?
        switch searchType {
        case kUsingProjectType:
            proList = projectListUsing
        case kInstallingProjectType:
            proList = projectListInstalling
        case kCompletedProjectType:
            proList = projectListCompleted
        default:
            break
        }
        // TODO
        
        pushViewController(viewController: BaiduMapMainViewController(projectList: proList ?? []), animated: true)
        
    }

    @objc private func toTopBtnClicked() {
        if isInSearchState {
            //tableView.setContentOffset(CGPoint(x: 0, y: -navigationController!.navigationBar.bounds.height), animated: true)
            tableView.setContentOffset(CGPoint(x: 0, y: tableViewOffsety), animated: true)
        } else {
            tableView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        }
    }
}



// MARK: - 网络请求
extension ProjectListViewController {


    private func recursiveRequest(patten: String, isRefresh: Bool) {

        projectListVM.requestProjectList(keyWord: patten, type: self.type, pageNum: ProjectListViewController.pageIndx4Area, isSearch: true, viewController: self, finishedCallBack: {

            if self.projectListVM.searchFlag {
                //print("再来一次~~~~~")
                self.recursiveRequest(patten: patten, isRefresh: isRefresh)

            } else {
                //print("不要了~~~~~~~")

                self.projectListSearchByArea = self.projectListVM.searchProjectList

                if self.projectListSearchByArea.count == 0 {
                    self.loadNoProjectPage()
                    self.disablFooter()
                } else {
                    self.removeNoProjectPage()
                    self.enabelFooter()
                }

                if isRefresh {
                    self.footerEndRefreshing()  //如果是刷新数据（不是第一次请求），那么刷新后要手动停止刷新
                }
                self.tableView.reloadData()
            }



        }, errorCallBack: {
            self.view.showTip(tip: kNetWorkErrorTip, position: .bottomCenter)
        })
    }

    private func searchData(patten: String, isRefresh: Bool) {

        ///1. 如果搜索模式不在 userPerm 字段内，则直接给出无结果
        guard let userPerm = UserDefaultStorage.getUserPerm() else {
            self.projectListSearchByArea = []
            self.loadNoProjectPage()
            self.disablFooter()
            self.tableView.reloadData()
            return
        }

        if !userPerm.containsIgnoringCase(find: patten) {
            self.projectListSearchByArea = []
            self.loadNoProjectPage()
            self.disablFooter()
            self.tableView.reloadData()
            return
        }

        ///2. 如果搜索模式在 userPerm 字段内，则一定可以搜出结果，除非系统中没有数据
        recursiveRequest(patten: patten, isRefresh: isRefresh)

    }



    /*
     * 新增变量 isSearch
     */
    private func loadData(isRefresh: Bool, keyWord: String, type: Int, isSearch: Bool, pageNum: Int) {
        // TODO: 网络请求
        projectListVM.requestProjectList(keyWord: keyWord, type: type, pageNum: pageNum, isSearch: isSearch, viewController: self, finishedCallBack: {

            self.searchType = type
            self.projectListSearchByPage = self.projectListVM.projectList
            self.projectListSearchByArea = self.projectListVM.searchProjectList
            self.projectListUsing = self.projectListVM.projectListUsing
            self.projectListInstalling = self.projectListVM.projectListInstalling
            self.projectListCompleted = self.projectListVM.projectListCompleted


            /// 若无数据，则加载空页面
            if isSearch {
                if self.projectListSearchByArea.count == 0 {
                    self.loadNoProjectPage()
                    self.disablFooter()
                } else {
                    self.removeNoProjectPage()
                    self.enabelFooter()
                }
            } else {
                switch type {
                case kUsingProjectType:
                    if self.projectListUsing.count == 0 {
                        self.loadNoProjectPage()
                        self.disablFooter()
                    } else {
                        self.removeNoProjectPage()
                        self.enabelFooter()
                    }
                case kInstallingProjectType:
                    if self.projectListInstalling.count == 0 {
                        self.loadNoProjectPage()
                        self.disablFooter()
                    } else {
                        self.removeNoProjectPage()
                        self.enabelFooter()
                    }
                case kCompletedProjectType:
                    if self.projectListCompleted.count == 0 {
                        self.loadNoProjectPage()
                        self.disablFooter()
                    } else {
                        self.removeNoProjectPage()
                        self.enabelFooter()
                    }
                case kSearchByPageType:
                    if self.projectListSearchByPage.count == 0 {
                        self.loadNoProjectPage()
                        self.disablFooter()
                    } else {
                        self.removeNoProjectPage()
                        self.enabelFooter()
                    }
                case kSearchByAreaType:
                    if self.projectListSearchByArea.count == 0 {
                        self.loadNoProjectPage()
                        self.disablFooter()
                    } else {
                        self.removeNoProjectPage()
                        self.enabelFooter()
                    }
                default:
                    break
                }
            }


            /// 刷新表格数据
            self.tableView.reloadData()

            if isRefresh {
                self.footerEndRefreshing()  //如果是刷新数据（不是第一次请求），那么刷新后要手动停止刷新
            }

        }) {
            //error
            self.view.showTip(tip: kNetWorkErrorTip, position: .bottomCenter)
        }
    }


}


// MARK: - 侧边栏
extension ProjectListViewController {
    func setSideMenu() {
        
        sideMenuViewController = UIStoryboard(name: "MoreInfo", bundle: nil).instantiateViewController(withIdentifier: "moreInfo") as! MoreInfoViewController
        sideMenuViewController.delegate = self
        
        let sideMenu = SideMenuNavigationController(rootViewController: sideMenuViewController)
        SideMenuManager.default.rightMenuNavigationController = sideMenu //将其作为默认的右侧菜单
        
        sideMenu.isNavigationBarHidden = true                            //隐藏导航栏
        sideMenu.statusBarEndAlpha = 0;                                  //阻止状态栏背景变黑
        sideMenu.presentationStyle = LZHSideMenuPresentationStyle()
        let screenWidth = UIScreen.main.bounds.width                     // 屏幕宽度
        let screenHeight = UIScreen.main.bounds.height                   // 屏幕高度
        sideMenu.menuWidth = round(min(screenWidth, screenHeight) * 0.7)
        
    }
}


// MARK: - 侧边栏代理
extension ProjectListViewController: MoreInfoViewControllerDelegate {
    func moreInfoViewControllerWillDisappear() {
        toTopFlowBtn.show()
    }

    func moreInfoViewControllerWillAppear() {
        toTopFlowBtn.hide()
    }


    func moreInfoViewController(selected projectId: String) {
        //
    }

    func moreInfoViewControllerLogout() {
        ProjectListViewController.pageIndx4Area = kFirstPageIndex
        ProjectListViewController.pageIndx4Page = kFirstPageIndex
        ProjectListViewController.pageIndx4Using = kFirstPageIndex
        ProjectListViewController.pageIndx4Installing = kFirstPageIndex
        ProjectListViewController.pageIndx4Completed = kFirstPageIndex
        UserDefaultStorage.removeToken()
        dismiss(animated: false, completion: nil)
    }

}


// MARK: - UITableViewDelegate, UITableViewDataSource
extension ProjectListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if isSearch {
            return projectListSearchByArea.count
        } else {
            switch searchType {
            case kUsingProjectType:
                return projectListUsing.count
            case kInstallingProjectType:
                return projectListInstalling.count
            case kCompletedProjectType:
                return projectListCompleted.count
            case kSearchByPageType:
                return projectListSearchByPage.count
            default:
                return 0
            }
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: kProjectInfoCell) as! ProjectInfoViewCell
        if isSearch {
            cell.projectInfoModel = self.projectListSearchByArea[indexPath.item]
        } else {
            switch searchType {
            case kUsingProjectType:
                cell.projectInfoModel = self.projectListUsing[indexPath.item]
            case kInstallingProjectType:
                cell.projectInfoModel = self.projectListInstalling[indexPath.item]
            case kCompletedProjectType:
                cell.projectInfoModel = self.projectListCompleted[indexPath.item]
            case kSearchByPageType:
                cell.projectInfoModel = self.projectListSearchByPage[indexPath.item]
            default:
                break
            }
        }

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var projectId: String?
        var projectName: String?
        print("点击：\(indexPath)")
        if isSearch {
            projectId = self.projectListSearchByArea[indexPath.item].projectId
            projectName = self.projectListSearchByArea[indexPath.item].projectName
        } else {
            switch searchType {
            case kUsingProjectType:
                projectId = self.projectListUsing[indexPath.item].projectId
                projectName = self.projectListUsing[indexPath.item].projectName
            case kInstallingProjectType:
                projectId = self.projectListInstalling[indexPath.item].projectId
                projectName = self.projectListInstalling[indexPath.item].projectName
            case kCompletedProjectType:
                projectId = self.projectListCompleted[indexPath.item].projectId
                projectName = self.projectListCompleted[indexPath.item].projectName
            case kSearchByPageType:
                projectId = self.projectListSearchByPage[indexPath.item].projectId
                projectName = self.projectListSearchByPage[indexPath.item].projectName
            default:
                break
            }
        }
        
        pushViewController(viewController: BasketListViewController(projectId: projectId, projectName: projectName), animated: true)
        tableView.deselectRow(at: indexPath, animated: false)
        
    }

}


// MARK: - 设置下拉、上拉刷新
extension ProjectListViewController {
    func setRefreshHeader() {
        refreshHeader.setTitle("下拉刷新数据", for: .idle)
        refreshHeader.setTitle("请松开", for: .pulling)
        refreshHeader.setTitle("刷新...", for: .refreshing)
        refreshHeader.lastUpdatedTimeLabel?.isHidden = true
        refreshHeader.setRefreshingTarget(self, refreshingAction: #selector(headerRefresh))
        tableView.mj_header = refreshHeader
    }

    func setRefreshFooter() {
        //refreshFooter.setTitle("点击或上拉刷新数据", for: .idle)
        refreshFooter.setTitle("", for: .idle)
        refreshFooter.setTitle("正在加载数据", for: .refreshing)
        refreshFooter.setTitle("数据加载完毕", for: .noMoreData)
        refreshFooter.setRefreshingTarget(self, refreshingAction: #selector(footerRefresh))
        //是否自动加载（默认为true，即表格滑到底部就自动加载）
        refreshFooter.isAutomaticallyRefresh = false
        tableView.mj_footer = refreshFooter
    }

    @objc func headerRefresh(){
        //重现加载表格数据
        tableView.reloadData()
        //结束刷新
        tableView.mj_header?.endRefreshing()
    }

    @objc func footerRefresh(){
        var pageNum = 1;
        if isSearch {
            pageNum = ProjectListViewController.pageIndx4Area
            searchData(patten: lastKeyWord, isRefresh: true)
        } else {
            switch searchType {
            case kUsingProjectType:
                pageNum = ProjectListViewController.pageIndx4Using
            case kInstallingProjectType:
                pageNum = ProjectListViewController.pageIndx4Installing
            case kCompletedProjectType:
                pageNum = ProjectListViewController.pageIndx4Completed
            case kSearchByPageType:
                pageNum = ProjectListViewController.pageIndx4Page
            default:
                break
            }

            loadData(isRefresh: true, keyWord: lastKeyWord, type: searchType, isSearch: isSearch, pageNum: pageNum)
        }



        //202005223 注释
        //loadData(isRefresh: true, keyWord: lastKeyWord, type: searchType, isSearch: isSearch, pageNum: pageNum)

    }

    func headerEndRefreshing() {
        tableView.mj_header?.endRefreshing()
    }

    func footerEndRefreshing() {
        tableView.mj_footer?.endRefreshing()
    }

    func disablFooter() {
        tableView.mj_footer?.isHidden = true;
    }

    func enabelFooter() {
        tableView.mj_footer?.isHidden = false;
    }

    func disableHeader() {
        tableView.mj_header?.isHidden = true;
    }

    func enableHeader() {
        tableView.mj_header?.isHidden = false;
    }
}


// MARK: - FloatingViewDelegate
extension ProjectListViewController: FloatingViewDelegate {

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


