//
//  NoteController.swift
//  RUC_Assist
//  借阅信息查询登录界面
//  作者: DaoD 时间: 5/14/15.
//  版权所有: 2015 DaoD.
//

import UIKit

class NoteController: UIViewController, UITextFieldDelegate, HttpProtocol {
    
    @IBOutlet weak var userfield: UITextField!
    @IBOutlet weak var passfield: UITextField!
    @IBOutlet weak var loginbtn: UIButton!
    var alert:UIAlertView?
    var eHttp:HttpController = HttpController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.userfield.delegate = self
        self.passfield.delegate = self
        self.title = "借阅记录查询"
        eHttp.delegate = self
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        loginbtn.layer.cornerRadius = 5
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillDisappear(animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    //借阅证账号信息输入完毕，return收回虚拟键盘，界面下移恢复
    @IBAction func onFinishEdit(sender: AnyObject) {
        UIView.animateWithDuration(0.22, animations: {
            self.view.frame.origin.y = 0
        })
        sender.resignFirstResponder()
    }
    
    //借阅证密码信息输入完毕，return收回虚拟键盘，界面下移恢复
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
            self.view.frame.origin.y = -190
        })
    }
    
    //登录按钮点击事件
    @IBAction func onLogin(sender: AnyObject) {
        var username = userfield.text as NSString
        var password = passfield.text as NSString
        //获取动态action
        var action = eHttp.getAction("***")
        //未输入账号密码信息，提示错误
        if username.length == 0 || password.length == 0 {
            alert = UIAlertView(title: "错误!", message: "请输入正确的借阅证账号与密码", delegate: self, cancelButtonTitle: "确定")
            alert!.alertViewStyle = UIAlertViewStyle.Default
            alert!.show()
        }
        //账号密码信息正确，进行查询
        else {
            var notes = eHttp.loginLib(action, username: username as String, password: password as String)
            self.performSegueWithIdentifier("shownotedetail", sender: notes)
        }
    }
    
    //准备借阅信息，进行跳转
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "shownotedetail" {
            let navigationController = segue.destinationViewController as! UINavigationController
            let controller = navigationController.topViewController as! noteDetailController
            controller.noteList = sender as! Array<noteinfo>
        }
    }
    
    //实现HttpProtocol协议的函数
    func didReceiveResults(results: NSData) {
    }

}
