//
//  RegisterBaseViewController.swift
//  IntelligentBasket
//
//  Created by 卢卓桓 on 2019/8/18.
//  Copyright © 2019 zhineng. All rights reserved.
//

import UIKit
import SnapKit

private let kImageBgViewH = 0.22 * kScreenH
private let kImageViewH = kImageBgViewH * 2 / 3
private let kImageViewW = kImageViewH * 1.585      //模仿身份证宽高比
private let kShortButtonW = kScreenW / 2 - 30 * 2

class RegisterBaseViewController: BaseViewController {
    
    // MARK: - 自定义属性
    var role = ""         //角色
    var navTitle = ""     //导航栏显示的内容
    var image = "idcard"
    var isIdCardUpload = false

    // MARK: - 懒加载属性
    private lazy var titleLabel: UILabel = {
        return CommonViewFactory.createLabel(title: "基本信息", font: UIFont.systemFont(ofSize: 18), textColor: UIColor.gray)
    }()
    
    private lazy var textFieldBgView: UIView = {
        let textFieldBgView = UIView()
        textFieldBgView.backgroundColor = UIColor.white
        return textFieldBgView
    }()
    
    private lazy var phoneField: TextFieldWithIcon = {
        return CommonViewFactory.createTextFieldWithIcon(textFieldType: .PhoneField, placeholder: "手机号", sender: self, image: "icon_phone")
    }()
    
    private lazy var usernameFeild: TextFieldWithIcon = {
        let usernameFeild = CommonViewFactory.createTextFieldWithIcon(textFieldType: .NormalTextField, placeholder: "用户名", sender: self, image: "icon_user_info")
        usernameFeild.setReturnKeyType(returnKeyType: .done)
        return usernameFeild
    }()
    
    private lazy var passwdFeild: TextFieldWithIcon = {
        let passwdField = CommonViewFactory.createTextFieldWithIcon(textFieldType: .PasswordField, placeholder: "输入密码", sender: self, image: "icon_password")
        passwdField.setReturnKeyType(returnKeyType: .done)
        return passwdField
    }()
    
    private lazy var passwdAgainFeild: TextFieldWithIcon = {
        let passwdField = CommonViewFactory.createTextFieldWithIcon(textFieldType: .PasswordField, placeholder: "再次输入密码", sender: self, image: "icon_password")
        passwdField.setReturnKeyType(returnKeyType: .done)
        return passwdField
    }()
    
    private lazy var imageBgView: UIView = {
        let imageBgView = UIView()
        imageBgView.backgroundColor = UIColor.white
        return imageBgView
    }()
    
    private lazy var imageView: UIImageView = {
        return CommonViewFactory.createImageView(image: image)
    }()
    
