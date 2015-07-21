//
//  courseDetailController.swift
//  RUC_Assist
//  每日课表界面
//  作者: DaoD 时间: 5/13/15.
//  版权所有: 2015 DaoD.
//

import UIKit

class courseDetailController: UITableViewController {
    
    var coursedetail:weekcourse?
    var sortArray:[course] = []
    
    //根据上课时间进行排序
    //先按上课时间信息长度进行排序，如：1-2节 < 11-12节
    func onSort1(s1:course, s2:course) -> Bool{
        return count(s1.time) < count(s2.time)
    }
    //相同上课时间信息长度，按时间大小进行排序，如：1-2节 < 3-4节
    func onSort2(s1:course, s2:course) -> Bool{
        if count(s1.time) == count(s2.time) {
            return s1.time < s2.time
        }
        else {
            return false
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sortArray = self.coursedetail!.acourse
        sortArray.sort(onSort1)
        sortArray.sort(onSort2)
        self.title = self.coursedetail!.day
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //初始化列表行数
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.coursedetail!.acourse.count
    }
    
    //用课程信息填写列表内容
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "coursedetailList")
        cell.textLabel?.text = "\(sortArray[indexPath.row].name)"
        cell.detailTextLabel?.text = "\(sortArray[indexPath.row].time)" + " " + "\(sortArray[indexPath.row].place)" + " " + "\(sortArray[indexPath.row].teacher)"
        return cell
    }
}
