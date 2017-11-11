//
//  StatusViewModel.swift
//  swift微博
//
//  Created by huig on 17/10/7.
//  Copyright © 2017年 huige. All rights reserved.
//

import UIKit

class StatusViewModel: NSObject {

    var status: Status
    
    init(status: Status) {
        self.status = status
        // 头像
        icon_URL = URL(string: status.user?.profile_image_url ?? "" )
        // 认证图标  
        switch status.user?.verified_type ?? -1
        {
        case 0:
            verified_image = UIImage(named:"avatar_vip")
        case 2, 3, 5:
            verified_image = UIImage(named:"avatar_enterprise_vip")
        case 220:
            verified_image = UIImage(named:"avatar_grassroot")
        default:
            verified_image = nil
        }
        // vip图标
        if (status.user?.mbrank)! >= 1 && (status.user?.mbrank)! <= 6
        {
            mbrankImage = UIImage(named: "common_icon_membership_level\(status.user!.mbrank)")

        }
        
        // 来源
        if let sourceStr = status.source as NSString?, sourceStr != ""
        {
            // 6.1获取从什么地方开始截取
            let startIndex = sourceStr.range(of: ">").location + 1
            // 6.2获取截取多长的长度
            let length = sourceStr.range(of: "<", options:.backwards).location - startIndex
            
            // 6.3截取字符串
            let rest = sourceStr.substring(with: NSMakeRange(startIndex, length))
            
            source_Text = "来自: " + rest
        }
        
        // 时间
        if let timeStr = status.created_at, timeStr != ""
        {
            // 1.将服务器返回的时间格式化为NSDate
            let createDate = NSDate.createDate(timeStr, formatterStr: "EE MM dd HH:mm:ss Z yyyy")
            
            // 2.生成发布微博时间对应的字符串
            created_Time = createDate.descriptionStr()
        }
        
        // 配图url
        if let picurls = (status.retweeted_status != nil) ? status.retweeted_status?.pic_urls : status.pic_urls {
            
            thumbnail_pic = [URL]()
            bmiddle_pic = [URL]()
            for dict in picurls {
                
                guard var urlStr = dict["thumbnail_pic"] as? String else {
                    continue
                }
                
                let url = URL(string: urlStr)!
                thumbnail_pic?.append(url)
                
                // 2.3处理大图
                urlStr = urlStr.replacingOccurrences(of: "thumbnail", with: "bmiddle")
                bmiddle_pic?.append(URL(string: urlStr)!)
            }
        }
        
        // 处理转发
        if let text = status.retweeted_status?.text
        {
            let name = status.retweeted_status?.user?.screen_name ?? ""
            forwardText = "@" + name + ": " + text
        }
        
    }
    
    
    /// 用户认证图片
    var verified_image: UIImage?
    
    /// 会员图片
    var mbrankImage: UIImage?
    
    /// 用户头像URL地址
    var icon_URL: URL?
    
    /// 微博格式化之后的创建时间
    var created_Time: String = ""
    
    /// 微博格式化之后的来源
    var source_Text: String = ""
    
    /// 配图
    var thumbnail_pic: [URL]?
    
    /// 保存所有配图大图URL
    var bmiddle_pic: [URL]?
    
    /// 转发微博格式化之后正文
    var forwardText: String?
}
