//
//  ProfileTableViewController.swift
//  weibo_swift
//
//  Created by huig on 2017/10/30.
//  Copyright © 2017年 huig. All rights reserved.
//

import UIKit

class ProfileTableViewController: BaseTableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        HHLog("")
        if !isLogin
        {
            visitorView.setupVisitorInfo("visitordiscover_image_profile", title: "登录后，你的微博、相册、个人资料会显示在这里，展示给别人")
            return
        }
    }
    
    deinit{
        
        HHLog("销毁")
        
    }
}
