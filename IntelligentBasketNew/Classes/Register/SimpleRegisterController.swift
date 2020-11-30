//
//  SimpleRegisterController.swift
//  IntelligentBasket
//
//  Created by 卢卓桓 on 2020/4/18.
//  Copyright © 2020 zhineng. All rights reserved.
//

import UIKit

private let kShortButtonW = kScreenW / 2 - 30 * 2


class SimpleRegisterController: RegisterBaseViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI();
        makeConstraints()
    }
    
    override func setUI() {
        super.setUI()
        getImageBgView().isHidden = true
        getImageView().isHidden = true
        getPickPhotoBtn().isHidden = true
        getTakePhotoBtn().isHidden = true
    }
    
    override func makeConstraints() {
        makeConstraintsForTextField(superView: view)
        makeConstraintsForButton(superView: view, referenceView: getTextFieldBgView())
    }
    
    override func makeConstraintsForButton(superView: UIView, referenceView: UIView) {
        let confirmBtn = getConfirmBtn()
        confirmBtn.snp.makeConstraints { (make) in
            make.right.equalTo(superView).offset(-30)
            make.left.equalTo(superView).offset(30)
            make.top.equalTo(referenceView.snp.bottom).offset(kSpaceBetweenModule)
            make.width.equalTo(kShortButtonW)
        }
    }
    
    override func confirmBtnClick() {
        normalViewColor(view: getConfirmBtn())
        if checkRegisterValid() {
            //getConfirmBtn().isEnabled = false
            requstRegister()
        }
    }
    
    override func checkRegisterValid() -> Bool {
        if !isPhoneFormatValid() {
            view.showTip(tip: "百胜吊篮：手机号码格式不正确！", position: .bottomCenter)
            return false
        }
        if !isUsernameFormatValid() {
            view.showTip(tip: "百胜吊篮：用户名不能为空！", position: .bottomCenter)
            return false
        }
        if !isPasswdNotEmpty() {
            view.showTip(tip: "百胜吊篮：密码不能为空！", position: .bottomCenter)
            return false
        }
        if !isPasswdFormatValid() {
            view.showTip(tip: "百胜吊篮：两次输入密码不一致！", position: .bottomCenter)
            return false
        }
        
        return true
    }
}
