//
//  MainViewController.swift
//  XMGWB
//
//  Created by xiaomage on 15/12/1.
//  Copyright © 2015年 xiaomage. All rights reserved.
//

import UIKit

class MainViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // iOS7以后只需要设置tintColor, 那么图片和文字都会按照tintColor渲染
        tabBar.tintColor = UIColor.orange
        
        // 添加子控制器
        addChildViewControllers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // 添加加号按钮
        tabBar.addSubview(composeButton)
        
        // 保存按钮尺寸
        let rect = composeButton.frame
        // 计算宽度
        let width = tabBar.bounds.width / CGFloat(childViewControllers.count)
        
        // 设置按钮的位置
        composeButton.frame = CGRect(x: 2 * width, y: 0, width: width, height: rect.height)
    }
    
    /// 添加所有子控制器
    func addChildViewControllers()
    {

        // 1.根据JSON文件创建控制器
        // 1.1读取JSON数据
        guard let filePath =  Bundle.main.path(forResource: "MainVCSettings.json", ofType: nil) else
        {
            HHLog("JSON文件不存在")
            return
        }
        
        guard let data = NSData(contentsOfFile: filePath) else
        {
            HHLog("加载二进制数据失败")
            return
        }

        // 1.2将JSON数据转换为对象(数组字典)
        do
        {
            let objc = try JSONSerialization.jsonObject(with: data as Data, options: .mutableContainers) as! [[String: AnyObject]]
            
            // 1.3遍历数组字典取出每一个字典
            for dict in objc
            {
                // 1.4根据遍历到的字典创建控制器
                let title = dict["title"] as? String
                let vcName = dict["vcName"] as? String
                let imageName = dict["imageName"] as? String
                addChildViewController(vcName, title: title, imageName: imageName)
            }
        }catch
        {
            // 只要try对应的方法发生了异常, 就会执行catch{}中的代码
            addChildViewController("HomeTableViewController", title: "首页", imageName: "tabbar_home")
            addChildViewController("MessageTableViewController", title: "消息", imageName: "tabbar_message_center")
            addChildViewController("NullViewController", title: "", imageName: "")
            addChildViewController("DiscoverTableViewController", title: "发现", imageName: "tabbar_discover")
            addChildViewController("ProfileTableViewController", title: "我", imageName: "tabbar_profile")
        }
    }

    /// 添加一个子控制器
    func addChildViewController(_ childControllerName: String?, title: String?, imageName: String?) {
        
        // 1.动态获取命名空间
        guard let name =  Bundle.main.infoDictionary!["CFBundleExecutable"] as? String else
        {
            HHLog("获取命名空间失败")
            return
        }
        
        // 2.根据字符串获取Class
        var cls: AnyClass? = nil
        if let vcName = childControllerName
        {
            cls = NSClassFromString(name + "." + vcName)
        }
        
        // 3.根据Class创建对象
        // Swift中如果想通过一个Class来创建一个对象, 必须告诉系统这个Class的确切类型
        guard let typeCls = cls as? UITableViewController.Type else
        {
            HHLog("cls不能当做UITableViewController")
            return
        }
        // 通过Class创建对象
        let childController = typeCls.init()
        
        
        // 1.2设置自控制的相关属性
        childController.title = title
        if let ivName = imageName
        {
            childController.tabBarItem.image = UIImage(named: ivName)
            childController.tabBarItem.selectedImage = UIImage(named: ivName + "_highlighted")
        }
        
        // 1.3包装一个导航控制器
        let nav = UINavigationController(rootViewController: childController)
        // 1.4将子控制器添加到UITabBarController中
        addChildViewController(nav)
        
    }
    
    // MARK: - 懒加载
    private lazy var composeButton: UIButton = {
        () -> UIButton
        in
        // 1.创建按钮
        // 1.创建按钮
        let btn = UIButton(imageName:"tabbar_compose_icon_add", backgroundImageName: "tabbar_compose_button")
        
        // 4.监听按钮点击
        btn.addTarget(self, action: #selector(MainViewController.compseBtnClick(btn:)), for: .touchUpInside)
        
        return btn
    }()
    
    @objc private func compseBtnClick(btn: UIButton)
    {
        
        let vc = ComposeViewController()
        present(vc, animated: true, completion: nil)
        HHLog(btn)
    }
}
