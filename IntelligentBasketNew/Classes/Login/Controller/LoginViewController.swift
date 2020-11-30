//
//  LoginViewController.swift
//  IntelligentBasket
//
//  Created by 卢卓桓 on 2019/8/16.
//  Copyright © 2019 zhineng. All rights reserved.
//

import UIKit
import BEMCheckBox
import SnapKit

private let kIconWH: CGFloat = 35
private let kUsernameKey = "kUsernameKey"
private let kPasswordKey = "kPasswordKey"

class LoginViewController: BaseViewController {
    
    // MARK: - 懒加载属性
    private lazy var textFieldBgView: UIView = {
        let textFieldBgView = UIView()
        textFieldBgView.backgroundColor = UIColor.white
        return textFieldBgView
    }()
    
    private lazy var phoneField: TextFieldWithIcon = {
        return CommonViewFactory.createTextFieldWithIcon(textFieldType: .PhoneField, placeholder: "手机号", sender: self, image: "icon_user_info")
    }()
    
    private lazy var passwdFeild: TextFieldWithIcon = {
        let passwdField = CommonViewFactory.createTextFieldWithIcon(textFieldType: .PasswordField, placeholder: "密码", sender: self, image: "icon_password")
        passwdField.setReturnKeyType(returnKeyType: .done)
        return passwdField
    }()
    
    private lazy var rememberPasswdCheckBox: CheckBox = {
        let checkBox = CheckBox(frame: .zero, checkBoxTitle: "记住密码")
        checkBox.delegate = self
        return checkBox
    }()
    
