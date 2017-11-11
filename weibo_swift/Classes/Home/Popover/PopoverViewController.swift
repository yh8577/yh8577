//
//  PopoverViewController.swift
//  weibo_swift
//
//  Created by yihui on 2017/10/31.
//  Copyright © 2017年 huig. All rights reserved.
//

import UIKit

class PopoverViewController: UIViewController {

    let presentFrame = HomeTableViewController().presentFrame
    private lazy var popoverView: UIImageView = {
        let v = UIImageView(image: UIImage(named:"popover_background"))
        v.frame.size = self.presentFrame.size
        return v
    }()
    
    let tabview = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(popoverView)

        tabview.frame = CGRect(x: (presentFrame.width - (presentFrame.width - 20)) * 0.5, y: (presentFrame.height - (presentFrame.height - 20)) * 0.5 + 5, width: presentFrame.width - 20, height: presentFrame.height - 25)
        
        view.addSubview(tabview)

    }

    

}
