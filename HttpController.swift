//
//  HttpController.swift
//  RUC_Assist
//  Http代理类
//  作者: DaoD 时间: 3/24/15.
//  版权所有: 2015 DaoD.
//

import UIKit
import Foundation

//协议与所有公有类定义
protocol HttpProtocol {
    func didReceiveResults(resultes: NSData)
}

//数字人大登录信息类
class logininfo {
    var username:String = ""
    var password:String = ""
    var token:String = ""
}

//图书馆登录信息类
class libuser {
    var username:String = ""
    var password:String = ""
}

//成绩信息类
class score {
    var name:String = ""
    var teacher:String = ""
    var type:String = ""
    var credit:String = ""
    var normalscore:String = ""
    var midscore:String = ""
    var endscore:String = ""
    var finalscore:String = ""
    var point:String = ""
}

//课程信息类
class course {
    var name:String = ""
    var type:String = ""
    var credit:String = ""
    var day:String = ""
    var time:String = ""
    var place:String = ""
    var teacher:String = ""
}

//星期与课程封装类
class weekcourse {
    var acourse:[course] = []
    var day:String = ""
}

//借阅信息类
class noteinfo {
    var bookname:String = ""
    var limittime:String = ""
}

//图书信息类
class bookinfo {
    var title:String = ""
    var author:String = ""
    var callnumber:String = ""
    var publisher:String = ""
    var edition:String = ""
    var time:String = ""
    var holdings:String = ""
}

//每页图书类
class pagecontent {
    var booklist:[bookinfo] = []
    var pagenumber:Int = 0
    var pageaction:String = ""
    var pagerange:Int = 0
}

//图书详细信息类
class bookdetail {
    var title:String = ""
    var author:String = ""
    var publisher:String = ""
    var publishing_date:String = ""
    var pages:String = ""
    var isbn:String = ""
    var copy_info:String = ""
    
}

class HttpController: NSObject {
    
    var delegate:HttpProtocol?
    
    //获取登录所需token，函数返回token值
    func getToken(url:String) -> String{
        var nsUrl:NSURL? = NSURL(string: url)
        var request:NSURLRequest = NSURLRequest(URL: nsUrl!)
        var cookieString:String?
        NSURLConnection.sendSynchronousRequest(request, returningResponse: nil, error: nil)
        let receiveCookie = NSHTTPCookieStorage.sharedHTTPCookieStorage() as NSHTTPCookieStorage
        let cookiesArray:NSArray = NSArray(array: receiveCookie.cookies!)
        //token存于cookie中
        for cookie in cookiesArray {
            if cookie.name == "csrf_token" {
                cookieString = NSString(string: cookie.value!!) as String
            }
        }
        return cookieString!
    }
    
