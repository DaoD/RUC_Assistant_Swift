//
//  bookListController.swift
//  RUC_Assist
//  图书列表界面
//  作者: DaoD 时间: 5/15/15.
//  版权所有: 2015 DaoD.
//

import UIKit

class bookListController: UIViewController {
    
    //每页信息
    var pageinfo:pagecontent = pagecontent()
    var url = ""
    //图书详细信息
    var abook:bookdetail = bookdetail()
    @IBOutlet weak var myTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        url = "***" + pageinfo.pageaction
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //初始化列表行数
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.title = "第\(pageinfo.pagenumber)页"
        return pageinfo.booklist.count
    }
    
    //用图书信息填写列表内容
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "bookdetailList")
        cell.textLabel?.text = "\(pageinfo.booklist[indexPath.row].title)"
        cell.detailTextLabel?.text = "\(pageinfo.booklist[indexPath.row].author)" + " " + "\(pageinfo.booklist[indexPath.row].callnumber)"
        return cell
    }
    
    //选择列表每一行时，发送数据，跳转页面
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var nsUrl:NSURL = NSURL(string: url.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!)!
        var request:NSMutableURLRequest = NSMutableURLRequest(URL: nsUrl)
        request.HTTPMethod = "POST"
        var number = (pageinfo.pagenumber - 1) * 20 + indexPath.row
        var postString:NSString = "first_hit=\((pageinfo.pagenumber - 1) * 20 + 1)" + "&last_hit=\(pageinfo.pagenumber * 20)" + "&form_type=" + "&VIEW^\(number+1)=详细资料"
        var postData:NSData = postString.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)!
        request.HTTPBody = postData
        var data:NSData = NSURLConnection.sendSynchronousRequest(request, returningResponse: nil, error: nil)!
        var doc:TFHpple = TFHpple(data: data, encoding: "UTF8", isXML: false)
        var result:NSArray = doc.searchWithXPathQuery("//dd")
        var times = 0
        //存储图书信息
        for node in result {
            var element:TFHppleElement = node as! TFHppleElement
            var target:NSDictionary = element.attributes
            var content = element.content.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
            if (target["class"] != nil) {
                if (target["class"] as! String) == "title" {
                    abook.title = content
                }
                else if (target["class"] as! String) == "author" {
                    abook.author = content
                }
                else if (target["class"] as! String) == "publisher" {
                    abook.publisher = content
                }
                else if (target["class"] as! String) == "publishing_date" {
                    abook.publishing_date = content
                }
                else if (target["class"] as! String) == "pages" {
                    abook.pages = content
                }
                else if (target["class"] as! String) == "isbn" {
                    abook.isbn = content
                }
                else if (target["class"] as! String) == "copy_info" {
                    abook.copy_info = content
                }
                ++times
            }
            if(times == 7) {
                break
            }
        }
        self.performSegueWithIdentifier("showbookdetail", sender: abook)
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    //准备图书信息，进行跳转
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showbookdetail" {
            let navigationController = segue.destinationViewController as! UINavigationController
            let controller = navigationController.topViewController as! bookDetailController
            controller.abook = sender as? bookdetail
        }
    }
    
    //翻页按钮点击事件
    @IBAction func onClick(sender: AnyObject) {
        let item = sender as! UIBarItem
        url = "***" + pageinfo.pageaction
        //向左翻页
        if item.tag == 1 {
            //当前页面不是第一页，允许左翻
            if pageinfo.pagenumber > 1 {
                var nsUrl:NSURL = NSURL(string: url.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!)!
                var request:NSMutableURLRequest = NSMutableURLRequest(URL: nsUrl)
                request.HTTPMethod = "POST"
                var leftpage:Int = pageinfo.pagenumber - 1
                //计算post数据
                var postString:NSString = "first_hit=\((pageinfo.pagenumber - 1) * 20 + 1)" + "&last_hit=\(pageinfo.pagenumber * 20)" + "&form_type=JUMP^\((leftpage - 1)  * 20 + 1)"
                var postData:NSData = postString.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)!
                request.HTTPBody = postData
                var data:NSData = NSURLConnection.sendSynchronousRequest(request, returningResponse: nil, error: nil)!
                let s:NSString = NSString(data: data, encoding: NSUTF8StringEncoding)!
                var doc:TFHpple = TFHpple(data: data, encoding: "UTF8", isXML: false)
                var result:NSArray = doc.searchWithXPathQuery("//dd")
                var action:NSArray = doc.searchWithXPathQuery("//form[@class='hit_list_form']")
                for node in action {
                    var element:TFHppleElement = node as! TFHppleElement
                    var target:NSDictionary = element.attributes
                    var targetstring = target["action"] as! String
                    pageinfo.pageaction = targetstring
                }
                pageinfo.pagenumber = pageinfo.pagenumber - 1
                var booklist:[bookinfo] = []
                var times = 0
                //存储图书信息
                for node in result {
                    var id = times / 7
                    var item = times % 7
                    var element:TFHppleElement = node as! TFHppleElement
                    var content = element.content.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
                    if item == 0 {
                        var a_book = bookinfo()
                        booklist.append(a_book)
                    }
                    switch item {
                    case 0:
                        booklist[id].title = content
                    case 1:
                        booklist[id].author = content
                    case 2:
                        booklist[id].callnumber = content
                    case 3:
                        booklist[id].publisher = content
                    case 4:
                        booklist[id].edition = content
                    case 5:
                        booklist[id].time = content
                    case 6:
                        booklist[id].holdings = content
                    default:
                        ()
                    }
                    ++times
                }
                pageinfo.booklist = booklist
                //信息获取完毕，更新列表内容
                self.myTable.reloadData()
            }
        }
        //向右翻页
        else {
            //当前页面不是最后一页，允许右翻
            if pageinfo.pagenumber < pageinfo.pagerange {
                var nsUrl:NSURL = NSURL(string: url.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!)!
                var request:NSMutableURLRequest = NSMutableURLRequest(URL: nsUrl)
                request.HTTPMethod = "POST"
                var rightpage:Int = pageinfo.pagenumber + 1
                //计算post数据
                var postString:NSString = "first_hit=\((pageinfo.pagenumber - 1) * 20 + 1)" + "&last_hit=\(pageinfo.pagenumber * 20)" + "&form_type=JUMP^\(pageinfo.pagenumber * 20 + 1)"
                var postData:NSData = postString.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)!
                request.HTTPBody = postData
                var data:NSData = NSURLConnection.sendSynchronousRequest(request, returningResponse: nil, error: nil)!
                let s:NSString = NSString(data: data, encoding: NSUTF8StringEncoding)!
                var doc:TFHpple = TFHpple(data: data, encoding: "UTF8", isXML: false)
                var result:NSArray = doc.searchWithXPathQuery("//dd")
                var action:NSArray = doc.searchWithXPathQuery("//form[@class='hit_list_form']")
                for node in action {
                    var element:TFHppleElement = node as! TFHppleElement
                    var target:NSDictionary = element.attributes
                    var targetstring = target["action"] as! String
                    pageinfo.pageaction = targetstring
                }
                pageinfo.pagenumber = pageinfo.pagenumber + 1
                var booklist:[bookinfo] = []
                var times = 0
                //存储图书信息
                for node in result {
                    var id = times / 7
                    var item = times % 7
                    var element:TFHppleElement = node as! TFHppleElement
                    var content = element.content.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
                    if item == 0 {
                        var a_book = bookinfo()
                        booklist.append(a_book)
                    }
                    switch item {
                    case 0:
                        booklist[id].title = content
                    case 1:
                        booklist[id].author = content
                    case 2:
                        booklist[id].callnumber = content
                    case 3:
                        booklist[id].publisher = content
                    case 4:
                        booklist[id].edition = content
                    case 5:
                        booklist[id].time = content
                    case 6:
                        booklist[id].holdings = content
                    default:
                        ()
                    }
                    ++times
                }
                pageinfo.booklist = booklist
                //信息获取完毕，更新列表内容
                self.myTable.reloadData()
            }
        }
    }
}