    private lazy var loginBtn: UIButton = { [weak self] in
        let btn = CommonViewFactory.createCustomButton(title: "登录", font: UIFont.systemFont(ofSize: 18), textColor: UIColor.white, backColor: primaryColor, action: #selector(loginBtnClick), sender: self)
        btn.layer.cornerRadius = kButtonCornerRadius
        btn.addTarget(self, action: #selector(btnChangeColor(btn:)), for: .touchDown)
        return btn
    }()
    
    private lazy var registerBtn: UIButton = { [weak self] in
        let btn = CommonViewFactory.createCustomButton(title: "注册", font: UIFont.systemFont(ofSize: 18), textColor: UIColor.white, backColor: primaryColor, action: #selector(registerBtnClick), sender: self)
        btn.layer.cornerRadius = kButtonCornerRadius
        btn.addTarget(self, action: #selector(btnChangeColor(btn:)), for: .touchDown)
        return btn
    }()
    
    private lazy var singleTapGes: UITapGestureRecognizer = { [weak self] in
        return UITapGestureRecognizer(target: self, action: #selector(singleTapAction))
    }()
    
    
    // MARK: - 系统回调函数
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        makeConstraints()
        getUserInfo()         // 加载用户信息
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    // MARK: - 父类方法重新写
    override func setUI() {
        super.setNavigationBar(title: "登 录")
        view.backgroundColor = lightGray
        view.addSubview(textFieldBgView)
        textFieldBgView.addSubview(phoneField)
        textFieldBgView.addSubview(passwdFeild)
        textFieldBgView.addSubview(rememberPasswdCheckBox)

        view.addSubview(loginBtn)
        
        view.addSubview(registerBtn)
        //registerBtn.isHidden = true
        
        view.addGestureRecognizer(singleTapGes)
    }
    
    override func makeConstraints() {
        textFieldBgView.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.bottom.equalTo(rememberPasswdCheckBox.snp.bottom).offset(15)
        }
        
        phoneField.snp.makeConstraints { (make) in
            make.top.left.equalToSuperview().offset(10)
            make.right.equalToSuperview().offset(-5)
            make.height.equalTo(kTextFieldWithIcon_IconWH)
        }
        
        passwdFeild.snp.makeConstraints { (make) in
            make.top.equalTo(phoneField.snp.bottom).offset(15)
            make.left.width.height.equalTo(phoneField)
        }
        rememberPasswdCheckBox.snp.makeConstraints { (make) in
            make.height.equalTo(kCheckBoxWH)
            make.width.equalTo(passwdFeild)
            make.left.equalToSuperview().offset(20)
            make.top.equalTo(passwdFeild.snp.bottom).offset(25)
        }
        loginBtn.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(40)
            make.right.equalToSuperview().offset(-40)
            //make.height.equalTo(passwdFeild)
            make.top.equalTo(textFieldBgView.snp.bottom).offset(25)
        }
        registerBtn.snp.makeConstraints { (make) in
            make.left.right.height.equalTo(loginBtn)
            make.top.equalTo(loginBtn.snp.bottom).offset(20)
        }
    }

}


// MARK: - 事件监听函数
extension LoginViewController {
    
    @objc private func loginBtnClick(){
        normalViewColor(view: loginBtn)
        if checkLoginValid() {
            /// 记住密码
            if rememberPasswdCheckBox.isOn() {
                rememberUserInfo(username: phoneField.getTextField().text, passwd: passwdFeild.getTextField().text)
            } else {
                removeUserInfo()
            }
            /// 登录
            requestLogin()
        }
    }
    
    @objc private func registerBtnClick(){
        normalViewColor(view: registerBtn)
        //pushViewController(viewController: RegisterViewController(), animated: true)
        
        pushViewController(viewController: SimpleRegisterController(role: UserRole.Manager.rawValue, navTitle: "注册" ), animated: true)
    }
    
    /// 按下按钮时改变按钮背景颜色
    @objc private func btnChangeColor(btn: UIButton){
        clickViewColor(view: btn)
    }
    
    /// 单击屏幕可隐藏键盘
    @objc private func singleTapAction(){
        phoneField.getTextField().resignFirstResponder()
        passwdFeild.getTextField().resignFirstResponder()
    }
}


// MARK: - 实现 UITextFieldDelegate, CheckBoxDelegate 代理方法
extension LoginViewController: UITextFieldDelegate, CheckBoxDelegate{
    /// 点击 checkBox
    func tapCheckBox(checkBox: CheckBox) {}
    
    /// 点击 checkBoxLabel
    func tapCheckBoxLabel(checkBox: CheckBox) {}
    
    /// 点击键盘的 return 时，隐藏键盘
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}

// MARK: - 登录前的数据检查
extension LoginViewController {
    
    /// 匹配手机的正则表达式
    private func isPhoneFormatValid() -> Bool {
        let matcher = RegularMatchingTool(patten: mobilePattenStrict)
        return matcher.match(input: phoneField.getTextField().text ?? "")
    }
    
    /// 手机号码是否为空
    private func isPhoneNotEmpty() -> Bool {
        return (phoneField.getTextField().text?.count ?? 0) > 0
    }
    
    /// 密码不为空 （需要设置最少密码位数吗）
    private func isPasswdFormatValid() -> Bool {
        return (passwdFeild.getTextField().text?.count ?? 0) > 0
    }
    
    
    private func checkLoginValid() -> Bool {
        if !(isPasswdFormatValid() && isPhoneNotEmpty()) {
            view.showTip(tip: "百胜吊篮：账户或密码不能为空！", position: .bottomCenter)
            return false
        }
        if !isPhoneFormatValid() {
            view.showTip(tip: "百胜吊篮：手机号码格式不正确！", position: .bottomCenter)
            return false
        }
        return true
    }
}

// MARK: - 记住密码(使用 UserDefaults)
extension LoginViewController {
    
    /// 这里的userName是指登录时的用户名；UserDefaultsStorage 中的用户名是指用户的名字
    func storeUsername(username: String?) {
        guard let username = username else { return }
        UserDefaults.standard.set(username, forKey: kUsernameKey)
    }
    
    func getUsername() -> String? {
        return UserDefaults.standard.object(forKey: kUsernameKey) as? String
    }
    
    func storePassword(passwd: String?) {
        guard let passwd = passwd else { return }
        UserDefaults.standard.set(passwd, forKey: kPasswordKey)
    }
    
    func getPassword() -> String? {
        return UserDefaults.standard.object(forKey: kPasswordKey) as? String
    }
    
    func rememberUserInfo(username: String?, passwd: String?) {
        storeUsername(username: username)
        storePassword(passwd: passwd)
    }
    
    func removeUserInfo() {
        UserDefaults.standard.removeObject(forKey: kUsernameKey)
        UserDefaults.standard.removeObject(forKey: kPasswordKey)
    }
    
    func getUserInfo() {
        phoneField.getTextField().text = getUsername()
        passwdFeild.getTextField().text = getPassword()
    }
}

// MARK: - 网络请求
extension LoginViewController {
    
    private func requestLogin() {
        
        let parameters = ["userPassword": passwdFeild.getTextField().text!, "userPhone": phoneField.getTextField().text!]
        
        HttpTools.requestDataJsonEncoding(URLString: loginURL, method: .POST, parameters: parameters, finishedCallBack: { (result) in
            //print(result)
            guard let resDict = result as? [String: Any] else { return }
            
            let registerState = resDict["registerState"] as! String
            if registerState != "0" {
                AlertBox.create(title: "提示", message: "账号或密码错误，请检查后登录！", viewController: self)
            } else {
                
                /// 解析 userInfo 数据(json -> model)
                let userInfo = resDict["userInfo"] as! [String: Any]
               
                guard let userInfoModel = try? DictConvertToModel.JSONModel(UserInfoModel.self, withKeyValues: userInfo) else {
                    print("Login: Json to Model Failed")
                    return
                }
                
                /// 判断当前账户的角色是不是监管人员
                guard let userRole = userInfoModel.userRole else {
                    self.view.showTip(tip: "百胜吊篮：账号错误!", position: .bottomCenter)
                    return
                }
                
                if userRole != UserRole.Manager.rawValue
                    && userRole != UserRole.GovAdmin.rawValue {
                    self.view.showTip(tip: "百胜吊篮：账号错误!", position: .bottomCenter)
                    return
                }
                
                /// 存储Token
                let token = resDict["token"] as! String
                UserDefaultStorage.storeToken(token: token)
                
                /// 存储userId userName
                let userId = userInfoModel.userId
                UserDefaultStorage.storeUserId(userId: userId ?? "")
                let userName = userInfoModel.userName
                UserDefaultStorage.storeUserName(userName: userName ?? "")
                let userPerm = userInfoModel.userPerm
                UserDefaultStorage.storeUserPerm(userName: userPerm ?? "")
                
                // TODO:
                // 暂时任务IOS端的角色权限是一样的
                let projectListViewController = UIStoryboard(name: "ProjectList", bundle: nil)
                    .instantiateInitialViewController()!
                
                // 加上这一句才能全屏显示
                projectListViewController.modalPresentationStyle = .fullScreen
                self.present(projectListViewController, animated: false,  completion: nil)
                
                // TODO: 根据Role进入不同页面
                /*
                switch userInfoModel.userRole {
                case UserRole.AreaAdmin.rawValue:
                    //self.present(AreaAdminTabBarController(), animated: false, completion: nil)
                    let projectListViewController = UIStoryboard(name: "ProjectList", bundle: nil)
                        .instantiateInitialViewController()!
                    //projectListViewController.modalPresentationStyle = .fullScreen
                    self.present(projectListViewController, animated: false,  completion: nil)
                case UserRole.RentAdmin.rawValue:
                    break
                case UserRole.Inspector.rawValue:
                    break
                case UserRole.Worker.rawValue:
                    break
                default:
                    break
                }
                */
            }
            
        }) { (error) in
            self.view.showTip(tip: "网络请求错误！", position: .bottomCenter)
            print(error)
            // TODO: 错误处理  比如在有限次数内尝试重新连接
        }
        
    }
}
