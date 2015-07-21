//
//  ScoreController.swift
//  RUC_Assist
//  成绩信息界面
//  作者: DaoD 时间 3/26/15.
//  版权所有: 2015 DaoD.
//

import UIKit

class ScoreController: UITableViewController, HttpProtocol {
    
    @IBOutlet weak var tv: UITableView!
    var eHttp:HttpController = HttpController()
    var course:[score] = []
    var user:logininfo?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        eHttp.delegate = self
        eHttp.getScore("***=\(user!.username)")
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
        return course.count
    }
    
    //用课程名填写列表内容
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "scoreList")
        cell.textLabel?.text = "\(course[indexPath.row].name)"
        return cell
    }
    
    //选择列表每一行时，发送数据，跳转页面
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let scoredetail = course[indexPath.row]
        self.performSegueWithIdentifier("showscoredetail", sender: scoredetail)
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    //准备成绩信息，进行跳转
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showscoredetail" {
            let navigationController = segue.destinationViewController as! UINavigationController
            let controller = navigationController.topViewController as! scoreDetailController
            controller.scoredetail = sender as? score
        }
    }
    
    //接收成绩信息
    func didReceiveResults(results: NSData) {
        var doc:TFHpple = TFHpple(data: results, encoding: "GBK", isXML: false)
        var result:NSArray = doc.searchWithXPathQuery("//td[@class='cellContent' and not(@colspan='13')]")
        var times:Int = 0
        for node in result {
            var id = times / 10
            var item = times % 10
            var element:TFHppleElement = node as! TFHppleElement
            var content = element.content.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
            if item == 0 {
                var a_score = score()
                course.append(a_score)
            }
            switch item {
            case 0:
                course[id].name = content
            case 1:
                course[id].teacher = content
            case 2:
                course[id].type = content
            case 3:
                course[id].credit = content
            case 4:
                course[id].normalscore = content
            case 5:
                course[id].midscore = content
            case 6:
                course[id].endscore = content
            case 7:
                course[id].finalscore = content
            case 8:
                course[id].point = content
            default:
                ()
            }
            ++times
        }
    }
}
