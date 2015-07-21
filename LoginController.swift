//
//  LoginController.swift
//  RUC_Assist
//  登录界面
//  作者: DaoD 时间: 5/11/15.
//  版权所有: 2015 DaoD.
//

import UIKit

class LoginController: UIViewController, UITextFieldDelegate, HttpProtocol {
    
    //输入框绑定
    @IBOutlet weak var userfield: UITextField!
    @IBOutlet weak var passfield: UITextField!
    //登录按钮绑定
    @IBOutlet weak var loginbtn: UIButton!
    
    var eHttp:HttpController = HttpController()
    var token:String = ""
    var alert:UIAlertView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.userfield.delegate = self
        self.passfield.delegate = self
        eHttp.delegate = self
        loginbtn.layer.cornerRadius = 5
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //登录按钮点击事件
    @IBAction func onLogin(sender: AnyObject) {
        var username = userfield.text as NSString
        var password = passfield.text as NSString
        //初始化cookie
        let receiveCookie = NSHTTPCookieStorage.sharedHTTPCookieStorage() as NSHTTPCookieStorage
        for cookie in receiveCookie.cookies! {
            receiveCookie.deleteCookie(cookie as! NSHTTPCookie)
        }
        //数字人大登录需要先获得页面token值
        self.token = eHttp.getToken("***")
        //利用获得的token进行登录
        eHttp.startLogin("***",token: self.token,username: username as String, password: password as String)
        //成功登录会获得两个cookie，利用此判断登录成功与否
        let receiveCookie2 = NSHTTPCookieStorage.sharedHTTPCookieStorage() as NSHTTPCookieStorage
        let cookiesArray:NSArray = NSArray(array: receiveCookie2.cookies!)
        //登录成功
        if cookiesArray.count != 2 {
            let user:logininfo = logininfo()
            user.username = username as String
            user.password = password as String
            user.token = self.token
            self.performSegueWithIdentifier("login", sender: user)
        }
        //登录失败
        else {
            alert = UIAlertView(title: "错误!", message: "请输入正确的数字人大账号与密码", delegate: self, cancelButtonTitle: "确定")
            alert!.alertViewStyle = UIAlertViewStyle.Default
            alert!.show()
        }
        
    }
    
    //准备登录信息，进行跳转
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "login" {
            let navigationController = segue.destinationViewController as! UINavigationController
            let controller = navigationController.topViewController as! ViewController
            controller.user = sender as? logininfo
        }
    }
    
    //数字人大账号信息输入完毕，return收回虚拟键盘，界面下移恢复
    @IBAction func onFinishEdit(sender: AnyObject) {
        UIView.animateWithDuration(0.22, animations: {
            self.view.frame.origin.y = 0
        })
        sender.resignFirstResponder()
    }
    
    //数字人大密码信息输入完毕，return收回虚拟键盘，界面下移恢复
    @IBAction func onFinishEdit2(sender: AnyObject) {
        UIView.animateWithDuration(0.22, animations: {
            self.view.frame.origin.y = 0
        })
        sender.resignFirstResponder()
    }
    
    //点击输入框以外部分，收回虚拟键盘，界面下移恢复
    @IBAction func onCloseKeyBoard(sender: AnyObject) {
        UIView.animateWithDuration(0.22, animations: {
            self.view.frame.origin.y = 0
        })
        self.userfield.resignFirstResponder()
        self.passfield.resignFirstResponder()
    }
    
    //点击输入框，出现虚拟键盘，界面上移使输入框不被遮挡
    func textFieldDidBeginEditing(textField: UITextField){
        UIView.animateWithDuration(0.4, animations: {
            self.view.frame.origin.y = -200
        })
    }
    
    //实现HttpProtocol协议的函数
    func didReceiveResults(results: NSData) {
    }
}
