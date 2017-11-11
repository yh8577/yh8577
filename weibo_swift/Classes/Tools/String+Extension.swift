//
//  String+Extension.swift
//  XMGWB
//
//  Created by xiaomage on 15/11/10.
//  Copyright © 2015年 xiaomage. All rights reserved.
//

import UIKit

extension String
{
    /// 快速返回一个文档目录路径
    func docDir() -> String
    {
        let docPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last!
        return (docPath as NSString).appendingPathComponent((self as NSString).pathComponents.last!)
    }
    
    /// 快速返回一个缓存目录的路径
    func cacheDir() -> String
    {
        let cachePath = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).last!
        return (cachePath as NSString).appendingPathComponent((self as NSString).pathComponents.last!)

    }
    
    /// 快速返回一个临时目录的路径
    func tmpDir() -> String
    {
        let tmpPath = NSTemporaryDirectory()
        return (tmpPath as NSString).appendingPathComponent((self as NSString).pathComponents.last!)

    }
}

