//
//  bookDetailController.swift
//  RUC_Assist
//  图书详细信息界面
//  作者: DaoD 时间: 5/16/15.
//  版权所有: 2015 DaoD.
//

import UIKit

class bookDetailController: UITableViewController {
    
    var abook:bookdetail?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = self.abook?.title
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //初始化列表行数
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
    
    //用图书信息填写列表内容
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "bookdetailList")
        switch indexPath.row {
        case 0:
            cell.textLabel?.text = "书名:\(abook!.title)"
        case 1:
            cell.textLabel?.text = "作者:\(abook!.author)"
        case 2:
            cell.textLabel?.text = "出版社:\(abook!.publisher)"
        case 3:
            cell.textLabel?.text = "出版日期:\(abook!.publishing_date)"
        case 4:
            cell.textLabel?.text = "附注:\(abook!.pages)"
        case 5:
            cell.textLabel?.text = "ISBN:\(abook!.isbn)"
        case 6:
            cell.textLabel?.text = "馆藏分布状况:\(abook!.copy_info)"
        default:
            ()
        }
        return cell
    }
    
}
