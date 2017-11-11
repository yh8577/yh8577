//
//  UIButton+Extension.swift
//  XMGWB
//
//  Created by xiaomage on 15/12/1.
//  Copyright © 2015年 xiaomage. All rights reserved.
//

import UIKit

extension UIButton
{
    
    /*
    如果构造方法前面没有convenience单词, 代表着是一个初始化构造方法(指定构造方法)
    如果构造方法前面有convenience单词, 代表着是一个便利构造方法
    指定构造方法和便利构造方法的区别
    指定构造方法中必须对所有的属性进行初始化
    便利构造方法中不用对所有的属性进行初始, "因为便利构造方法依赖于指定构造方法"
    一般情况下如果想给系统的类提供一个快速创建的方法, 就自定义一个便利构造方法
    */
    convenience init(imageName: String?, backgroundImageName: String?)
    {
        
        self.init()
        
        // 2.设置前景图片
        if let name: String = imageName {
            setImage(UIImage(named: name), for: .normal)
            setImage(UIImage(named: name + "_highlighted"), for: .highlighted)
        }
        
        // 3.设置背景图片
        if let backName = backgroundImageName {
            setBackgroundImage(UIImage(named: backName), for: .normal)
            setBackgroundImage(UIImage(named: backName + "_highlighted"), for: .highlighted)
        }
        // 4.调整按钮尺寸
        sizeToFit()
    }
    
    @objc func set(image anImage: String, title: String,
                   titlePosition: UIViewContentMode, additionalSpacing: CGFloat){
        self.imageView?.contentMode = .center
        self.setImage(UIImage(named: anImage) , for: .normal)
        self.setImage(UIImage(named: anImage + "_highlighted"), for: .selected)
        self.setImage(UIImage(named: anImage + "_highlighted"), for: .highlighted)
        
        positionLabelRespectToImage(title: title, position: titlePosition, spacing: additionalSpacing)
        
        self.setTitleColor(UIColor.white, for: .normal) //文字颜色
        self.setTitleColor(UIColor.orange, for: .highlighted) //文字颜色
        self.setTitleColor(UIColor.orange, for: .selected) //文字颜色
        self.titleLabel?.contentMode = .center
        self.setTitle(title, for: .normal)
    }
    
    private func positionLabelRespectToImage(title: String, position: UIViewContentMode,spacing: CGFloat) {
        
        let imageSize = self.imageRect(forContentRect: self.frame)
        let titleFont = self.titleLabel?.font!
        let titleSize = title.size(attributes: [NSFontAttributeName: titleFont!])
        
        var titleInsets: UIEdgeInsets
        var imageInsets: UIEdgeInsets
        
        switch (position){
        case .top:
            
            titleInsets = UIEdgeInsets(top: -(imageSize.height + titleSize.height + spacing),left: -(imageSize.width), bottom: 0, right: 0)
            imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -titleSize.width)
        case .bottom:
            
            titleInsets = UIEdgeInsets(top: (imageSize.height + titleSize.height + spacing),left: -(imageSize.width), bottom: 0, right: 0)
            imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -titleSize.width)
        case .left:
            
            titleInsets = UIEdgeInsets(top: 0, left: -(imageSize.width * 2), bottom: 0, right: 0)
            imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0,right: -(titleSize.width * 2 + spacing))
        case .right:
            
            titleInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -spacing)
            imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        default:
            
            titleInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }
        
        self.titleEdgeInsets = titleInsets
        self.imageEdgeInsets = imageInsets
    }
}
