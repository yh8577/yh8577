//
//  OAuthViewController.swift
//  swift微博
//
//  Created by huig on 17/10/2.
//  Copyright © 2017年 huige. All rights reserved.
//

import UIKit
import SVProgressHUD

class OAuthViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        setupNav()
        
        setupWeb()
    
    }
    
    private func setupNav() {
        navigationItem.title = "登录授权"
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.orange]

        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "填充", style: .plain, target: self, action: #selector(OAuthViewController.rightBtnClick))
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "关闭", style: .plain, target: self, action: #selector(OAuthViewController.closeBtnClick))
    }
    
    @objc private func rightBtnClick() {
        let js = "document.getElementById('userId').value = '15555636663';"  +
        "document.getElementById('passwd').value = 'yh580131';"
        customWebView.stringByEvaluatingJavaScript(from: js)
    }
    
    @objc fileprivate func closeBtnClick() {
        dismiss(animated: true, completion: nil)
    }
    
    private lazy var customWebView: UIWebView = {
        let web = UIWebView()
        web.frame = UIScreen.main.bounds
        return web
    }()
    
    private func setupWeb() {
        
        view.addSubview(customWebView)
        let urlStr = "https://api.weibo.com/oauth2/authorize?client_id=\(WB_App_Key)&redirect_uri=\(WB_Redirect_URI)"

        
        guard let url = URL(string: urlStr) else {
            return
        }
        
        let request = URLRequest(url: url)
        
        //storyboard里面已经设置代理这里就不需要设置,反之.
        customWebView.delegate = self

        customWebView.loadRequest(request)
    }

}

extension OAuthViewController: UIWebViewDelegate
{

    // 加载的时候调用这里
    func webViewDidStartLoad(_ webView: UIWebView) {
        SVProgressHUD.showInfo(withStatus: "正在加载中......")
    }
    
    // 加载完成调用这里
    func webViewDidFinishLoad(_ webView: UIWebView) {
        SVProgressHUD.dismiss()
    }
    
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {

        // 1.判断当前是否是授权回调页面
        guard let urlStr = request.url?.absoluteString else
        {
            return false
        }
        if !urlStr.hasPrefix("http://www.baidu.com/")
        {
            HHLog("不是授权回调页面")
            return true
        }
        
        HHLog("是授权回调页面")
        // 2.判断授权回调地址中是否包含code=
        // URL的query属性是专门用于获取URL中的参数的, 可以获取URL中?后面的所有内容
        let key = "code="
        
        if urlStr.contains(key)
        {
            let code = request.url?.query?.substring(from: key.endIndex)
            loadAccessToken(codeStr: code)
            return false
        }
        HHLog("授权失败")
        return false
    }
    
    private func loadAccessToken(codeStr: String?) {
        
        guard let code = codeStr else {
            return
        }
        
        
        
        NetworkTools.loadOAuth(code: code) { (result) in
            
            let account = UserAccount(dict: result as! [String : AnyObject])
            // 保存用户信息
            account.loadUserInfo(finished: { (account) in
                
                let _ = account?.saveAccount()
                
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: RootViewControllerChnage), object: false)
                // 关闭界面
                self.closeBtnClick()
            })
        }
    }
    
}

















