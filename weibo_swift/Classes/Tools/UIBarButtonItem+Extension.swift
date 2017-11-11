//
//  UIBarButtonItem+Extension.swift
//  XMGWB
//
//  Created by xiaomage on 15/12/2.
//  Copyright © 2015年 xiaomage. All rights reserved.
//

import UIKit

extension UIBarButtonItem
{
    // 1.用于快速创建一个对象
    // 2.依赖于指定构造方法
    convenience init(imageName: String, target: AnyObject?, action: Selector)
    {
        let btn = UIButton()
        btn.setImage(UIImage(named: imageName), for: .normal)
        btn.setImage(UIImage(named: imageName + "_highlighted"), for: .highlighted)
        btn.sizeToFit()
        btn.addTarget(target, action: action, for: .touchUpInside)
        
        self.init(customView: btn)
    }
}
