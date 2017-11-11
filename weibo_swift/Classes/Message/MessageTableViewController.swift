//
//  MessageTableViewController.swift
//  weibo_swift
//
//  Created by huig on 2017/10/30.
//  Copyright © 2017年 huig. All rights reserved.
//

import UIKit

class MessageTableViewController: BaseTableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        HHLog("")
        if !isLogin
        {
            visitorView.setupVisitorInfo("visitordiscover_image_message", title: "登录后，别人评论你的微博，发给你的消息，都会在这里收到通知")
            return
        }
    }
    deinit{
        
        HHLog("销毁")
        
    }
    
}
