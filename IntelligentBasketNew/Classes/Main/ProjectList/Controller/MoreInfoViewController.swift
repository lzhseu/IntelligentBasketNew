//
//  SideMenuViewController.swift
//  IntelligentBasket
//
//  Created by 卢卓桓 on 2019/10/18.
//  Copyright © 2019 zhineng. All rights reserved.
//

import UIKit

protocol MoreInfoViewControllerDelegate: class {
    func moreInfoViewController(selected projectId: String)
    func moreInfoViewControllerWillDisappear()
    func moreInfoViewControllerWillAppear()
    func moreInfoViewControllerLogout()
}


class MoreInfoViewController: UIViewController {
    
    // MARK: - 模型属性
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var logoutBtn: UIImageView!
    
    // MARK: - 自定义属性
    weak var delegate: MoreInfoViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = primaryColor
        userNameLabel.text = UserDefaultStorage.getUserName()
        logoutBtn.isUserInteractionEnabled = true
        logoutBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(logoutImageViewClicked)))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        delegate?.moreInfoViewControllerWillAppear()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        delegate?.moreInfoViewControllerWillDisappear()
        super.viewWillDisappear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}


extension MoreInfoViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "menuViewCell", for: indexPath)
        cell.backgroundColor = UIColor.clear
        return cell
    }
    
    // 处理点击事件:切换项目
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    
}

// MARK: - 事件监听函数
extension MoreInfoViewController {
    
    // 退出登录
    @objc private func logoutImageViewClicked() {
        dismiss(animated: true) {
            self.delegate?.moreInfoViewControllerLogout()
        }
    }
}

