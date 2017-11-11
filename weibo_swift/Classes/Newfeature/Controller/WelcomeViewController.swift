//
//  WelcomeViewController.swift
//  swift微博
//
//  Created by huig on 17/10/4.
//  Copyright © 2017年 huige. All rights reserved.
//

import UIKit

class WelcomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupIconAndTitle()
        
    }
    
    private func setupIconAndTitle() {
        
        view.addSubview(backImageView)
        view.addSubview(iconImageView)
        titleLabel.frame.origin.y =  iconImageView.frame.origin.y + iconImageView.frame.height + 30
        view.addSubview(titleLabel)
        
        assert(UserAccount.loadUserAccount() != nil ,"必须登录以后才能显示头像")
        // 获取头像url
        guard let url = URL(string: UserAccount.loadUserAccount()!.avatar_large!) else {
            return
        }
        // 设置头像
        iconImageView.sd_setImage(with: url, completed: nil)
        // 设置title
        titleLabel.text = UserAccount.loadUserAccount()!.screen_name! + "欢迎回来"
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // 头像上移动画
        UIView.animate(withDuration: 2.0, animations: {
            self.iconImageView.frame.origin.y = height - self.iconImageView.frame.origin.y - self.iconImageView.frame.height * 2
            self.titleLabel.frame.origin.y = self.iconImageView.frame.origin.y + self.iconImageView.frame.height + 30
            
        }, completion: { (_) in
            
            self.view.layoutIfNeeded()
            // title淡出动画
            UIView.animate(withDuration: 2.0, animations: {
                self.titleLabel.alpha = 1.0
            }, completion: { (_) in
                
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: RootViewControllerChnage), object: true)
                
            })
        })
    }
    
    // 头像
    private lazy var iconImageView: UIImageView = {
        var icon = UIImageView()
        icon.frame = CGRect(x: (width - 90) * 0.5, y: height - 290, width: 90, height: 90)
        // 修改头像为圆角
        icon.layer.cornerRadius = icon.frame.width * 0.5
        icon.image = UIImage(named: "avatar_default_big")
        icon.clipsToBounds = true
        return icon
    }()
    
    // 背景图片
    private lazy var backImageView: UIImageView = {
        let back = UIImageView(frame: UIScreen.main.bounds)
        back.image = UIImage(named: "ad_background")
        return back
    }()
    
    // iconTitle
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.frame =  CGRect(x: 30 , y: 0, width: (width - 60), height: 30)
        label.textAlignment = NSTextAlignment.center
        label.textColor = UIColor.gray
        label.alpha = 0.0
        label.text = "欢迎回来"
        return label
    }()

}
