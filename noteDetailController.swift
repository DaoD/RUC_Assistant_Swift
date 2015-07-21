//
//  noteDetailController.swift
//  RUC_Assist
//  借阅信息界面
//  作者: DaoD 时间: 5/14/15.
//  版权所有: 2015 DaoD.
//

import UIKit

class noteDetailController: UITableViewController {
    
    var noteList:[noteinfo] = []
    
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
        return noteList.count
    }
    
    //用借阅信息填写列表内容
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "notedetailList")
        cell.textLabel?.text = "\(noteList[indexPath.row].bookname)"
        cell.detailTextLabel?.text = "到期时间:" + "\(noteList[indexPath.row].limittime)"
        return cell
    }
}
