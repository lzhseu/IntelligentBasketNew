//
//  CheckBox.swift
//  IntelligentBasket
//
//  Created by 卢卓桓 on 2019/8/17.
//  Copyright © 2019 zhineng. All rights reserved.
//

import UIKit
import SnapKit
import BEMCheckBox

private let kSpaceBetweenBoxAndLabel = 15

protocol CheckBoxDelegate: class {
    func tapCheckBox(checkBox: CheckBox)
    func tapCheckBoxLabel(checkBox: CheckBox)
}

class CheckBox: UIView {
    
    var title = ""
    weak var delegate: CheckBoxDelegate?

    private lazy var checkBox: BEMCheckBox = { [weak self] in
        let checkBox = BEMCheckBox()
        checkBox.on = true
        checkBox.boxType = BEMBoxType.square
        checkBox.onTintColor = primaryColor
        //checkBox.tintColor = primaryColor
        checkBox.onCheckColor = UIColor.white
        checkBox.onFillColor = primaryColor
        checkBox.onAnimationType = BEMAnimationType.bounce
        checkBox.offAnimationType = BEMAnimationType.bounce
        checkBox.delegate = self
        return checkBox
    }()
    
    private lazy var titleLabel: UILabel = { [weak self] in
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.textColor = UIColor.darkGray
        titleLabel.font = UIFont.systemFont(ofSize: 14)
        titleLabel.sizeToFit()
        /// 单击label也能勾选CheckBox
        titleLabel.isUserInteractionEnabled = true
        let tapsGes = UITapGestureRecognizer(target: self, action: #selector(titleLabelClick))
        titleLabel.addGestureRecognizer(tapsGes)
        return titleLabel
    }()
    
    
    init(frame: CGRect, checkBoxTitle: String){
        super.init(frame: frame)
        title = checkBoxTitle
        setUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: - UI
extension CheckBox {
    private func setUI() {
        addSubview(checkBox)
        addSubview(titleLabel)
        checkBox.snp.makeConstraints { (make) in
            make.left.top.bottom.equalToSuperview()
            make.width.height.equalTo(kCheckBoxWH)
        }
        titleLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(checkBox)
            make.left.equalTo(checkBox.snp.right).offset(kSpaceBetweenBoxAndLabel)
        }
    }
}

// MARK: - 事件监听函数
extension CheckBox: BEMCheckBoxDelegate {
    
    /// 监听点击 label
    @objc private func titleLabelClick(){
        checkBox.setOn(!isOn(), animated: true)
        delegate?.tapCheckBoxLabel(checkBox: self)
    }
    
    /// 点击 checkBox
    func didTap(_ checkBox: BEMCheckBox) {
        delegate?.tapCheckBox(checkBox: self)
    }
    
}


// MARK: - 对外暴露的方法
extension CheckBox {
    // 需要再写
    func isOn() -> Bool {
        return checkBox.on
    }
    
    func getCheckBox() -> BEMCheckBox {
        return checkBox
    }
    
    func getCheckBoxLabel() -> UILabel {
        return titleLabel
    }
}
