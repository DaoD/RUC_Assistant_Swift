//
//  scoreDetailController.swift
//  RUC_Assist
//  成绩详细信息界面
//  作者: DaoD 时间: 5/11/15.
//  版权所有: 2015 DaoD.
//

import UIKit

class scoreDetailController: UITableViewController {
    
    //成绩数据
    var scoredetail:score?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = self.scoredetail?.name
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //初始化列表行数
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 9
    }
    
    //用收到的成绩数据填写列表内容
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "scoredetailList")
        switch indexPath.row {
        case 0:
            cell.textLabel?.text = "课程名称:\(scoredetail!.name)"
        case 1:
            cell.textLabel?.text = "教师:\(scoredetail!.teacher)"
        case 2:
            cell.textLabel?.text = "课程类型:\(scoredetail!.type)"
        case 3:
            cell.textLabel?.text = "学分:\(scoredetail!.credit)"
        case 4:
            cell.textLabel?.text = "平时成绩:\(scoredetail!.normalscore)"
        case 5:
            cell.textLabel?.text = "期中成绩:\(scoredetail!.midscore)"
        case 6:
            cell.textLabel?.text = "期末成绩:\(scoredetail!.endscore)"
        case 7:
            cell.textLabel?.text = "最终成绩:\(scoredetail!.finalscore)"
        case 8:
            cell.textLabel?.text = "绩点:\(scoredetail!.point)"
        default:
            ()
        }
        return cell
    }

}
