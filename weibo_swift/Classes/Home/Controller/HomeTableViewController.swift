//
//  HomeTableViewController.swift
//  weibo_swift
//
//  Created by huig on 2017/10/30.
//  Copyright © 2017年 huig. All rights reserved.
//

import UIKit
import SDWebImage
import SVProgressHUD

class HomeTableViewController: BaseTableViewController {

    // 保存所有微博数据
    /// 保存所有微博数据
    var statusListModel: StatusListModel = StatusListModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
 
        // 1.判断用户是否登录
        if !isLogin
        {
            // 设置访客视图
            visitorView.setupVisitorInfo(nil, title: "关注一些人，回这里看看有什么惊喜")
            
            return
        }
        
        
        setupNav()
        
        // 3.注册通知
        NotificationCenter.default.addObserver(self, selector: #selector(HomeTableViewController.titleChange), name: NSNotification.Name(rawValue: XMGPresentationManagerDidPresented), object: animatorManager)
        NotificationCenter.default.addObserver(self, selector:  #selector(HomeTableViewController.titleChange), name: NSNotification.Name(rawValue: XMGPresentationManagerDidDismissed), object: animatorManager)
        NotificationCenter.default.addObserver(self, selector:  #selector(HomeTableViewController.showBrowser(_:)), name: NSNotification.Name(rawValue: XMGShowPhotoBrowserController), object: nil)
        
        // 4.获取微博数据
        loadData()
        
        // 5.设置tableView
        tableView.estimatedRowHeight = 400
        
        // 分割线
        tableView.separatorStyle = .none
        
        refreshControl = XMGRefreshControl()
        /*
         1.UIRefreshControl只要拉到一定程度无论是否松手会都触发下拉事件
         2.触发下拉时间之后, 菊花不会自动隐藏
         3.想让菊花消失必须手动调用endRefreshing()
         4.只要调用beginRefreshing, 那么菊花就会自动显示
         5.如果是通过beginRefreshing显示菊花, 不会触发下拉事件
         */
        refreshControl?.addTarget(self, action: #selector(HomeTableViewController.loadData), for: .valueChanged)
        refreshControl?.beginRefreshing()
        
//        navigationController?.navigationBar.insertSubview(tipLabel, at: 0)
        view.addSubview(tipLabel)
        
    }
    
    // MARK: - 内部控制方法
    @objc fileprivate func loadData()
    {

        statusListModel.loadData(lastStatus) { (models, error) -> () in
            // 1.安全校验
            if error != nil
            {
                SVProgressHUD.showError(withStatus: "获取微博数据失败")
                return
            }
            
            // 2.关闭菊花
            self.refreshControl?.endRefreshing()
            
            // 3.显示刷新提醒
            self.showRefreshStatus(models!.count)
            
            // 4.刷新表格
            self.tableView.reloadData()
        }
        
    }
    
    /// 显示刷新提醒
    fileprivate func showRefreshStatus(_ count: Int)
    {
        // 1.设置提醒文本
        tipLabel.text = (count == 0) ? "没有更多数据" : "刷新到\(count)条数据"
        tipLabel.isHidden = false
        // 2.执行动画
        UIView.animate(withDuration: 1.0, animations: { () -> Void in
            self.tipLabel.transform = CGAffineTransform(translationX: 0, y: 44)
        }, completion: { (_) -> Void in
            UIView.animate(withDuration: 1.0, delay: 2.0, options: UIViewAnimationOptions(rawValue: 0), animations: { () -> Void in
                self.tipLabel.transform = CGAffineTransform.identity
            }, completion: { (_) -> Void in
                self.tipLabel.isHidden = true
            })
        })
    }
    
    private func setupNav() {
        
        // 导航条按钮
        navigationItem.leftBarButtonItem = UIBarButtonItem(imageName: "navigationbar_friendattention", target: self, action: #selector(HomeTableViewController.leftBtnClick))
        navigationItem.rightBarButtonItem = UIBarButtonItem(imageName: "navigationbar_pop", target: self, action: #selector(HomeTableViewController.rightBtnClick))
        
        // 2.添加标题按钮
        navigationItem.titleView = titleButton
    }
    
    /// 监听图片点击通知
    @objc fileprivate func showBrowser(_ notice: Notification)
    {
        // 注意: 但凡是通过网络或者通知获取到的数据, 都需要进行安全校验
        guard let pictures = notice.userInfo!["bmiddle_pic"] as? [URL] else
        {
            SVProgressHUD.showError(withStatus: "没有图片", maskType: SVProgressHUDMaskType.black)
            return
        }
        
        guard let index = notice.userInfo!["indexPath"] as? IndexPath else
        {
            SVProgressHUD.showError(withStatus: "没有索引", maskType: SVProgressHUDMaskType.black)
            return
        }
        
        // 弹出图片浏览器, 将所有图片和当前点击的索引传递给浏览器
        let vc = BrowserViewController(bmiddle_pic: pictures, indexPath: index)
        present(vc, animated: true, completion: nil)
    }
    
    @objc fileprivate func titleChange()
    {
        titleButton.isSelected = !titleButton.isSelected
    }
    
    @objc private func titleBtnClick(btn: TitleButton)
    {
 
        let menuView = PopoverViewController()

        // 2.显示菜单
        // 2.1创建菜单
        // 自定义专场动画
        // 设置转场代理
        menuView.transitioningDelegate = animatorManager
        // 设置转场动画样式
        menuView.modalPresentationStyle = UIModalPresentationStyle.custom
        
        // 2.2弹出菜单
        present(menuView, animated: true, completion: nil)
    }
    
    // MARK: - 内部控制方法
    @objc private func leftBtnClick()
    {
        HHLog("")
    }
    @objc private func rightBtnClick()
    {
        let vc = QRCodeViewController()
        let nav = UINavigationController(rootViewController: vc)

        present(nav, animated: true, completion: nil)
    }

    var presentFrame = CGRect(x: (width - 200) * 0.5, y: 50, width: 200, height: 500)
    
    // MARK: - 懒加载
    fileprivate lazy var animatorManager: XMGPresentationManager = {
        let manager = XMGPresentationManager()
        manager.presentFrame.origin = self.presentFrame.origin
        return manager
    }()
    
    /// 标题按钮
    @objc fileprivate lazy var titleButton: TitleButton = {
        let btn = TitleButton()
        let title = UserAccount.loadUserAccount()?.screen_name
        btn.setTitle(title, for: UIControlState())
        btn.addTarget(self, action: #selector(HomeTableViewController.titleBtnClick(btn:)), for: UIControlEvents.touchUpInside)
        return btn
    }()
    
    // 缓存行高
    fileprivate var rowHeightCaches = [String: CGFloat]()
    
    /// 刷新提醒视图
    fileprivate var tipLabel: UILabel = {
        let lb = UILabel()
        lb.text = "没有更多数据"
        lb.textColor = UIColor.black
        lb.backgroundColor = UIColor.white
        lb.textAlignment = NSTextAlignment.center
        let width = UIScreen.main.bounds.width
        lb.frame = CGRect(x: 0, y: -44, width: width, height: 44)
        lb.isHidden = true
        return lb
    }()
    
    /// 最后一条微博标记
    fileprivate var lastStatus = false
    
    deinit{
        
        HHLog("销毁")
        // 移除通知
        NotificationCenter.default.removeObserver(self)
        
    }

}

extension HomeTableViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return statusListModel.statuses?.count ?? 0
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let viewModel = statusListModel.statuses![indexPath.row]
        
        let identifier = (viewModel.status.retweeted_status != nil) ? "forwardCell" : "homeCell"
        
        let cell = HomeTableViewCell.init(style: .default, reuseIdentifier: identifier)
        
        cell.viewModel = viewModel
        
        // 3.判断是否是最后一条微博
        if indexPath.row == (statusListModel.statuses!.count - 1)
        {
            
            HHLog("最后一条微博 \(String(describing: viewModel.status.user?.screen_name))")
            lastStatus = true
            loadData()
        }
        
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let viewModel = statusListModel.statuses![indexPath.row]
        
        guard let height = rowHeightCaches[viewModel.status.idstr ?? "-1"] else {
            
            HHLog("缓存行高")
            let cell = HomeTableViewCell.init(style: .default, reuseIdentifier: "homeCell")
            
            let temp = cell.calculateRowHeight(viewModel: viewModel)
            
            rowHeightCaches[viewModel.status.idstr ?? "-1"] = temp
            
            return temp
        }
        
        return height
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // 释放缓存数据
        rowHeightCaches.removeAll()
    }
}
