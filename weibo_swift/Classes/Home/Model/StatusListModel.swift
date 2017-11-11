//
//  StatusListModel.swift
//  XMGWB
//
//  Created by xiaomage on 15/12/8.
//  Copyright © 2015年 xiaomage. All rights reserved.
//

import UIKit
import SDWebImage
import SVProgressHUD

class StatusListModel: UIView {
    
    /// 保存所有微博数据
    var statuses: [StatusViewModel]?
    
    /// 获取微博数据
    func loadData(_ lastStatus: Bool, finished: @escaping (_ models: [StatusViewModel]?, _ error: NSError?)->())
    {
        
        // 1.准备since_id和max_id
        var sinde_id = statuses?.first?.status.idstr ?? "0"
        var max_id = "0"
        if lastStatus
        {
            sinde_id = "0"
            max_id = statuses?.last?.status.idstr ?? "0"
        }
        
        // 2.发送网络请求获取数据
        NetworkTools.loadStatuses(sinde_id, max_id: max_id) { (array, error) in

            // 1.安全校验
            if error != nil
            {
                HHLog(error)
                SVProgressHUD.showError(withStatus: "获取微博数据失败")
                return
            }
            // 2.将字典数组转换为模型数组
            var models = [StatusViewModel]()
            for dict in array!
            {
                let status = Status(dict: dict)
                let viewModel = StatusViewModel(status: status)
                models.append(viewModel)
            }
            
            // 3.处理微博数据
            if sinde_id != "0"
            {
                self.statuses = models + self.statuses!
            }else if max_id != "0"
            {
                self.statuses = self.statuses! + models
            }else
            {
                self.statuses = models
            }
            
            // 4.缓存微博所有配图
            self.cachesImages(models, finished: finished)
        }

    }
 

    /// 缓存微博配图
    fileprivate func cachesImages(_ viewModels: [StatusViewModel], finished: @escaping (_ models: [StatusViewModel]?, _ error: NSError?)->())
    {
        let group = DispatchGroup()
        
        for viewModel in viewModels {
            
            guard let picurls = viewModel.thumbnail_pic else {
                continue
            }
            
            for url in picurls {
                
                group.enter()
                
                SDWebImageManager.shared().downloadImage(with: url, options: SDWebImageOptions(rawValue: 0), progress: nil, completed: { (image, error, _, _, _) in
                    //                    NJLog("图片下载完成")
                    group.leave()
                })
                
            }
        }
        
        group.notify(queue: DispatchQueue.main) { () -> Void in
            HHLog("全部下载完成")
            finished(viewModels, nil)
        }
        
    }
}


