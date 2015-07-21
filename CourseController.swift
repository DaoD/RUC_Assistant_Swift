//
//  CourseController.swift
//  RUC_Assist
//  选择星期界面
//  作者: DaoD 时间: 5/12/15.
//  版权所有: 2015 DaoD.
//

import UIKit

class CourseController: UITableViewController, HttpProtocol {
    
    var eHttp:HttpController = HttpController()
    var courses:[course] = []
    //分别存储每天课程信息
    var courses_1:[course] = []
    var courses_2:[course] = []
    var courses_3:[course] = []
    var courses_4:[course] = []
    var courses_5:[course] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        eHttp.delegate = self
        eHttp.getCourse("***")
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillDisappear(animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    //初始化列表行数
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    //用星期填写列表内容
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "courseList")
        switch indexPath.row {
        case 0:
            cell.textLabel?.text = "星期一"
        case 1:
            cell.textLabel?.text = "星期二"
        case 2:
            cell.textLabel?.text = "星期三"
        case 3:
            cell.textLabel?.text = "星期四"
        case 4:
            cell.textLabel?.text = "星期五"
        default:
            ()
        }
        return cell
    }
    
    //选择列表每一行时，发送数据，跳转页面
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        switch indexPath.row {
        case 0:
            var weekcoursedetail = weekcourse()
            weekcoursedetail.acourse = courses_1
            weekcoursedetail.day = "星期一"
            self.performSegueWithIdentifier("showcoursedetail", sender: weekcoursedetail)
        case 1:
            var weekcoursedetail = weekcourse()
            weekcoursedetail.acourse = courses_2
            weekcoursedetail.day = "星期二"
            self.performSegueWithIdentifier("showcoursedetail", sender: weekcoursedetail)
        case 2:
            var weekcoursedetail = weekcourse()
            weekcoursedetail.acourse = courses_3
            weekcoursedetail.day = "星期三"
            self.performSegueWithIdentifier("showcoursedetail", sender: weekcoursedetail)
        case 3:
            var weekcoursedetail = weekcourse()
            weekcoursedetail.acourse = courses_4
            weekcoursedetail.day = "星期四"
            self.performSegueWithIdentifier("showcoursedetail", sender: weekcoursedetail)
        case 4:
            var weekcoursedetail = weekcourse()
            weekcoursedetail.acourse = courses_5
            weekcoursedetail.day = "星期五"
            self.performSegueWithIdentifier("showcoursedetail", sender: weekcoursedetail)
        default:
            ()
        }
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    //准备每天课程信息，进行跳转
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showcoursedetail" {
            let navigationController = segue.destinationViewController as! UINavigationController
            let controller = navigationController.topViewController as! courseDetailController
            controller.coursedetail = sender as? weekcourse
        }
    }
    
    //接收每天课程信息
    func didReceiveResults(results: NSData) {
        //接收数据有中文，需转为GBK编码
        var encode:NSStringEncoding = CFStringConvertEncodingToNSStringEncoding(CFStringEncoding(CFStringEncodings.GB_18030_2000.rawValue))
        let s:NSString = NSString(data: results, encoding: encode)!
        let html = s
        var doc:TFHpple = TFHpple(data: results, encoding: "GBK", isXML: false)
        var result:NSArray = doc.searchWithXPathQuery("//td[@class='cellContent']")
        var times:Int = 0
        var judge = ""
        var delete = 0
        var numberofcourses = 0
        
        //存储课程信息
        for node in result {
            var id = times / 14
            var item = times % 14
            if item == 0 {
                var a_course = course()
                courses.append(a_course)
            }
            switch item {
            case 6:
                courses[id].name = node.content
            case 7:
                courses[id].type = node.content
            case 8:
                courses[id].credit = node.content
            case 10:
                var myString = node.content as String
                var bytes:[UInt8]=[13,10]
                let data = NSData(bytes: bytes, length: bytes.count)
                let exceptString = NSString(data: data, encoding: NSUTF8StringEncoding)
                var tmpstring1 = myString.stringByReplacingOccurrencesOfString(exceptString as! String, withString: "")
                var tmpstring2 = tmpstring1.stringByReplacingOccurrencesOfString("  ", withString: "")
                var myArray = tmpstring2.componentsSeparatedByCharactersInSet(NSCharacterSet (charactersInString: " ,"))
                //过滤部分无上课地点与时间的特殊课程
                if myArray.count < 5 {
                    delete = 1
                }
                //根据课程学分数存储课程信息
                else {
                    courses[id].day = (myArray[1] as NSString).substringFromIndex(13)
                    courses[id].time = myArray[2]
                    courses[id].place = "\((myArray[3] as NSString).substringFromIndex(1))" + " " + "\(myArray[4])"
                    numberofcourses = courses[id].credit.toInt()! / 2
                    for(var i:Int = 1; i < numberofcourses; ++i) {
                        var a_course = course()
                        courses.append(a_course)
                        courses[id+1].name = courses[id].name
                        courses[id+1].type = courses[id].type
                        courses[id+1].credit = courses[id].credit
                        courses[id+i].day = (myArray[i*4+1] as NSString).substringFromIndex(13)
                        courses[id+i].time = myArray[i*4+2]
                        courses[id+i].place = "\((myArray[i*4+3] as NSString).substringFromIndex(1))" + " " + "\(myArray[i*4+4])"
                    }
                    times = times + (numberofcourses - 1) * 14
                }
            case 11:
                courses[id].teacher = node.content
                for(var i:Int = 1; i < numberofcourses; ++i) {
                    courses[id-i].teacher = node.content
                }
            case 13:
                if delete == 1 {
                    courses.removeLast()
                    times = times - 14
                    delete = 0
                }
            default:
                ()
            }
            ++times;
        }
        
        //将课程分类到每天的课程中
        for a_course in courses {
            if a_course.day == "星期一" {
                courses_1.append(a_course)
            }
            else if a_course.day == "星期二" {
                courses_2.append(a_course)
            }
            else if a_course.day == "星期三" {
                courses_3.append(a_course)
            }
            else if a_course.day == "星期四" {
                courses_4.append(a_course)
            }
            else if a_course.day == "星期五" {
                courses_5.append(a_course)
            }
        }
    }
}
