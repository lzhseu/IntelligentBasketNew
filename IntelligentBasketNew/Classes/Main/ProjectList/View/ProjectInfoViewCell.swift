//
//  ProjectInfoViewCell.swift
//  IntelligentBasket
//
//  Created by 卢卓桓 on 2019/11/2.
//  Copyright © 2019 zhineng. All rights reserved.
//

import UIKit

class ProjectInfoViewCell: UITableViewCell {

    // MARK: - 模型属性
    @IBOutlet weak var projectNameLabel: UILabel!
    @IBOutlet weak var regionLabel: UILabel!
    @IBOutlet weak var companyNameLabel: UILabel!
    @IBOutlet weak var projectStartLabel: UILabel!
    @IBOutlet weak var projectStateLabel: UILabel!
    @IBOutlet weak var deviceNumLabel: UILabel!
    @IBOutlet weak var bookImageView: UIImageView!
    @IBOutlet weak var projectDetailBtn: UIButton!
    
    // MARK: - 自定义属性
    var projectInfoModel: ProjectInfoModel? {
        didSet {
            projectNameLabel.text = projectInfoModel?.projectName
            regionLabel.text = projectInfoModel?.region ?? "暂无区域信息"
            companyNameLabel.text = projectInfoModel?.companyName ?? "暂无企业信息"
            projectStartLabel.text = projectInfoModel?.projectStart
            deviceNumLabel.text = String(projectInfoModel?.deviceNum ?? 0)
            switch projectInfoModel!.projectState {
            case "0":
                projectStateLabel.text = "草稿"
            case "1":
                projectStateLabel.text = "待成立项目部"
            case "11":
                projectStateLabel.text = "清单待配置"
            case "12":
                projectStateLabel.text = "清单待审核"
            case "2":
                projectStateLabel.text = "吊篮安装验收"
            case "21":
                projectStateLabel.text = "安监证书验收"
            case "3":
                projectStateLabel.text = "进行中"
            case "4":
                projectStateLabel.text = "已结束"
            default:
                projectStateLabel.text = "未知"
            }
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        projectDetailBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(projectDetailBtnClicked)))
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}

// MARK: - 事件监听函数
extension ProjectInfoViewCell {
    @objc private func projectDetailBtnClicked() {
        print("projectDetailBtnClicked....")
    }
}
