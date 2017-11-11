//
//  User.swift
//  swift微博
//
//  Created by huig on 17/10/6.
//  Copyright © 2017年 huige. All rights reserved.
//

import UIKit

class User: NSObject {

    var idstr: String?                  // 字符串型的用户UID
    var profile_image_url:  String?     // 用户头像地址（中图），50×50像素
    var screen_name: String?            // 用户昵称
    var verified_type: Int = 0          // 用户类型
    var mbrank: Int = -1                // 会员等级,范围1~6
    
    init(dict: [String: AnyObject])
    {
        super.init()
        setValuesForKeys(dict)
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) { }
    
    override var description: String {
        let property = ["idstr", "profile_image_url", "screen_name", "verified_type", "mbrank"]
        let dict = dictionaryWithValues(forKeys: property)
        return "\(dict)"
    }
    
}
