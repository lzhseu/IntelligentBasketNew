//
//  EntranceViewController.swift
//  IntelligentBasket
//
//  Created by 卢卓桓 on 2019/11/15.
//  Copyright © 2019 zhineng. All rights reserved.
//

/*
 * 在原有的项目结构基础上再套一层入口
 */

import UIKit
import SnapKit

private let kEdgeLength: CGFloat = 20
private let kSpaceLength: CGFloat = 10
private let kImageViewWH: CGFloat = (kScreenW - 2 * kEdgeLength - 2 * kSpaceLength) / 3

class EntranceViewController: BaseViewController {
    
    // MARK: - 懒加载属性
    private lazy var usingImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "usingProject"))
        return imageView
    }()
    
    private lazy var installingImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "installingProject"))
        return imageView
    }()
    
    private lazy var completedImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "completedProject"))
        return imageView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        setUI()
        makeConstraints()
    }
    
    
    // MARK: - 重定义父类方法
    override func setUI() {
        setNavigationBar(title: "项目")
        view.addSubview(usingImageView)
        view.addSubview(installingImageView)
        view.addSubview(completedImageView)
        
        usingImageView.isUserInteractionEnabled = true
        usingImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(usingImageViewClicked)))
        
        installingImageView.isUserInteractionEnabled = true
        installingImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(installingImageViewClicked)))
        
        completedImageView.isUserInteractionEnabled = true
        completedImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(completedImageViewClicked)))
    }
    
    override func makeConstraints() {
        usingImageView.snp.makeConstraints { (make) in
            make.left.top.equalToSuperview().offset(kEdgeLength)
            make.height.width.equalTo(kImageViewWH)
        }
        
        installingImageView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(kEdgeLength)
            make.left.equalTo(usingImageView.snp.right).offset(kSpaceLength)
            make.height.width.equalTo(kImageViewWH)
        }
        
        completedImageView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(kEdgeLength)
            make.left.equalTo(installingImageView.snp.right).offset(kSpaceLength)
            make.height.width.equalTo(kImageViewWH)
        }
    }
    
    override func setNavigationBar(title: String?) {
        super.setNavigationBar(title: title)
    }
}

// MARK: - 事件监听函数
extension EntranceViewController {
    
    @objc private func usingImageViewClicked() {
        pushViewController(viewController: ProjectListViewController(type: kUsingProjectType, userPerm: UserDefaultStorage.getUserPerm() ?? ""), animated: true)
    }
    
    @objc private func installingImageViewClicked() {
        pushViewController(viewController: ProjectListViewController(type: kInstallingProjectType, userPerm: UserDefaultStorage.getUserPerm() ?? ""), animated: true)
    }
    
    @objc private func completedImageViewClicked() {
        pushViewController(viewController: ProjectListViewController(type: kCompletedProjectType, userPerm: UserDefaultStorage.getUserPerm() ?? ""), animated: true)
    }
}
