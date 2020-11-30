//
//  TextFieldWithIcon.swift
//  IntelligentBasket
//
//  Created by 卢卓桓 on 2019/8/18.
//  Copyright © 2019 zhineng. All rights reserved.
//

import UIKit
import SnapKit

private let kSpaceBetweenIconAndField = 15

enum TextFieldType: Int {
    case NormalTextField = 0,
    PhoneField,
    PasswordField
}

class TextFieldWithIcon: UIView {
    
    // MARK: - 自定义属性
    var textFieldType: TextFieldType = .NormalTextField
    var placeholder: String?
    var text: String?
    var sender: UITextFieldDelegate?
    var image: String?

    // MARK: - 懒加载属性
    private lazy var textField: UITextField = { [weak self] in
        var textField = UITextField()
        switch textFieldType {
            case .NormalTextField:
                textField = CommonViewFactory.createTextField(text: text, placeholder: placeholder, sender: sender)
            case .PhoneField:
                textField = CommonViewFactory.createPhoneField(text: text, sender: sender)
            case .PasswordField:
                textField = CommonViewFactory.createTextField(text: text, placeholder: placeholder, sender: sender)
                textField.isSecureTextEntry = true
        }
        return textField
    }()
    
    private lazy var textFieldIcon: UIImageView = { [weak self] in
        return CommonViewFactory.createImageView(image: image)
    }()
    
    // MARK: - 构造函数
    init(frame: CGRect, textFieldType: TextFieldType, placeholder: String?, text: String? = nil, sender: UITextFieldDelegate?, image: String?) {
        super.init(frame: frame)
        self.textFieldType = textFieldType
        self.placeholder = placeholder
        self.text = text
        self.sender = sender
        self.image = image
        setUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: - UI
extension TextFieldWithIcon {
    private func setUI() {
        addSubview(textField)
        addSubview(textFieldIcon)
        textFieldIcon.snp.makeConstraints { (make) in
            make.left.top.equalToSuperview()
            make.width.height.equalTo(kTextFieldWithIcon_IconWH)
        }
        textField.snp.makeConstraints { (make) in
            make.left.equalTo(textFieldIcon.snp.right).offset(kSpaceBetweenIconAndField)
            make.right.equalToSuperview()
            make.height.equalTo(textFieldIcon)
            make.centerY.equalTo(textFieldIcon)
        }
    }
}

// MARK: - 对外暴露的方法
extension TextFieldWithIcon {
    /// 设置键盘类型
    func setKeyboardType(keyboardType: UIKeyboardType) {
        textField.keyboardType = keyboardType
    }
    
    /// 设置键盘return键的类型
    func setReturnKeyType(returnKeyType: UIReturnKeyType) {
        textField.returnKeyType = returnKeyType
    }
    
    func getTextField() -> UITextField {
        return textField
    }
    
    func getTextFieldIcon() -> UIImageView {
        return textFieldIcon
    }
}