    private lazy var takePhotoBtn: UIButton = {
        let btn = CommonViewFactory.createCustomButton(title: "拍摄照片", font: UIFont.systemFont(ofSize: 18), textColor: UIColor.white, backColor: primaryColor, action: #selector(takePhotoBtnClick), sender: self)
        btn.layer.cornerRadius = kButtonCornerRadius
        btn.addTarget(self, action: #selector(btnChangeColor(btn:)), for: .touchDown)
        return btn
    }()
    
    private lazy var pickPhotoBtn: UIButton = {
        let btn = CommonViewFactory.createCustomButton(title: "从相册中选择", font: UIFont.systemFont(ofSize: 18), textColor: UIColor.white, backColor: primaryColor, action: #selector(pickPhotoBtnClick), sender: self)
        btn.layer.cornerRadius = kButtonCornerRadius
        btn.addTarget(self, action: #selector(btnChangeColor(btn:)), for: .touchDown)
        return btn
    }()
    
    private lazy var confirmBtn: UIButton = {
        let btn = CommonViewFactory.createCustomButton(title: "确认注册", font: UIFont.systemFont(ofSize: 18), textColor: UIColor.white, backColor: primaryColor, action: #selector(confirmBtnClick), sender: self)
        btn.layer.cornerRadius = kButtonCornerRadius
        btn.addTarget(self, action: #selector(btnChangeColor(btn:)), for: .touchDown)
        return btn
    }()
    
    private lazy var photoPicker: UIImagePickerController = {
        return UIImagePickerController()
    }()
    
    // MARK: - 系统回调函数
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        makeConstraints()
    }
    
    // MARK: - 构造函数
    init(role: String, navTitle: String){
        super.init(nibName: nil, bundle: nil)
        self.role = role
        self.navTitle = navTitle
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - 重写父类函数
    override func setUI() {
        view.backgroundColor = lightGray
        setNavigationBarTitle(title: navTitle)
        /*//导航栏按钮直接返回登录页
        let backBtn = UIButton()
        backBtn.setImage(UIImage(named: "arrow-left-white"), for: .normal)
        backBtn.addTarget(self, action: #selector(backToLogin), for: .touchUpInside)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backBtn)
        */
        
        view.addSubview(titleLabel)
        view.addSubview(textFieldBgView)
        textFieldBgView.addSubview(phoneField)
        textFieldBgView.addSubview(usernameFeild)
        textFieldBgView.addSubview(passwdFeild)
        textFieldBgView.addSubview(passwdAgainFeild)
        
        view.addSubview(imageBgView)
        imageBgView.addSubview(imageView)
        
        view.addSubview(takePhotoBtn)
        view.addSubview(pickPhotoBtn)
        view.addSubview(confirmBtn)
    }
    
    override func makeConstraints() {
        makeConstraintsForTextField(superView: view)
        makeConstraintsForImageView(superView: view, referenceView: textFieldBgView)
        makeConstraintsForButton(superView: view, referenceView: imageBgView)
    }
    
    // MARK: - UI封装，方便子类使用
    func makeConstraintsForTextField(superView: UIView) {
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(superView).offset(5)
            make.top.equalTo(superView).offset(20)
        }
        textFieldBgView.snp.makeConstraints { (make) in
            make.left.right.equalTo(superView)
            make.top.equalTo(titleLabel.snp.bottom).offset(3)
            make.bottom.equalTo(passwdAgainFeild.snp.bottom).offset(10)
        }
        phoneField.snp.makeConstraints { (make) in
            make.top.left.equalTo(textFieldBgView).offset(10)
            make.right.equalTo(textFieldBgView).offset(-5)
            make.height.equalTo(kTextFieldWithIcon_IconWH)
        }
        usernameFeild.snp.makeConstraints { (make) in
            make.top.equalTo(phoneField.snp.bottom).offset(10)
            make.left.width.height.equalTo(phoneField)
        }
        passwdFeild.snp.makeConstraints { (make) in
            make.top.equalTo(usernameFeild.snp.bottom).offset(10)
            make.left.width.height.equalTo(phoneField)
        }
        passwdAgainFeild.snp.makeConstraints { (make) in
            make.top.equalTo(passwdFeild.snp.bottom).offset(10)
            make.left.width.height.equalTo(phoneField)
        }
    }
    
    func makeConstraintsForImageView(superView: UIView, referenceView: UIView) {
        imageBgView.snp.makeConstraints { (make) in
            make.left.right.equalTo(superView)
            make.top.equalTo(referenceView.snp.bottom).offset(kSpaceBetweenModule)
            make.height.equalTo(kImageBgViewH)
        }
        imageView.snp.makeConstraints { (make) in
            make.center.equalTo(imageBgView)
            make.height.equalTo(kImageViewH)
            make.width.equalTo(kImageViewW)
        }
    }
    
    func makeConstraintsForButton(superView: UIView, referenceView: UIView) {
        takePhotoBtn.snp.makeConstraints { (make) in
            make.left.equalTo(superView).offset(30)
            make.top.equalTo(referenceView.snp.bottom).offset(kSpaceBetweenModule)
            //make.height.equalTo(phoneField)
            make.width.equalTo(kShortButtonW)
        }
        pickPhotoBtn.snp.makeConstraints { (make) in
            make.right.equalTo(superView).offset(-30)
            make.centerY.equalTo(takePhotoBtn)
            make.width.height.equalTo(takePhotoBtn)
        }
        confirmBtn.snp.makeConstraints { (make) in
            make.right.equalTo(pickPhotoBtn)
            make.left.equalTo(takePhotoBtn)
            make.top.equalTo(takePhotoBtn.snp.bottom).offset(25)
            make.height.equalTo(takePhotoBtn)
        }
    }
    
    
    func checkRegisterValid() -> Bool {
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
        if !isImageViewValid() {
            view.showTip(tip: "百胜吊篮：请上传身份证照片！", position: .bottomCenter)
            return false
        }
        return true
    }

}


// MARK: - Getter
extension RegisterBaseViewController {
    
    func getTextFieldBgView() -> UIView {
        return textFieldBgView
    }
    
    
    func getImageBgView() -> UIView {
        return imageBgView
    }
    
    func getImageView() -> UIImageView {
        return imageView
    }
    
    func getTakePhotoBtn() -> UIButton {
        return takePhotoBtn
    }
    
    func getPickPhotoBtn() -> UIButton {
        return pickPhotoBtn
    }
    
    func getConfirmBtn() -> UIButton {
        return confirmBtn
    }
    
    
}

// MARK: - 事件监听函数
extension RegisterBaseViewController {
    
    @objc private func takePhotoBtnClick() {
        normalViewColor(view: takePhotoBtn)
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            // TODO: 拍摄照片  虚拟器中好像不能拍
            photoPicker.sourceType = .camera
            photoPicker.allowsEditing = false
            
        } else {
            view.showTip(tip: "百胜吊篮：无法访问相机", position: .bottomCenter)
        }
    }
    
    @objc private func pickPhotoBtnClick() {
        /*
        normalViewColor(view: pickPhotoBtn)
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            photoPicker.sourceType = .photoLibrary
            photoPicker.allowsEditing = false
            promise(photoPicker).done { (info) in
                let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
                self.imageView.image = image
                self.isIdCardUpload = true
            }.catch { (error) in
                self.view.showTip(tip: "读取相册出错", position: .bottomCenter)
            }
        } else {
            view.showTip(tip: "百胜吊篮：无法访问相册", position: .bottomCenter)
        }
        */
    }
    
    @objc func confirmBtnClick() {
        normalViewColor(view: confirmBtn)
        if checkRegisterValid() {
            // TODO: 注册
            requstRegister()
        }
    }
    
    /// 按下按钮时改变按钮背景颜色
    @objc private func btnChangeColor(btn: UIButton) {
        clickViewColor(view: btn)
    }
    
    @objc private func backToLogin() {
        popToRootViewController(animated: true)
    }
}


// MARK: - 实现代理方法 UITextFieldDelegate
extension RegisterBaseViewController: UITextFieldDelegate {
    /// 点击键盘的 return 时，隐藏键盘
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}



// MARK: - 注册前的数据检查
extension RegisterBaseViewController {
    
    /// 匹配手机的正则表达式
    func isPhoneFormatValid() -> Bool {
        let matcher = RegularMatchingTool(patten: mobilePattenStrict)
        return matcher.match(input: phoneField.getTextField().text ?? "")
    }
    
    /// 用户名不为空
    func isUsernameFormatValid() -> Bool {
        guard let text = usernameFeild.getTextField().text else { return false }
        return text.count > 0
    }
    
    /// 密码是否为空
    func isPasswdNotEmpty() -> Bool {
        guard let text = passwdFeild.getTextField().text else { return false }
        return text.count > 0
    }
    
    /// 密码不为空，且两次输入密码应该一致 （需要设置最少密码位数吗）
    func isPasswdFormatValid() -> Bool {
        guard let passwd = passwdFeild.getTextField().text else { return false }
        guard let passwdAgain = passwdAgainFeild.getTextField().text else { return false }
        if passwd == passwdAgain {
            return true
        }
        return false
    }
    
    /// 身份证照片不为空
    func isImageViewValid() -> Bool {
        return isIdCardUpload
    }
    

}


// MARK: - 网络请求
extension RegisterBaseViewController {
    
    func requstRegister() {
        
        let parameters = ["userName": usernameFeild.getTextField().text!, "userPassword": passwdFeild.getTextField().text!, "userPhone": phoneField.getTextField().text!, "userRole": role]
        
        HttpTools.requestDataJsonEncoding(URLString: registerURL, method: .POST, parameters: parameters, finishedCallBack: { (result) in
            
            guard let resDict = result as? [String: Any] else { return }
            let message = resDict["message"] as! String
            if message == "exist" {
                AlertBox.create(title: "提示", message: "注册失败，手机号已注册！", viewController: self)
            } else if message == "success" {
                AlertBox.create(title: "提示", message: "注册成功，请等待审核！", viewController: self)
            }
            
        }) { (error) in
            self.view.showTip(tip: "网络请求错误！", position: .bottomCenter)
            // TODO: 错误处理  比如在有限次数内尝试重新连接
        }
    }
}
