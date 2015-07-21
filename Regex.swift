//
//  Regex.swift
//  RUC_Assist
//  正则工具
//  作者: DaoD 时间: 5/12/15.
//  版权所有: 2015 DaoD.
//

import Foundation

class Regex {
    
    let internalExpression: NSRegularExpression
    let pattern: String
    var result:[String] = []
    
    init(_ pattern: String) {
        self.pattern = pattern
        var error: NSError?
        self.internalExpression = NSRegularExpression(pattern: pattern, options: .CaseInsensitive, error: &error)!
    }
    
    func test(input: String) -> Array<String> {
        let matches = self.internalExpression.matchesInString(input, options: nil, range:NSMakeRange(0, count(input)))
        for match in matches as! [NSTextCheckingResult] {
            let matchRange = match.range
            result.append((input as NSString).substringWithRange(matchRange))
        }
        return result
    }
}