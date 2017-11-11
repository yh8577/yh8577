//
//  NetworkTools.swift
//  swift微博
//
//  Created by huig on 17/10/3.
//  Copyright © 2017年 huige. All rights reserved.
//

import UIKit
import Alamofire

/*
 
 NetworkTools.requestData(.get, URLString: "http://httpbin.org/get") { (result) in
 print(result)
 }
 
 NetworkTools.requestData(.post, URLString: "http://httpbin.org/post", parameters: ["name": "JackieQu"]) { (result) in
 print(result)
 }
 
 */

enum MethodType {
    case get
    case post
}

class NetworkTools {

    // 通用连接
    class func requestData(_ type : MethodType, URLString : String, parameters : [String : Any]? = nil, finishedCallback :  @escaping (_ result : Any) -> ()) {
        
        // 1.获取类型
        let method = type == .get ? HTTPMethod.get : HTTPMethod.post
        
        // 2.发送网络请求
        Alamofire.request(baseURL + URLString, method: method, parameters: parameters).responseJSON { (response) in
            
            // 3.获取结果
            guard let result = response.result.value else {
                print(response.result.error!)
                return
            }
            
            // 4.将结果回调出去
            finishedCallback(result)
        }

    }
    
    // 获取授权
    class func loadOAuth(code: String,finished: @escaping (_ array: Any?)->())  {
        
        let path = "oauth2/access_token"
        let parameters = ["client_id": WB_App_Key, "client_secret": WB_App_Secret, "grant_type": "authorization_code", "code": code, "redirect_uri": WB_Redirect_URI]

        // 2.发送网络请求
        Alamofire.request(baseURL + path, method: HTTPMethod.post, parameters: parameters).responseJSON { (response) in
            
            // 3.获取结果
            guard let result = response.result.value else {
                print(response.result.error!)
                return
            }
            
            // 4.将结果回调出去
            finished(result)
        }
        
    }
    
    // 获取用户信息
    class func loadUserInfo(parameters: [String : Any]?,finished: @escaping (_ array: Any?)->())  {

        let path = "2/users/show.json"

        Alamofire.request(baseURL + path, method: HTTPMethod.get, parameters: parameters).responseJSON { (response) in
            
            // 3.获取结果
            guard let result = response.result.value else {
                print(response.result.error!)
                return
            }
            
            // 4.将结果回调出去
            finished(result)
        }
    }
    // 获取微博数据
    class func loadStatuses(_ since_id: String, max_id: String, finished: @escaping (_ array: [[String: AnyObject]]?, _ error: NSError?) -> ())  {
        
        assert(UserAccount.loadUserAccount() != nil, "必须授权之后才能获取微博数据!")
        
        let path = "2/statuses/home_timeline.json"
        
        let temp = (max_id != "0") ? "\(Int(max_id)! - 1)" : max_id
        let parameters = ["access_token": UserAccount.loadUserAccount()!.access_token!, "since_id": since_id, "max_id": temp]
        
        Alamofire.request(baseURL + path, method: HTTPMethod.get, parameters: parameters).responseJSON { (response) in
            
            // 3.获取结果
            guard let result = response.result.value else {
                print(response.result.error!)
                return
            }
            
            guard let array = (result as! [String: AnyObject])["statuses"] as? [[String: AnyObject]] else {
                finished(nil, NSError(domain: "www", code: 1000, userInfo: ["message":"没有获取到微博数据"]))
                return
            }
            
            finished(array,nil)
            
        }
    }
    
}






















