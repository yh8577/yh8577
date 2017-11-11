//
//  DiscoverTableViewController.swift
//  weibo_swift
//
//  Created by huig on 2017/10/30.
//  Copyright © 2017年 huig. All rights reserved.
//

import UIKit

class DiscoverTableViewController: BaseTableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        HHLog("")
        if !isLogin
        {
            visitorView.setupVisitorInfo("visitordiscover_image_message", title: "登录后，最新、最热微博尽在掌握，不再会与实事潮流擦肩而过")
            return
        }
    }

    deinit{
        
        HHLog("销毁")
        
    }
}
