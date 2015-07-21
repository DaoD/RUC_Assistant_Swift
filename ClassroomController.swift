//
//  ClassroomController.swift
//  RUC_Assist
//  自习室信息选择界面
//  作者: DaoD 时间: 5/16/15.
//  版权所有: 2015 DaoD.
//

import UIKit

class ClassroomController: UIViewController, UIPickerViewDelegate, HttpProtocol {
    
    //教学楼选择内容
    var d1 = ["公共教学一楼","公共教学二楼","公共教学三楼","公共教学四楼","明德主楼","明德商学楼","明德国际楼","明德法学楼","明德新闻楼","求是楼"]
    //星期选择内容
    var d2 = ["星期一","星期二","星期三","星期四","星期五"]
    //起始节数选择内容
    var d3 = ["第1节","第2节","第3节","第4节","第5节","第6节","第7节","第8节","第9节","第10节","第11节","第12节","第13节","第14节"]
    //结束节数选择内容
    var d4 = ["第1节","第2节","第3节","第4节","第5节","第6节","第7节","第8节","第9节","第10节","第11节","第12节","第13节","第14节"]
    var str1 = "公共教学一楼"
    var str2 = "星期一"
    var str3 = "第1节"
    var str4 = "第1节"
    var eHttp:HttpController = HttpController()
    var alert:UIAlertView?
    var classroomlist:[String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        eHttp.delegate = self
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillDisappear(animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    //设置选择器列数
    func numberOfComponentsInPickerView(pickerView: UIPickerView!) -> Int {
        if pickerView.tag == 1 {
            return 1
        }
        else {
            return 3
        }
    }
    
    //设置选择器内容行数
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView.tag == 1 {
            return d1.count
        }
        else if component == 0 {
            return d2.count
        }
        else if component == 1 {
            return d3.count
        }
        else {
            return d4.count
        }
        
    }
    
    //设置选择器内容
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        if pickerView.tag == 1 {
            return d1[row]
        }
        else if component == 0 {
            return d2[row]
        }
        else if component == 1 {
            return d3[row]
        }
        else {
            return d4[row]
        }
    }
    
    //选择器选择内容
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView.tag == 1 {
            str1 = d1[row]
        }
        else if component == 0 {
            str2 = "\(row)"
        }
        else if component == 1 {
            str3 = "\(row)"
        }
        else {
            str4 = "\(row)"
        }
    }
    
    //查询按钮点击事件
    @IBAction func onSearch(sender: AnyObject) {
        //起始节数不得大于结束节数
        if (str3.toInt() > str4.toInt()) {
            alert = UIAlertView(title: "错误!", message: "请输入正确的起止时间", delegate: self, cancelButtonTitle: "确定")
            alert!.alertViewStyle = UIAlertViewStyle.Default
            alert!.show()
        }
        //输入合法
        else {
            classroomlist = eHttp.getClass("***", week: str2, building: str1, startTime: str3, endTime: str4)
            self.performSegueWithIdentifier("showclassroomlist", sender: classroomlist)
        }
    }
    
    //准备查询结果，进行跳转
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showclassroomlist" {
            let navigationController = segue.destinationViewController as! UINavigationController
            let controller = navigationController.topViewController as! classroomListController
            controller.classroomList = sender as! Array<String>
        }
    }
    
    //实现HttpProtocol协议的函数
    func didReceiveResults(results: NSData) {
    }
}