    //登录，函数无返回值
    func startLogin(url:String, token:String, username:String, password:String) {
        var nsUrl:NSURL = NSURL(string: url)!
        var request:NSMutableURLRequest = NSMutableURLRequest(URL: nsUrl)
        var url_redirect:String = "***"
        request.HTTPMethod = "POST"
        var postString:NSString = "csrf_token=\(token)" + "&school_code=ruc" + "&username=\(username)" + "&password=\(password)" + "&remember_me=true"
        var postData:NSData = postString.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)!
        request.HTTPBody = postData
        NSURLConnection.sendSynchronousRequest(request, returningResponse: nil, error: nil)
        //post数据后跳转
        var nsUrl2:NSURL = NSURL(string: url_redirect)!
        var request2:NSURLRequest = NSURLRequest(URL: nsUrl2)
        NSURLConnection.sendSynchronousRequest(request2, returningResponse: nil, error: nil)!
    }
    
    //获取成绩信息，利用代理返回数据，函数无返回值
    func getScore(url_score:String) {
        var nsUrl:NSURL = NSURL(string: url_score)!
        var request:NSMutableURLRequest = NSMutableURLRequest(URL: nsUrl)
        request.addValue("***", forHTTPHeaderField: "Referer")
        request.addValue("Mozilla/5.0 (Macintosh; Intel Mac OS X 10.10; rv:34.0) Gecko/20100101 Firefox/34.0", forHTTPHeaderField: "User-Agent")
        request.addValue("zh-cn,zh;q=0.8,en-us;q=0.5,en;q=0.3", forHTTPHeaderField: "Accept-Language")
        request.addValue("gzip, deflate", forHTTPHeaderField: "Accept-Encoding")
        var data:NSData = NSURLConnection.sendSynchronousRequest(request, returningResponse: nil, error: nil)!
        self.delegate?.didReceiveResults(data)
    }
    
    //获取选课信息，利用代理返回数据，函数无返回值
    func getCourse(url_score:String) {
        var nsUrl:NSURL = NSURL(string: url_score)!
        var request:NSMutableURLRequest = NSMutableURLRequest(URL: nsUrl)
        request.HTTPMethod = "POST"
        //每页显示一百个通过的课程
        var postString:NSString = "method=queryXkjg" + "&isNeedInitSQL=true" + "&xnd=2014-2015" + "&xq=2" + "&condition_xnd=2014-2015" + "&condition_xq=2" + "&condition_kclb=" + "&condition_spbz=3" + "&pageNo=1" + "&pageSize=100"
        var postData:NSData = postString.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)!
        request.HTTPBody = postData
        request.addValue("***", forHTTPHeaderField: "Referer")
        request.addValue("Mozilla/5.0 (Macintosh; Intel Mac OS X 10.10; rv:34.0) Gecko/20100101 Firefox/34.0", forHTTPHeaderField: "User-Agent")
        request.addValue("zh-cn,zh;q=0.8,en-us;q=0.5,en;q=0.3", forHTTPHeaderField: "Accept-Language")
        request.addValue("gzip, deflate", forHTTPHeaderField: "Accept-Encoding")
        var data:NSData = NSURLConnection.sendSynchronousRequest(request, returningResponse: nil, error: nil)!
        self.delegate?.didReceiveResults(data)
    }
    
    //获取图书馆动态action，函数返回action值
    func getAction(url:String) -> String {
        var nsUrl:NSURL = NSURL(string: url.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!)!
        var request:NSURLRequest = NSURLRequest(URL: nsUrl)
        var data:NSData = NSURLConnection.sendSynchronousRequest(request, returningResponse: nil, error: nil)!
        var doc:TFHpple = TFHpple(data: data, encoding: "UTF8", isXML: false)
        var result:NSArray = doc.searchWithXPathQuery("//form[@class='renew_materials']")
        var element:TFHppleElement = result[0] as! TFHppleElement
        var target:NSDictionary = element.attributes
        var action = target["action"] as! String
        action = "***" + action
        return action
    }
    
    //登录图书馆查询借阅信息，函数返回借阅信息
    func loginLib(url_lib:String, username:String, password:String) -> Array<noteinfo>{
        var nsUrl:NSURL = NSURL(string: url_lib.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!)!
        var request:NSMutableURLRequest = NSMutableURLRequest(URL: nsUrl)
        request.HTTPMethod = "POST"
        var postString:NSString = "user_id=\(username)" + "&password=\(password)"
        var postData:NSData = postString.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)!
        request.HTTPBody = postData
        var data:NSData = NSURLConnection.sendSynchronousRequest(request, returningResponse: nil, error: nil)!
        let s:NSString = NSString(data: data, encoding: NSUTF8StringEncoding)!
        //判断是否能正确查到借阅信息
        var judge = Regex("登录无效").test(s as String)
        var judge2 = Regex("此读者没有借书").test(s as String)
        var judge3 = Regex("你不能续借文献资料").test(s as String)
        var returndata:[noteinfo] = []
        if judge.count > 0 {
            return returndata
        }
        else if judge2.count > 0{
            return returndata
        }
        else if judge3.count > 0{
            return returndata
        }
        else {
            let html = s as String
            var doc:TFHpple = TFHpple(data: data, encoding: "UTF8", isXML: false)
            var result:NSArray = doc.searchWithXPathQuery("//p[@class='subheader']/strong")
            var element:TFHppleElement = result[0] as! TFHppleElement
            var number:Int = element.content.toInt()!
            var result_name:[String] = []
            //获取图书名信息
            for(var i:Int = 1; i <= number; ++i) {
                var result_bookname:NSArray = doc.searchWithXPathQuery("//label[@for='RENEW\(i)']")
                for x in result_bookname {
                    var myString = x.content as String
                    var bytes:[UInt8]=[13,10]
                    let tmpdata = NSData(bytes: bytes, length: bytes.count)
                    let exceptString = NSString(data: tmpdata, encoding: NSUTF8StringEncoding)
                    var tmpstring1 = myString.stringByReplacingOccurrencesOfString(exceptString as! String, withString: "")
                    var tmpstring2 = tmpstring1.stringByReplacingOccurrencesOfString("\n", withString: "")
                    var tmpstring3 = tmpstring2.stringByReplacingOccurrencesOfString("\t", withString: "")
                    var tmpstring4 = tmpstring3.stringByReplacingOccurrencesOfString("  ", withString: "")
                    result_name.append(tmpstring4)
                }
            }
            //获取到期时间信息
            var result_time = Regex("<strong>.*</strong><br/>").test(html)
            for(var i = 0; i < result_time.count; i++) {
                var a_note = noteinfo()
                a_note.bookname = result_name[i]
                a_note.limittime = (result_time[i] as NSString).substringWithRange(NSMakeRange(8, count(result_time[i])-22))
                returndata.append(a_note)
            }
            return returndata
        }
    }
    
    //获得第一页图书信息，函数返回每页内容
    func getBook(url:String, bookname:String) -> pagecontent{
        var nsUrl:NSURL = NSURL(string: url.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!)!
        var request:NSMutableURLRequest = NSMutableURLRequest(URL: nsUrl)
        request.HTTPMethod = "POST"
        var postString:NSString = "searchdata1=\(bookname)" + "&srchfield1=TI^TITLE^SERIES^Title Processing^题名" + "&library=ALL" + "&sort_by=TI&relevance=off"
        var postData:NSData = postString.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)!
        request.HTTPBody = postData
        var data:NSData = NSURLConnection.sendSynchronousRequest(request, returningResponse: nil, error: nil)!
        let s:NSString = NSString(data: data, encoding: NSUTF8StringEncoding)!
        var doc:TFHpple = TFHpple(data: data, encoding: "UTF8", isXML: false)
        var result:NSArray = doc.searchWithXPathQuery("//dd")
        var action:NSArray = doc.searchWithXPathQuery("//form[@class='hit_list_form']")
        var pagerange:NSArray = doc.searchWithXPathQuery("//div[@class='searchsummary']/em")
        var returndata:pagecontent = pagecontent()
        returndata.pagenumber = 1
        
        //获取动态生成的新的action值
        for node in action {
            var element:TFHppleElement = node as! TFHppleElement
            var target:NSDictionary = element.attributes
            var targetstring = target["action"] as! String
            returndata.pageaction = targetstring
        }
        
        //获取图书列表页数
        for node in pagerange {
            var element:TFHppleElement = node as! TFHppleElement
            var max:Int = element.content.toInt()!
            var range:Int = max / 20 + 1
            returndata.pagerange = range
        }
        var booklist:[bookinfo] = []
        var times = 0
        
        //存储获得的信息
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
        returndata.booklist = booklist
        return returndata
    }
    
    //获得空教室信息，函数返回空教室列表
    func getClass(url:String, week:String, building:String, startTime:String, endTime:String) -> Array<String> {
        var classlist:[String] = []
        var nsUrl:NSURL = NSURL(string: url.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!)!
        var request:NSMutableURLRequest = NSMutableURLRequest(URL: nsUrl)
        request.HTTPMethod = "POST"
        var postString:NSString = "week=\(week)" + "&building=\(building)" + "&startTime=\(startTime)" + "&endTime=\(endTime)"
        var postData:NSData = postString.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)!
        request.HTTPBody = postData
        var data:NSData = NSURLConnection.sendSynchronousRequest(request, returningResponse: nil, error: nil)!
        let s:NSString = NSString(data: data, encoding: NSUTF8StringEncoding)!
        let myString:String = s as String
        var myArray = myString.componentsSeparatedByString("\n")
        
        for aclass in myArray {
            classlist.append(aclass)
        }
        classlist.removeLast()
        return classlist
    }
}