//
//  VisitorView.swift
//  weibo_swift
//
//  Created by huig on 2017/10/30.
//  Copyright © 2017年 huig. All rights reserved.
//

import UIKit

class VisitorView: UIView {

    //1 声明变量
    
    // 注册按钮
    lazy var registerBtn: UIButton = {
        weak var weakSelf = self
        let b = weakSelf?.addBtn("common_button_white_disable", title: "注册")
        b?.frame = CGRect(x: (width - 220) * 0.5, y: (weakSelf?.textLabel.frame.origin.y)! + (weakSelf?.textLabel.frame.height)! + 20, width: 100, height: 30)
        return b!
    }()
    
    // 登录按钮
    lazy var loginBtn: UIButton = {
        weak var weakSelf = self
        let b = weakSelf?.addBtn("common_button_white_disable", title: "登录")
        b?.frame = CGRect(x: width - ((width - 220) * 0.5) - 100, y: (weakSelf?.textLabel.frame.origin.y)! + (weakSelf?.textLabel.frame.height)! + 20, width: 100, height: 30)
        return b!
    }()
    
    // 转盘
    private lazy var rotationImageView: UIImageView = {
        let WH: CGFloat = 175
        //2 初始化视图
        let v = UIImageView(frame: CGRect(x: (width - WH) * 0.5, y: (height - WH - 100) * 0.5, width: WH, height: WH))
        v.image = UIImage(named: "visitordiscover_feed_image_smallicon")
        return v
    }()
    
    // icon底部阴影
    private lazy var backView: UIImageView = {
        let v = UIImageView(frame: CGRect(x: 0, y: (height - 175 - 100) * 0.5, width: width, height: 175))
        v.image = UIImage(named: "visitordiscover_feed_mask_smallicon")
        return v
    }()
    
    // iconimage
    private lazy var iconImage: UIImageView = {
        let W: CGFloat = 94
        let H: CGFloat = 90
        let v = UIImageView(frame: CGRect(x: (width - W) * 0.5, y: (height - H - 80) * 0.5, width: W, height: H))
        v.image = UIImage(named: "visitordiscover_feed_image_house")
        return v
    }()
    
    // label
    private lazy var textLabel: UILabel = {
        weak var weakSelf = self
        let label = UILabel(frame: CGRect(x: (width - 300) * 0.5, y: (weakSelf?.backView.frame.origin.y)! + (weakSelf?.backView.frame.height)! + 20, width: 300, height: 60))
        label.font = UIFont.systemFont(ofSize: 14)
        label.numberOfLines = 0
        label.textAlignment = NSTextAlignment.center
        label.textColor = UIColor.darkGray
        return label
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    
        backgroundColor = UIColor(white: 237.0/255.0, alpha: 1.0)
        // 添加控件到uiview
        addSubview(rotationImageView)
        addSubview(iconImage)
        addSubview(backView)
        addSubview(textLabel)
        addSubview(registerBtn)
        addSubview(loginBtn)
        
    }
    
    
    // 设置页面icon和title
    func setupVisitorInfo(_ imageName: String? , title: String)
    {
        
        textLabel.text = title
        // 2.判断是否是首页
        guard let name = imageName else
        {
            // 没有设置图标, 首页
            // 执行转盘动画
            startAniamtion()
            return
        }
        
        // 不是主页隐藏转盘
        rotationImageView.isHidden = true
        iconImage.image = UIImage(named: name)
        
    }
    
    // 快速创建btn
    private func addBtn(_ BackgroundImage: String, title: String) -> UIButton {
        let btn = UIButton()
        btn.setTitle(title, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        btn.setTitleColor(UIColor.orange, for: .normal)
        btn.setBackgroundImage(UIImage(named:BackgroundImage), for: .normal)
        return btn
    }
    
    /// 转盘旋转动画
    private func startAniamtion()
    {
        // 1.创建动画
        let anim =  CABasicAnimation(keyPath: "transform.rotation")
        
        // 2.设置动画属性
        anim.toValue = 2 * Double.pi
        anim.duration = 5.0
        anim.repeatCount = MAXFLOAT
        
        // 注意: 默认情况下只要视图消失, 系统就会自动移除动画
        // 只要设置removedOnCompletion为false, 系统就不会移除动画
        anim.isRemovedOnCompletion = false
        
        // 3.将动画添加到图层上
        rotationImageView.layer.add(anim, forKey: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit{
        
        HHLog("销毁")
        
    }
}
