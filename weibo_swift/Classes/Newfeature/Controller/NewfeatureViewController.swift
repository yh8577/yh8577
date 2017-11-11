//
//  NewfeatureViewController.swift
//  swift微博
//
//  Created by huig on 17/10/4.
//  Copyright © 2017年 huige. All rights reserved.
//

import UIKit
import SDWebImage

class NewfeatureViewController: UIViewController,UICollectionViewDelegateFlowLayout {
    
    var maxCount = 4
    var NewfeatureCell: UICollectionView?  // 创建一个列表

    // 加载界面
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLayout()
    
    }
    
    private func setupLayout() {
    
        let layout = NewfeatureLayout()
        NewfeatureCell = UICollectionView(frame: UIScreen.main.bounds, collectionViewLayout: layout)
        NewfeatureCell?.register(NewfeatureCollectionViewCell.self, forCellWithReuseIdentifier: "NewfeatureCell")
        NewfeatureCell?.delegate = self
        NewfeatureCell?.dataSource = self
        NewfeatureCell?.backgroundColor = UIColor.white
        self.view.addSubview(NewfeatureCell!);
    }
    
}

extension NewfeatureViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NewfeatureCell", for: indexPath) as! NewfeatureCollectionViewCell;
        cell.index = indexPath.item
        return cell;
    }
}

extension NewfeatureViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let index = collectionView.indexPathsForVisibleItems.last!
        let currentCell = collectionView.cellForItem(at: index ) as! NewfeatureCollectionViewCell
        if index.item == (maxCount - 1) {
            currentCell.startAnimtion()
        }
    }
}

class NewfeatureCollectionViewCell: UICollectionViewCell {
    
    var index: Int = 0
        {
        didSet{
            let name = "new_feature_\(index+1)"
            iconView.image = UIImage(named: name)
            startButton.isHidden = true
        }
    }

    private var iconView = UIImageView()
    
    private lazy var startButton: UIButton = {
        let btn = UIButton(imageName: nil, backgroundImageName: "new_feature_button")
        btn.addTarget(self, action: #selector(NewfeatureCollectionViewCell.startBtnClick), for: .touchUpInside)
        return btn
    }()

    @objc private func startBtnClick() {
        HHLog("")
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: RootViewControllerChnage), object: true)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Cell 初始化失败")
    }
    
    private func setupUI() {
        
        iconView.frame = UIScreen.main.bounds
//        iconView.backgroundColor = UIColor.red
        contentView.addSubview(iconView)
        
        startButton.frame.origin = CGPoint(x: (width - startButton.frame.width) * 0.5, y: height - 160)
        contentView.addSubview(startButton)
    }
    
    func startAnimtion() {
        
        startButton.isHidden = false
        // 关闭交互避免动画被打断
        self.startButton.transform = CGAffineTransform(scaleX: 0.0, y: 0.0)
        self.startButton.isUserInteractionEnabled = false
        UIView.animate(withDuration: 2.0, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 10, options: UIViewAnimationOptions(rawValue: 0), animations: {
            
            self.startButton.transform = CGAffineTransform.identity
        }, completion: { (_) in
            // 打开交互避免动画被打断
            self.startButton.isUserInteractionEnabled = true
        })
    }
}

class NewfeatureLayout: UICollectionViewFlowLayout {
    
    override func prepare() {
        
        itemSize = UIScreen.main.bounds.size
        minimumLineSpacing = 0
        minimumInteritemSpacing = 0
        scrollDirection = UICollectionViewScrollDirection.horizontal
        collectionView?.isPagingEnabled = true
        collectionView?.bounces = false
        collectionView?.showsVerticalScrollIndicator = false
        collectionView?.showsHorizontalScrollIndicator = false
    }
}
