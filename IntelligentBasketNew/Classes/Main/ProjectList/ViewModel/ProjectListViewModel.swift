//
//  ProjectListViewModel.swift
//  IntelligentBasket
//
//  Created by 卢卓桓 on 2019/10/22.
//  Copyright © 2019 zhineng. All rights reserved.
//

import UIKit

// 每页最大返回数
private let kMaxCountPerPager: Int = 5

class ProjectListViewModel {
    lazy var projectList = [ProjectInfoModel]()
    lazy var searchProjectList = [ProjectInfoModel]()  // 通过搜索得到的结果
    lazy var projectListUsing = [ProjectInfoModel]()
    lazy var projectListInstalling = [ProjectInfoModel]()
    lazy var projectListCompleted = [ProjectInfoModel]()
    
    //搜索是否要再进行的标志
    //如果上一次搜到了相关项目，但全不属于监管人员的权限范围内，则为 true。表示可以再尝试请求
    //只要搜到了，那么就为 false
    var searchFlag = false
}

// MARK: - 请求网络数据
extension ProjectListViewModel {
    
    ///////// 20200506 修改：新增了 isSearch ////////////////
    
    func requestProjectList(keyWord: String, type: Int, pageNum: Int, isSearch: Bool,  viewController: UIViewController, finishedCallBack: @escaping () -> (), errorCallBack: @escaping () -> ()) {
        
        searchFlag = false
        
        if pageNum == 1 {
            searchProjectList = []
        }
        
        let token = UserDefaultStorage.getToken() ?? ""
        let parameters = ["keyWord": keyWord, "type": type, "pageNum": pageNum] as [String : Any]
        
        //print(parameters)
        
        HttpTools.requestDataURLEncoding(URLString: getProjectListByKeyURL, method: .GET, parameters: parameters,token: token, finishedCallBack: { (result) in
            //print(result)
            
            guard let resDict = result as? [String: Any] else { return }
            
            let isLogin = resDict["isLogin"] as? Bool ?? false
            if !isLogin {
                AlertBox.createForInvalidToken(title: "警告", message: "权限认证失败！", viewController: viewController)
                return
            }
            
            /// 取出数据
            guard let projectList = resDict["projectList"] as? [[String: Any]] else { return }
            
            
            print("请求参数：\(parameters)")
            /*
             * 20200506 新增
             */
            if projectList.count != 0 {
                if isSearch {
                    ProjectListViewController.pageIndx4Area += 1
                } else {
                    switch type {
                    case kUsingProjectType:
                        ProjectListViewController.pageIndx4Using += 1
                    case kInstallingProjectType:
                        ProjectListViewController.pageIndx4Installing += 1
                    case kCompletedProjectType:
                        ProjectListViewController.pageIndx4Completed += 1
                    case kSearchByPageType:
                        ProjectListViewController.pageIndx4Page += 1
                    default:
                        break
                    }
                }
            }
            ///////////////////////////////////////////////////////////////
            
            
            /** 20200506 注释
            /// 更新页码
            if projectList.count != 0 {
                switch type {
                case kUsingProjectType:
                    ProjectListViewController.pageIndx4Using += 1
                case kInstallingProjectType:
                    ProjectListViewController.pageIndx4Installing += 1
                case kCompletedProjectType:
                    ProjectListViewController.pageIndx4Completed += 1
                case kSearchByPageType:
                    ProjectListViewController.pageIndx4Page += 1
                case kSearchByAreaType:
                    ProjectListViewController.pageIndx4Area += 1
                default:
                    break
                }
            }
            */
            
            // 真正符合条件的项目计数
            var realSearchCount: Int = 0
            // 有搜到项目，但是不一定是属于我的权限，这时如果所有搜到的项目中都不是我要的，那么会尝试再搜一次
            //var isRealSearch = false
            
            /// 遍历数组
            for dict in projectList {
                guard let projectInfoModel = try? DictConvertToModel.JSONModel(ProjectInfoModel.self, withKeyValues: dict) else {
                    print("ProjectInfoModel: Json To Model Failed")
                    continue
                }
                
                /// 判断是不是属于监管人员的监管范围
                guard let region = dict["region"] as? String else {
                    continue
                }
                
                guard let userPerms = UserDefaultStorage.getUserPerm() else {
                    return
                }
                let userPermArr: [String] = userPerms.split(separator: ",").compactMap{ "\($0)" }
                
                var regionOK = false
                for userPerm in userPermArr {
                    
                    let isContain = region.containsIgnoringCase(find: userPerm)
                    //print("isContain: \(isContain)")
                    
                    if isContain {
                        regionOK = true
                        break
                    }
                }
                if !regionOK {
                    continue
                }
                /*
                guard let regions = dict["region"] as? String else {
                    continue
                }
                let regionArr: [String] = regions.split(separator: ",").compactMap{ "\($0)" }
                
                guard let userPerms = UserDefaultStorage.getUserPerm() else {
                    return
                }
                let userPermArr: [String] = userPerms.split(separator: ",").compactMap{ "\($0)" }
                
                var regionOK = false
                for region in regionArr {
                    
                    let isContain = userPermArr.contains(region)
                    print("isContain: \(isContain)")
                    
                    if isContain {
                        regionOK = true
                        break
                    }
                }
                if !regionOK {
                    continue
                }
                */
                /// 把吊篮编号转成数组，方便之后使用
                let boxList = dict["boxList"] as? String
                let strArr: [String] = boxList?.split(separator: ",").compactMap{ "\($0)" } ?? []
                projectInfoModel.deviceIds = strArr
                
                /// 解析经纬度
                let coordinate = dict["coordinate"] as? String
                let coordinateArr: [String] = coordinate?.split(separator: ",").compactMap{ "\($0)" } ?? []
                if coordinateArr.count == 2 {
                    projectInfoModel.longitude = coordinateArr[0]
                    projectInfoModel.latitude = coordinateArr[1]
                } else {
                    projectInfoModel.longitude = ""
                    projectInfoModel.latitude = ""
                }
                
                
                /*
                 * 20200506 新增
                 * 20200507 新增一层判断
                 */
                //在外面新增一层判断，判断项目的 region 是否在 userPerm 里面
                if isSearch {
                    self.searchProjectList.append(projectInfoModel)
                    realSearchCount = realSearchCount + 1
                } else {
                    switch type {
                    case kUsingProjectType:
                        self.projectListUsing.append(projectInfoModel)
                    case kInstallingProjectType:
                        self.projectListInstalling.append(projectInfoModel)
                    case kCompletedProjectType:
                        self.projectListCompleted.append(projectInfoModel)
                    case kSearchByPageType:
                        self.projectList.append(projectInfoModel)
                    default: break
                    }
                }
                
                //////////////////////////////////////////////////////
                
                /* 20200506 注释
                /// 根据类型更新数组
                switch type {
                case kUsingProjectType:
                    self.projectListUsing.append(projectInfoModel)
                case kInstallingProjectType:
                    self.projectListInstalling.append(projectInfoModel)
                case kCompletedProjectType:
                    self.projectListCompleted.append(projectInfoModel)
                case kSearchByPageType:
                    self.projectList.append(projectInfoModel)
                case kSearchByAreaType:
                    self.searchProjectList.append(projectInfoModel)
                default: break
                }
                */
                
            }
            
            //print("realSearchCount: \(realSearchCount)")
            
            if realSearchCount <= projectList.count && realSearchCount > 0 {
                self.searchFlag = false
            } else if projectList.count > 0 && projectList.count == kMaxCountPerPager {
                //搜到了，但全部不属于我的权限，说明有可能在后面的分页中
                self.searchFlag = true
            } else {
                self.searchFlag = false
            }
            //print("searchFlag: \(self.searchFlag)")
            
            finishedCallBack()
            
        })
        { (error) in
            print("RequestProjectList error: \(error)")
            errorCallBack() //错误回调
        }
    }

    
}
