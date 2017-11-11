//
//  BrowserViewController.swift
//  weibo_swift
//
//  Created by yihui on 2017/11/5.
//  Copyright © 2017年 huig. All rights reserved.
//

import UIKit
import SDWebImage

class BrowserViewController: UIViewController {
    /// 所有配图
    var bmiddle_pic: [URL]
    /// 当前点击的索引
    var indexPath: IndexPath
    
    init(bmiddle_pic: [URL], indexPath: IndexPath)
    {
        self.bmiddle_pic = bmiddle_pic
        self.indexPath = indexPath
        
        // 注意: 自定义构造方法时候不一定是调用super.init(), 需要调用当前类设计构造方法(designated)
        super.init(nibName: nil, bundle: nil)
        
        // 初始化UI
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        collectionView.scrollToItem(at: indexPath, at: UICollectionViewScrollPosition.left, animated: false)
    }
    // MARK: - 内部控制方法
    fileprivate func setupUI()
    {
        // 1.添加子控件
        view.addSubview(collectionView)
        view.addSubview(closeButton)
        view.addSubview(saveButton)
        
        // 2.布局子控件
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        var cons = NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[collectionView]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["collectionView": collectionView])
        cons += NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[collectionView]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["collectionView": collectionView])
        view.addConstraints(cons)
        
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        let dict = ["closeButton": closeButton, "saveButton": saveButton]
        let closeHCons = NSLayoutConstraint.constraints(withVisualFormat: "H:|-20-[closeButton(100)]", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: dict)
        let closeVCons = NSLayoutConstraint.constraints(withVisualFormat: "V:[closeButton(50)]-20-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: dict)
        view.addConstraints(closeHCons)
        view.addConstraints(closeVCons)
        
        let saveHCons = NSLayoutConstraint.constraints(withVisualFormat: "H:[saveButton(100)]-20-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: dict)
        let saveVCons = NSLayoutConstraint.constraints(withVisualFormat: "V:[saveButton(50)]-20-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: dict)
        view.addConstraints(saveHCons)
        view.addConstraints(saveVCons)
    }
    
    @objc fileprivate func closeBtnClick()
    {
        dismiss(animated: true, completion: nil)
    }
    @objc fileprivate func saveBtnClick()
    {
        
    }
    // MARK: - 懒加载
    fileprivate lazy var collectionView: UICollectionView =
    {
        let clv = UICollectionView(frame: CGRect.zero, collectionViewLayout: XMGBrowserLayout())
        clv.dataSource = self
        clv.register(XMGBrowserCell.self, forCellWithReuseIdentifier: "browserCell")
        return clv
    }()
    
    fileprivate lazy var closeButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("关闭", for: UIControlState())
        btn.backgroundColor = UIColor(white: 0.8, alpha: 0.5)
        btn.addTarget(self, action: Selector("closeBtnClick"), for: UIControlEvents.touchUpInside)
        return btn
    }()
    fileprivate lazy var saveButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("保存", for: UIControlState())
        btn.backgroundColor = UIColor(white: 0.8, alpha: 0.5)
        btn.addTarget(self, action: Selector("saveBtnClick"), for: UIControlEvents.touchUpInside)
        return btn
    }()
    
}

extension BrowserViewController: UICollectionViewDataSource
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return bmiddle_pic.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "browserCell", for: indexPath) as! XMGBrowserCell
        
        cell.backgroundColor = (indexPath.item % 2 == 0) ? UIColor.red : UIColor.green
        cell.imageURL = bmiddle_pic[indexPath.item]
        
        return cell
    }
}

class XMGBrowserCell: UICollectionViewCell, UIScrollViewDelegate {
    
    var imageURL: URL?
    {
        didSet
        {
            // 显示菊花提醒
            indicatorView.startAnimating()
            
            // 重置容器所有数据
            resetView()
            
            // 设置图片
            imageView.sd_setImage(with: imageURL) { (image, error, _, url) in
                
                // 0.关闭菊花提醒
                self.indicatorView.stopAnimating()
                
                let width = UIScreen.main.bounds.width
                let height = UIScreen.main.bounds.height
                
                // 1.计算当前图片的宽高比
                let scale = (image?.size.height)! / (image?.size.width)!
                // 2.利用宽高比乘以屏幕宽度, 等比缩放图片
                let imageHeight = scale * width
                // 3.设置图片frame
                self.imageView.frame = CGRect(origin: CGPoint.zero, size: CGSize(width: width, height: imageHeight))
                
                // 4.判断当前是长图还是短图
                if imageHeight < height
                {
                    // 短图
                    // 4.计算顶部和底部内边距
                    let offsetY = (height - imageHeight) * 0.5
                    
                    // 5.设置内边距
                    self.scrollview.contentInset = UIEdgeInsets(top: offsetY, left: 0, bottom: offsetY, right: 0)
                }else
                {
                    self.scrollview.contentSize = CGSize(width: width, height: imageHeight)
                }
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - 内部控制方法
    fileprivate func resetView()
    {
        scrollview.contentSize = CGSize.zero
        scrollview.contentInset = UIEdgeInsets.zero
        scrollview.contentOffset = CGPoint.zero
        
        imageView.transform = CGAffineTransform.identity
    }
    
    fileprivate func setupUI()
    {
        // 1.添加子控件
        contentView.addSubview(scrollview)
        scrollview.addSubview(imageView)
        contentView.addSubview(indicatorView)
        
        // 2.布局子控件
        scrollview.frame = UIScreen.main.bounds //self.frame
        scrollview.backgroundColor = UIColor.darkGray
        indicatorView.center = contentView.center
    }
    
    // MARK: - 懒加载
    fileprivate lazy var scrollview: UIScrollView = {
        let sc = UIScrollView()
        sc.maximumZoomScale = 2.0
        sc.minimumZoomScale = 0.5
        sc.delegate = self
        return sc
    }()
    fileprivate lazy  var imageView: UIImageView = UIImageView()
    /// 提示视图
    fileprivate lazy var indicatorView : UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.whiteLarge)
    
    // MARK: - UIScrollViewDelegate
    // 告诉系统需要缩放哪一个控件
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    // 缩放的过程中会不断调用
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        let width = UIScreen.main.bounds.width
        let height = UIScreen.main.bounds.height
        
        // 1.计算上下内边距
        var offsetY = (height - imageView.frame.height) * 0.5
        // 2.计算左右内边距
        var offsetX = (width - imageView.frame.width) * 0.5
        
        offsetY = (offsetY < 0) ? 0 : offsetY
        offsetX = (offsetX < 0) ? 0 : offsetX
        
        scrollview.contentInset = UIEdgeInsets(top: offsetY, left: offsetX, bottom: offsetY, right: offsetX)
    }
}

class XMGBrowserLayout: UICollectionViewFlowLayout {
    override func prepare() {
        itemSize = UIScreen.main.bounds.size
        minimumInteritemSpacing = 0
        minimumLineSpacing = 0
        scrollDirection = UICollectionViewScrollDirection.horizontal
        
        collectionView?.isPagingEnabled = true
        collectionView?.bounces = false
        collectionView?.showsHorizontalScrollIndicator = false
        collectionView?.showsVerticalScrollIndicator = false
    }
}

