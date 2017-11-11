//
//  TestLabel+Extension.swift
//  swift微博
//
//  Created by huig on 17/10/7.
//  Copyright © 2017年 huige. All rights reserved.
//

import UIKit

extension UILabel {
    
    convenience init(_ numLines: Int?, fontSize: CGFloat?,color: UIColor? , fontSizeToFitWidth: Bool?) {
        
        self.init()
        
        if textColor != nil {
            textColor = color
        }
        if numLines != nil {
            
            numberOfLines = numLines!
        }
        if fontSizeToFitWidth != nil {
            
            adjustsFontSizeToFitWidth = fontSizeToFitWidth!
        }
        if fontSize != nil {
            font = UIFont.systemFont(ofSize: fontSize!)
        }
     
        sizeToFit()
    }
}

