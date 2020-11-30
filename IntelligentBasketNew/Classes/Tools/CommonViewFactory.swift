//
//  CommonViewFactory.swift
//  IntelligentBasket
//
//  Created by 卢卓桓 on 2019/8/16.
//  Copyright © 2019 zhineng. All rights reserved.
//

// @abstract: 常用控件的工厂类

import UIKit
import SnapKit
import BEMCheckBox

protocol CommonViewFactoryDelegate: class {
    func commonViewFactoryDelegate()
}

class CommonViewFactory {

    class func createLabel(title: String?, font: UIFont = UIFont.systemFont(ofSize: 14), textColor: UIColor = UIColor.black, backColor: UIColor? = nil) -> UILabel {
        let label = UILabel()
        label.text = title
        label.textColor = textColor
        label.backgroundColor = backColor
        label.font = font
        label.sizeToFit()
        return label
    }
    
    class func createCustomButton(title: String? = nil, font: UIFont = UIFont.systemFont(ofSize: 14), textColor: UIColor = UIColor.black, backColor: UIColor = UIColor.white, action: Selector? = nil, sender: UIViewController? = nil) -> UIButton {
        
        let btn = UIButton(type: .custom)
        btn.setTitle(title, for: .normal)
        btn.titleLabel?.textColor = textColor
        btn.titleLabel?.font = font
        btn.backgroundColor = backColor
        
        guard action != nil && sender != nil else {
            return btn
        }
        btn.addTarget(sender, action: action!, for: .touchUpInside)
        return btn
    }
    
    class func createTextField(text: String? = nil, placeholder: String? = nil, sender: UITextFieldDelegate? = nil) -> UITextField {
        let textField = UITextField()
        textField.tintColor = primaryColor
        textField.text = text
        textField.placeholder = placeholder
        textField.borderStyle = .none               //默认无边框
        textField.adjustsFontSizeToFitWidth = true  //当文字超出文本框宽度时，自动调整文字大小
        textField.minimumFontSize = 14              //最小可缩小的字号
        textField.clearButtonMode = .whileEditing   //编辑时出现清除按钮
        textField.delegate = sender                 //设置代理
        return textField
    }
    
    class func createPhoneField(text: String? = nil, sender: UITextFieldDelegate? = nil) -> PhoneField {
        let phoneField = PhoneField()
        phoneField.tintColor = primaryColor
        phoneField.text = text
        phoneField.placeholder = "手机号"
        phoneField.borderStyle = .none               //默认无边框
        phoneField.adjustsFontSizeToFitWidth = true  //当文字超出文本框宽度时，自动调整文字大小
        phoneField.minimumFontSize = 14              //最小可缩小的字号
        phoneField.clearButtonMode = .whileEditing   //编辑时出现清除按钮
        phoneField.delegate = sender                 //设置代理
        return phoneField
    }
    
    class func createImageView(image: String? = nil) -> UIImageView {
        let imageView = UIImageView()
        if let image = image {
            imageView.image = UIImage(named: image)
        } 
        return imageView
    }
    
    class func createCheckBox(title: String? = nil) -> UIView {
        return CheckBox(frame: CGRect.zero, checkBoxTitle: title ?? "")
    }
    
    class func createTextFieldWithIcon(textFieldType: TextFieldType, placeholder: String?, text: String? = nil, sender: UITextFieldDelegate?, image: String?) -> TextFieldWithIcon {
        
        return TextFieldWithIcon(frame: CGRect.zero, textFieldType: textFieldType, placeholder: placeholder, sender: sender, image: image)
    }
    
    class func createViewForClick(title: String, icon: String? = nil, backColor: UIColor = UIColor.white) -> UIView {
        let view = UIView()
        view.backgroundColor = backColor
        
        let titleLabel = createLabel(title: title, font: UIFont.systemFont(ofSize: 18), textColor: UIColor.black)
        
        let imageView = createImageView(image: icon)
        
        view.addSubview(titleLabel)
        view.addSubview(imageView)
        
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(20)
            make.centerY.equalToSuperview()
        }
        imageView.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-5)
            make.centerY.equalToSuperview()
            make.height.width.equalTo(15)
        }
        return view
    }
}
