//
//  AppDelegate.swift
//  weibo_swift
//
//  Created by huig on 2017/10/30.
//  Copyright © 2017年 huig. All rights reserved.
//

import UIKit



@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
      
        UINavigationBar.appearance().tintColor = UIColor.orange
//        TabBarView.appearance().tintColor = UIColor.orange
        
        NotificationCenter.default.addObserver(self, selector: #selector(AppDelegate.changeRootViewController(_:)), name: NSNotification.Name(RootViewControllerChnage), object: nil)
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.backgroundColor = UIColor.white
        window?.rootViewController = defaultViewController()
        window?.makeKeyAndVisible()
        
        HHLog(isNewVersion())
        
        
        return true
    }
    deinit {
        //记得移除通知监听
        NotificationCenter.default.removeObserver(self)
    }

}


extension AppDelegate {
    
    /// 切换根控制器
    func changeRootViewController(_ notice: NSNotification)
    {

        if notice.object as! Bool
        {
            window?.rootViewController = MainViewController()
        }else
        {
            window?.rootViewController = WelcomeViewController()
        }
    }
    
    /// 用于返回默认界面
    fileprivate func defaultViewController() -> UIViewController
    {
        // 1.判断是否登录
        if UserAccount.isLogin()
        {
            // 2.判断是否有新版本
            //            isNewVersion() ? UIStoryboard(name: "NewfeatureViewController", bundle: nil).instantiateInitialViewController()! : UIStoryboard(name: "WelcomeViewController", bundle: nil).instantiateInitialViewController()!
            if isNewVersion() {
                return NewfeatureViewController()
            } else {
                return WelcomeViewController()
            }
        }
        
        // 没有登录
        return MainViewController()
    }
    
    // 判断当前是否新版本
    fileprivate func isNewVersion() -> Bool {
        let currentVersion = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String
        
        let defaults = UserDefaults.standard
        let sanboxVersion = defaults.object(forKey: "CFBundleShortVersionString") as? String ?? "0.0"
        
        if currentVersion.compare(sanboxVersion) == ComparisonResult.orderedDescending {
            HHLog("有新版本")
            
            defaults.set(currentVersion, forKey: "CFBundleShortVersionString")
            
            return true
        }
        HHLog("没有新版本")
        return false
    }
}

// 自定义log
func HHLog<T>(_ message: T, fileName: String = #file, methodName: String =  #function, lineNumber: Int = #line)
{
    #if DEBUG        
        let str : String = (fileName as NSString).pathComponents.last!.replacingOccurrences(of: "swift", with: "")
        print("\(str)\(methodName)[\(lineNumber)]:\(message)")
    #endif
}


