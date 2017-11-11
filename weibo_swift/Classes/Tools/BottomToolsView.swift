//
//  BottomToolsView.swift
//  bootom
//
//  Created by yihui on 2017/11/4.
//  Copyright © 2017年 yihui. All rights reserved.
//

import UIKit

class BottomToolsView: UIView {

    override init(frame: CGRect) {
        
        super.init(frame: frame)
        let v = UIView(frame:  CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 40))
        v.backgroundColor = UIColor(patternImage: UIImage(named:"timeline_card_bottom_background")!)
        let b1 = setBtn(1, image: "timeline_icon_retweet", title: "转发")
        let b2 = setBtn(2, image: "timeline_icon_comment", title: "2")
        let b3 = setBtn(3, image: "timeline_icon_unlike", title: "5")
        v.addSubview(b1)
        v.addSubview(b2)
        v.addSubview(b3)
        addSubview(v)
    }
    
    
    private func setBtn(_ num: CGFloat, image: String, title: String) -> UIButton {
        let h: CGFloat = 40
        let w: CGFloat = width / 3
        let b = BottomTools(CGRect(x: w * (num - 1), y: 0, width: w, height: h), title: title, image: image)
        return b
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

class BottomTools: UIButton {
    
    init(_ frame: CGRect, title: String?,image: String? ) {
        super.init(frame: frame)
        
        setTitleColor(UIColor.lightGray, for: .normal)
        titleLabel?.font = UIFont.systemFont(ofSize: 14)
        
        if title != nil {
            setTitle(title!, for: .normal)
            setTitle(title!, for: .highlighted)
        }
        if image != nil {
            setImage(UIImage(named: image!), for: .normal)
            setImage(UIImage(named: image!), for: .highlighted)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        titleLabel?.frame.origin.x = (titleLabel?.frame.origin.x)! + 3
        
    }
    
}
