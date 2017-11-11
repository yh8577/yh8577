//
//  Statuses.swift
//  swift微博
//
//  Created by huig on 17/10/6.
//  Copyright © 2017年 huige. All rights reserved.
//

import UIKit

class Status: NSObject {

    var created_at: String? //  微博创建时间
    var idstr: String?      //  字符串型的微博ID
    var text: String?       //  微博信息内容
    var source: String?     //  微博来源
    var user: User?         // 微博作者的用户信息字段 详细
    var pic_urls: [[String: AnyObject]]?    // 配图
    var retweeted_status: Status?           /// 转发微博
    
    init(dict: [String: AnyObject])
    {
        super.init()
        setValuesForKeys(dict)
    }
    
    override func setValue(_ value: Any?, forKey key: String) {
        // 拦截user字典转换为模型赋值给user模型
        if key == "user" {
            user = User(dict: value as! [String : AnyObject])
            return
        }
        if key == "retweeted_status"
        {
            retweeted_status = Status(dict: value as! [String : AnyObject])
            return
        }
        super.setValue(value, forKey: key)
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) { }
    
    override var description: String {
        let property = ["created_at", "idstr", "text", "source"]
        let dict = dictionaryWithValues(forKeys: property)
        return "\(dict)"
    }

}
