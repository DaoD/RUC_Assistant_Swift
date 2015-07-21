//
//  BookController.swift
//  RUC_Assist
//  图书查询界面
//  作者: DaoD 时间: 5/15/15.
//  版权所有: 2015 DaoD.
//

import UIKit

class BookController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var namefield: UITextField!
    @IBOutlet weak var searchbtn: UIButton!
    var eHttp:HttpController = HttpController()
    var content:pagecontent = pagecontent()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "图书查询"
        self.namefield.delegate = self
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        searchbtn.layer.cornerRadius = 5
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillDisappear(animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    //查询按钮点击事件
    @IBAction func onSearch(sender: AnyObject) {
        var username = namefield.text as NSString
        var postusername = username as String
        content = eHttp.getBook("***",bookname: postusername)
        self.performSegueWithIdentifier("showbooklist", sender: content)
    }
    
    //准备第一页查询结果，进行跳转
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showbooklist" {
            let navigationController = segue.destinationViewController as! UINavigationController
            let controller = navigationController.topViewController as! bookListController
            controller.pageinfo = sender as! pagecontent
        }
    }
    
    //图书名输入完毕，return收回虚拟键盘，界面下移恢复
    @IBAction func onFinishEdit(sender: AnyObject) {
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
        self.namefield.resignFirstResponder()
    }
    
    //点击输入框，出现虚拟键盘，界面上移使输入框不被遮挡
    func textFieldDidBeginEditing(textField: UITextField){
        UIView.animateWithDuration(0.4, animations: {
            self.view.frame.origin.y = -150
        })
    }
}
