//
//  RefreshView.swift
//  weibo_swift
//
//  Created by yihui on 2017/11/2.
//  Copyright © 2017年 huig. All rights reserved.
//

import UIKit
import SnapKit

class XMGRefreshControl: UIRefreshControl {
    override init() {
        super.init()
        // 1.添加子控件
        addSubview(refreshView)
        // 2.布局子控件
        refreshView.snp.makeConstraints { (make) -> Void in
            make.size.equalTo(CGSize(width: 200, height: 50))
            make.center.equalTo(self)
        }
        
        // 3.监听UIRefreshControl frame改变
        addObserver(self, forKeyPath: "frame", options: NSKeyValueObservingOptions.new, context: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    deinit
    {
        removeObserver(self, forKeyPath: "frame")
    }
    override func endRefreshing() {
        super.endRefreshing()
        refreshView.stopLoadingView()
    }
    
    /// 记录是否需要旋转
    var rotationFlag = false
    
    // MARK: - 内部控制方法
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        if frame.origin.y == 0 || frame.origin.y == -64
        {
            // 过滤掉垃圾数据
            return
        }
        
        // 判断是否触发下拉刷新事件
        if isRefreshing
        {
            // 隐藏提示视图, 显示加载视图, 并且让菊花转动
            refreshView.startLoadingView()
            return
        }
        
        // 通过观察发现: 往下拉Y越小, 往上推Y越大
        if frame.origin.y < -50 && !rotationFlag
        {
            rotationFlag = true
            refreshView.rotationArrow(rotationFlag)
        }else if frame.origin.y > -50 && rotationFlag
        {
            rotationFlag = false
            refreshView.rotationArrow(rotationFlag)
        }
    }
    
    // MARK: -懒加载
    fileprivate lazy var refreshView: RefreshView = RefreshView()
}


class RefreshView: UIView {
    
    /// 菊花
    private lazy var loadingImageView = UIImageView()
    
    /// label
    private lazy var loadingLabel = UILabel()
    
    /// 提示视图
    private lazy var tipView = UIView()
    /// 箭头
    private lazy var arrowImageView = UIImageView()
    
    /// label
    private lazy var tipLabel = UILabel()
    
    private func setTipView() {
        tipView.frame = CGRect(x: 0, y: 0, width: 200, height: 50)
        tipView.backgroundColor = UIColor.white
        setArrowImage()
        setTipLabel()
        addSubview(tipView)
    }
    
    private func setTipLabel() {
        tipLabel = setlabel()
        tipLabel.text = "下拉刷新..."
        tipView.addSubview(tipLabel)
    }
    
    private func setArrowImage() {
        arrowImageView.frame = CGRect(x: 10, y: 0, width: 32, height: 32)
        arrowImageView.image = UIImage(named: "tableview_pull_refresh")
        tipView.addSubview(arrowImageView)
    }

    private func setLoadingImage() {
        loadingImageView.frame = CGRect(x: 0, y: 0, width: 32, height: 32)
        loadingImageView.image = UIImage(named: "tableview_loading")
        addSubview(loadingImageView)
    }
    
    private func setLoadingLabel() {
        loadingLabel = setlabel()
        loadingLabel.text = "正在刷新..."
    }
    
    private func setlabel() -> UILabel {
        let lW: CGFloat = 150 - 32
        let lH: CGFloat = 30
        let lX: CGFloat = 52
        let lY: CGFloat = 0
        let l = UILabel()
        l.frame = CGRect(x: lX, y: lY, width: lW, height: lH)
        l.textColor = UIColor.black
        l.textAlignment = NSTextAlignment.center
        addSubview(l)
        return l
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setLoadingImage()
        setLoadingLabel()
        setTipView()
        
    }
    
    // MARK: - 外部控制方法
    /// 旋转箭头
    func rotationArrow(_ flag: Bool)
    {
        var angle: CGFloat = flag ? -0.01 : 0.01
        angle += CGFloat(Double.pi)
        /*
         transform旋转动画默认是按照顺时针旋转的
         但是旋转时还有一个原则, 就近原则
         */
        UIView.animate(withDuration: 2.0, animations: { () -> Void in
            self.arrowImageView.transform = self.arrowImageView.transform.rotated(by: angle)
        })
    }
    
    /// 显示加载视图
    func startLoadingView()
    {
        // 0.隐藏提示视图
        tipView.isHidden = true
        
        if let _ = loadingImageView.layer.animation(forKey: "lnj")
        {
            // 如果已经添加过动画, 就直接返回
            return
        }
        // 1.创建动画
        let anim =  CABasicAnimation(keyPath: "transform.rotation")
        
        // 2.设置动画属性
        anim.toValue = 2 * Double.pi
        anim.duration = 5.0
        anim.repeatCount = MAXFLOAT
        
        // 3.将动画添加到图层上
        loadingImageView.layer.add(anim, forKey: "lnj")
    }
    
    /// 隐藏加载视图
    func stopLoadingView()
    {
        // 0.显示提示视图
        tipView.isHidden = false
        
        // 1.移除动画
        loadingImageView.layer.removeAllAnimations()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
