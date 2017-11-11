//
//  BaseTableViewController.swift
//  weibo_swift
//
//  Created by huig on 2017/10/30.
//  Copyright © 2017年 huig. All rights reserved.
//

import UIKit

class BaseTableViewController: UITableViewController {

    var visitorView = VisitorView()
    /// 定义标记记录用户登录状态
    var isLogin = UserAccount.isLogin()

    override func loadView() {
        
        isLogin ? super.loadView() : setupVisitorView()
    }

    private func setupVisitorView() {
        
        view = visitorView
    
        btnAddTarget()
        
        tabbarBtn()

    }
    
    // 按钮点击事件
    private func btnAddTarget() {
        
        visitorView.loginBtn.addTarget(self, action: #selector(BaseTableViewController.loginBtnClick(btn:)), for: .touchUpInside)
        visitorView.registerBtn.addTarget(self, action: #selector(BaseTableViewController.registerBtnClick(btn:)), for: .touchUpInside)
    }
    
    // 3.添加导航条按钮
    private func tabbarBtn(){
    
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "注册", style: .plain, target: self, action: #selector(BaseTableViewController.registerBtnClick(btn:)))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "登录", style: .plain, target: self, action: #selector(BaseTableViewController.loginBtnClick(btn:)))
    }
    
    
    @objc private func loginBtnClick(btn: UIButton)
    {
        let vc = OAuthViewController()
        let nav = UINavigationController(rootViewController: vc)
        
        present(nav, animated: true, completion: nil)
        HHLog("")
    }
    @objc private func registerBtnClick(btn: UIButton)
    {
        HHLog("")
    }
}
