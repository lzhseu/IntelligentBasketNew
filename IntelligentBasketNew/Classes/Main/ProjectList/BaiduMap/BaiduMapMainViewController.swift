////
////  BaiduMapMainViewController.swift
////  IntelligentBasket
////
////  Created by 卢卓桓 on 2019/11/13.
////  Copyright © 2019 zhineng. All rights reserved.
////
//
//import UIKit
//
class BaiduMapMainViewController: RoleBaseViewController,BMKMapViewDelegate,
    BMKPoiSearchDelegate,BMKLocationManagerDelegate{
    
    var mapview: BMKMapView!
    var userLocation:BMKUserLocation!
    lazy var searcher:BMKPoiSearch = {
        let searcher = BMKPoiSearch()
        searcher.delegate = self
        return searcher
    }()
    
    var projectList = [ProjectInfoModel]()

    init(projectList: [ProjectInfoModel]) {
        super.init(nibName: nil, bundle: nil)
        self.projectList = projectList
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
            super.viewDidLoad()
            mapview = BMKMapView.init(frame: self.view.bounds)
            self.view.addSubview(mapview)
            
            setNavigationBarTitle(title: "地图")
            
            //地图初始化
            let center = CLLocationCoordinate2DMake(32.061148, 118.800284)
            mapview.centerCoordinate = center
            
            let span = BMKCoordinateSpanMake(0.011929035022411938, 0.0078062748817018246)
            let region = BMKCoordinateRegionMake(center, span)
            mapview.setRegion(region, animated: true)
            
            mapview.zoomLevel = 13
            mapview.showMapScaleBar = true
            
            //定位设置
            mapview.showsUserLocation = true
            mapview.userTrackingMode = BMKUserTrackingModeHeading
            
            
            //for project in projectList 遍历
            for project in projectList {
                // 得到大头针对象
                let annotation = BMKPointAnnotation()
                
                // 经纬度获取
                let latitude = project.latitude
                let laptitude = project.longitude
                var latDouble: Double = 0.0
                var lapDouble: Double = 0.0
                
                if latitude != "" && laptitude != "" {
                    latDouble = Double(latitude!)!
                    lapDouble = Double(laptitude!)!
                }
                annotation.coordinate = CLLocationCoordinate2DMake(latDouble, lapDouble)
                
                annotation.title = project.projectName
                annotation.subtitle = project.projectId
                
                
                //annotation.title = "项目名称"  //projectList.name
                //annotation.subtitle = "项目位置" //arrlist.position
                //添加大头针
                mapview.addAnnotation(annotation)
                
            }
            
    //        let annotation = BMKPointAnnotation()
    //        annotation.coordinate = CLLocationCoordinate2DMake(32.061148, 118.800284)
    //        annotation.title = "项目名称"  //arrlist.title
    //        //annotation.subtitle = "项目位置" //arrlist.position
    //        //添加大头针
    //        mapview.addAnnotation(annotation)
            
        }
        override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            mapview.delegate = self
        }
        override func viewWillDisappear(_ animated: Bool) {
            super.viewWillDisappear(animated)
            mapview.delegate = nil
        }
    
    // 自定义大头针样式
//    func mapView(_ mapView: BMKMapView!, viewFor annotation: BMKAnnotation!) -> BMKAnnotationView! {
//        if annotation is BMKPointAnnotation {
//            let pinView = BMKPinAnnotationView(annotation: annotation, reuseIdentifier: "myAnnotation")
//            pinView?.animatesDrop = true
//            pinView?.annotation = annotation
//            pinView?.image = UIImage(named: "icon_map_basket")
//            print("自定义大头针1111")
//            return pinView
//        }
//        return nil
//    }
        
    //点击大头针弹框事件调用该方法
    func mapView(_ mapView: BMKMapView!, annotationViewForBubble view: BMKAnnotationView!) {
        let clickannotaiton = view.annotation
        //print("\(clickannotaiton?.coordinate ?? CLLocationCoordinate2DMake(32.061148, 118.800284))\(clickannotaiton?.title?() ?? "标题")\(clickannotaiton?.subtitle?() ?? "副标题")")
        
        //print("\(projectList)")
        
        let projectId = clickannotaiton?.subtitle?()
        let projectName = clickannotaiton?.title?()
        
        pushViewController(viewController: BasketListViewController(projectId: projectId, projectName: projectName), animated: true)
        //self.present(BasketListViewController(projectId: projectId, projectName: projectName), animated: true, completion: nil)
    }
        
    //定位信息更新
    func bmkLocationManager(_ manager: BMKLocationManager, didUpdate heading: CLHeading?) {
        if(!(heading != nil)){
            return
        }
        if(!(self.userLocation != nil)){
            self.userLocation = BMKUserLocation.init()
        }
        self.userLocation.heading = heading
        self.mapview.updateLocationData(self.userLocation)
    }
        
//        //长按搜索附近
//        func mapview(_ mapView: BMKMapView!, onLongClick coordinate: CLLocationCoordinate2D) {
//            //发起检索
//            let option = BMKPOINearbySearchOption()
//            //检索的第几页
//            option.pageIndex = 0
//            //每页检索的数量
//            option.pageSize = 20
//            //检索的区域
//            option.location = CLLocationCoordinate2DMake(32.061148, 118.800284)
//            //检索的关键字
//            option.keywords = ["超市"]
//            //开始检索
//            let flag = searcher.poiSearchNear(by: option)
//            if flag {
//                print("周边检索发送成功")
//            }else {
//                print("周边检索发送失败")
//            }
//        }
        
//        //回调长按搜索结果
//        func onGetPoiResult(_ searcher: BMKPoiSearch!, result poiResult: BMKPOISearchResult!, errorCode: BMKSearchErrorCode) {
//            if errorCode == BMK_SEARCH_NO_ERROR {
//                //处理正常结果
//                print("获取到数据")
//                //            let poiInfos = poiResult.poiInfoList as! [BMKPoiInfo]
//                let poiInfos = poiResult.poiInfoList!
//                //遍历
//                for poiInfo in poiInfos {
//                    //添加一个PointAnnotation
//                    let annotation = BMKPointAnnotation()
//                    annotation.coordinate = poiInfo.pt
//                    annotation.title = poiInfo.name
//                    annotation.subtitle = poiInfo.address
//                    //添加大头针
//                    mapview.addAnnotation(annotation)
//                }
//            }else if errorCode == BMK_SEARCH_AMBIGUOUS_KEYWORD {
//                print("起始点有歧义")
//            }else {
//                print("抱歉,未找到结果")
//            }
//        }
}
