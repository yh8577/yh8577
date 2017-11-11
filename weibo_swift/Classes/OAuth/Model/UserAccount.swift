//
//  UserAccount.swift
//  swift微博
//
//  Created by huig on 17/10/3.
//  Copyright © 2017年 huige. All rights reserved.
//

import UIKit

class UserAccount: NSObject, NSCoding {
    
    /// 用于调用access_token，接口获取授权后的access token。
    var access_token: String?
    /// access_token的生命周期，单位是秒数。
    var expires_in: NSNumber?
        {
        didSet{
            expires_Date = NSDate(timeIntervalSinceNow: expires_in as! TimeInterval)
        }
    }
    
    /// 过期时间(年月日时分秒)
    var expires_Date: NSDate?
    
    /// 当前授权用户的UID。
    var uid: String?
    
    /// 用户昵称
    var screen_name: String?
    
    /// 用户头像地址（大图），180×180像素
    var avatar_large: String?
    
    init(dict: [String: AnyObject])
    {
        super.init()
        setValuesForKeys(dict)
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) { }
    
    override var description: String {
        let property = ["access_token", "expires_in", "uid", "expires_Date", "screen_name", "avatar_large"]
        let dict = dictionaryWithValues(forKeys: property)
        return "\(dict)"
    }
    
    // MARK: - 外部控制方法
    static let filePath = "userAccount.plist".cacheDir()
    
    // 保存授权信息方法
    func saveAccount() -> Bool {
        
        return NSKeyedArchiver.archiveRootObject(self, toFile: UserAccount.filePath)
    }
    
    // 保存用户信息
    static var account: UserAccount?
    
    class func loadUserAccount() -> UserAccount? {
        HHLog(filePath)
        // 已经加载过
        if account != nil {
            return account
        }
        
        // 米有授权过
        guard let userAccount = NSKeyedUnarchiver.unarchiveObject(withFile: filePath) as? UserAccount else {
            return nil
        }
        
        // 判断时间是否过期,获取当前时间和过期时间比较是否过期
        guard let date = userAccount.expires_Date, date.compare(Date()) != ComparisonResult.orderedAscending else {
            return nil
        }
        
        // 赋值模型信息
        account = userAccount
        
        return account
    }
    
    
    // 给用户信息赋值
    func loadUserInfo(finished: @escaping (_ account: UserAccount?)->()) {
        
        assert(access_token != nil, "使用该方法必须先授权登录")
        let parameters = ["access_token": access_token!, "uid": uid!]

        NetworkTools.loadUserInfo(parameters: parameters) { (request) in
            
            let dict = request as! [String : AnyObject]
            self.avatar_large = dict["avatar_large"] as? String
            self.screen_name = dict["screen_name"] as? String
            
            finished(self)
        }
    }
    // 判断是否登录
    class func isLogin() -> Bool {
        
        return loadUserAccount() != nil
    }
    
    // MARK: - NSCoding
    
    func encode(with aCoder: NSCoder) {
        
        aCoder.encode(access_token, forKey:"access_token")
        aCoder.encode(expires_in, forKey: "expires_in")
        aCoder.encode(uid, forKey: "uid")
        aCoder.encode(expires_Date, forKey: "expires_Date")
        aCoder.encode(screen_name, forKey: "screen_name")
        aCoder.encode(avatar_large, forKey: "avatar_large")
        
    }
    //解档
    required init?(coder aDecoder: NSCoder) {
        
        access_token = aDecoder.decodeObject(forKey: "access_token") as? String
        expires_in = aDecoder.decodeObject(forKey: "expires_in") as? NSNumber
        uid = aDecoder.decodeObject(forKey: "uid") as? String
        expires_Date = aDecoder.decodeObject(forKey: "expires_Date") as? NSDate
        avatar_large = aDecoder.decodeObject(forKey: "avatar_large") as? String
        screen_name = aDecoder.decodeObject(forKey: "screen_name") as? String
        
        
    }
}


