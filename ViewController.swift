//
//  ViewController.swift
//  RUC_Assist
//  主界面
//  作者: DaoD 时间: 3/24/15.
//  版权所有: 2015 DaoD.
//

import UIKit

class ViewController: UIViewController, HttpProtocol {

    var eHttp:HttpController = HttpController()
    //登录信息
    var user:logininfo?
    
    @IBOutlet weak var coursebtn: UIButton!
    @IBOutlet weak var scorebtn: UIButton!
    @IBOutlet weak var classroombtn: UIButton!
    @IBOutlet weak var bookbtn: UIButton!
    @IBOutlet weak var notebtn: UIButton!
    @IBOutlet weak var bg: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        coursebtn.layer.cornerRadius = 5
        coursebtn.layer.borderWidth = 1.5
        coursebtn.layer.borderColor = UIColor(red: 176/255, green: 198/255, blue: 215/255, alpha: 1).CGColor
        scorebtn.layer.cornerRadius = 5
        scorebtn.layer.borderWidth = 1.5
        scorebtn.layer.borderColor = UIColor(red: 176/255, green: 198/255, blue: 215/255, alpha: 1).CGColor
        classroombtn.layer.cornerRadius = 5
        classroombtn.layer.borderWidth = 1.5
        classroombtn.layer.borderColor = UIColor(red: 176/255, green: 198/255, blue: 215/255, alpha: 1).CGColor
        bookbtn.layer.cornerRadius = 5
        bookbtn.layer.borderWidth = 1.5
        bookbtn.layer.borderColor = UIColor(red: 176/255, green: 198/255, blue: 215/255, alpha: 1).CGColor
        notebtn.layer.cornerRadius = 5
        notebtn.layer.borderWidth = 1.5
        notebtn.layer.borderColor = UIColor(red: 176/255, green: 198/255, blue: 215/255, alpha: 1).CGColor
//        self.navigationController!.view.addSubview(bg)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func didReceiveResults(results: NSData) {
    }

    //课表查询按钮点击事件
    @IBAction func getcourse(sender: AnyObject) {
        self.performSegueWithIdentifier("getcourse", sender: nil)
    }
    
    //成绩查询按钮点击事件
    @IBAction func getscore(sender: AnyObject) {
        self.performSegueWithIdentifier("getscore", sender: user)
    }
    
    //借阅记录查询按钮点击事件
    @IBAction func getnote(sender: AnyObject) {
        self.performSegueWithIdentifier("getnote", sender: nil)
    }
    
    //图书查询按钮点击事件
    @IBAction func getbook(sender: AnyObject) {
        self.performSegueWithIdentifier("getbook", sender: nil)
    }
    
    //自习室查询按钮点击事件
    @IBAction func getclassroom(sender: AnyObject) {
        self.performSegueWithIdentifier("getclassroom", sender: nil)
    }
    
    //准备登录信息，进行跳转
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "getscore" {
            let navigationController = segue.destinationViewController as! UINavigationController
            let controller = navigationController.topViewController as! ScoreController
            controller.user = sender as? logininfo
        }
    }
    
}

