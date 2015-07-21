//
//  classroomListController.swift
//  RUC_Assist
//  查询结果界面
//  作者: DaoD 时间: 5/16/15.
//  版权所有: 2015 DaoD.
//

import UIKit

class classroomListController: UITableViewController {
    
    var classroomList:[String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "查询结果"
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //初始化列表行数
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return classroomList.count
    }
    
    //用查询结果填写列表内容
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "classroomdetailList")
        cell.textLabel?.text = "\(classroomList[indexPath.row])"
        return cell
    }
}
