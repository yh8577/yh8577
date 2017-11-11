//
//  HomeTableViewCell.swift
//  swift微博
//
//  Created by huig on 17/10/6.
//  Copyright © 2017年 huige. All rights reserved.
//

import UIKit
import SDWebImage
import SnapKit

class HomeTableViewCell: UITableViewCell, UICollectionViewDelegateFlowLayout {

    // 头像
    var iconImageView = UIImageView()
    // 昵称
    var nameLabel = UILabel(1, fontSize: 14, color: nil, fontSizeToFitWidth: true)
    // 认证图标
    var verifiedImageView = UIImageView()
    // vip图标
    var vipImageView = UIImageView()
    // 时间
    var timeLabel = UILabel(1, fontSize: 12, color: .lightGray, fontSizeToFitWidth: true)
    // 来源
    var sourceLabel = UILabel(1, fontSize: 12, color: .lightGray, fontSizeToFitWidth: true)
    // 正文
    var contentLabel = UILabel(0, fontSize: 14, color: .black, fontSizeToFitWidth: false)
    // 底部工具条
    var footerView = BottomToolsView()
    
    var flowLayout = UICollectionViewFlowLayout()
    
    // 图片Cell
    private lazy var pictureCollectionView : UICollectionView = {
        let colltionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: self.flowLayout)
        colltionView.backgroundColor = UIColor.clear
        //注册一个cell
        colltionView.register(HomePictureCell.self, forCellWithReuseIdentifier: "pictureCell")
        //设置每一个cell的宽高
        self.flowLayout.itemSize = CGSize.zero
        return colltionView
    }()
    
    var forwardView = UIView()
    
    var forwardLabel = UILabel(0, fontSize: 14, color: .black, fontSizeToFitWidth: false)
 
    var viewModel: StatusViewModel? {
        
        didSet{
            
            // 头像
            iconImageView.sd_setImage(with: viewModel?.icon_URL, completed: nil)
            iconImageView.layer.cornerRadius = 25
            iconImageView.clipsToBounds = true
            
            iconImageView.snp.makeConstraints { (make) in
                make.leading.equalTo(10)
                make.top.equalTo(10)
                make.width.height.equalTo(50)
            }
            
            // 认证图标
            verifiedImageView.image = viewModel?.verified_image
            verifiedImageView.snp.makeConstraints({ (make) in
                make.bottom.equalTo(iconImageView)
                make.trailing.equalTo(iconImageView)
                make.width.height.equalTo(14)
            })
            
            // 昵称
            nameLabel.text = viewModel?.status.user?.screen_name
            nameLabel.snp.makeConstraints({ (make) in
                make.top.equalTo(iconImageView).offset(10)
                make.leading.equalTo(iconImageView.snp.trailing).offset(10)
            })
            
            // vip图标
            vipImageView.image = nil
            nameLabel.textColor = UIColor.black
            if let image = viewModel?.mbrankImage {
                vipImageView.image = image
                nameLabel.textColor = UIColor.orange
            }
            vipImageView.snp.makeConstraints({ (make) in
                make.leading.equalTo(nameLabel.snp.trailing).offset(5)
                make.centerY.equalTo(nameLabel.snp.centerY)
                make.width.height.equalTo(17)
            })
            
            // 5.设置时间
            timeLabel.text = viewModel?.created_Time
            //调用计算label宽高的方法
            let timeLabelSize = getTextCGSize(textStr: timeLabel.text!, font: timeLabel.font!, width: 100, height: 30)
            timeLabel.snp.makeConstraints({ (make) in
                make.bottom.equalTo(iconImageView)
                make.leading.equalTo(iconImageView.snp.trailing).offset(10)
                make.width.equalTo(timeLabelSize)
                make.height.equalTo(30)
            })
            
            // 来源
            sourceLabel.text = viewModel?.source_Text
            //调用计算label宽高的方法
            let sourceLabelSize = getTextCGSize(textStr: sourceLabel.text!, font: sourceLabel.font!, width: 150, height: 30)
            sourceLabel.snp.makeConstraints({ (make) in
                make.top.equalTo(timeLabel)
                make.leading.equalTo(timeLabel.snp.trailing).offset(5)
                make.width.equalTo(sourceLabelSize)
                make.height.equalTo(30)
            })
            
            // 正文
            contentLabel.text = viewModel?.status.text
            let contentLabelSize = getTextCGSize(textStr: contentLabel.text!, font: contentLabel.font!, width: contentView.frame.width - 20, height: 1000)
            contentLabel.snp.makeConstraints({ (make) in
                make.top.equalTo(iconImageView.snp.bottom).offset(10)
                make.trailing.equalTo(-10)
                make.leading.equalTo(10)
                make.height.equalTo(contentLabelSize)
            })
            
            // 8.更新配图
            pictureCollectionView.reloadData()
            // 9.跟新配图尺寸
            let (itemSize, clvSize) = calculateSize()
            // 9.1更新cell的尺寸
            if itemSize != CGSize.zero
            {
                flowLayout.itemSize = itemSize
            }
            // 9.2跟新collectionView尺寸
            
            // 10.转发微博
            if let text = viewModel?.forwardText
            {
                forwardLabel.text = text
                forwardLabel.preferredMaxLayoutWidth = UIScreen.main.bounds.width - 2 * 10
                
            }
            
            // 判断是否是转发微博,是就显示
            if viewModel?.status.retweeted_status != nil {
                
                let forwardLabelSize = getTextCGSize(textStr: forwardLabel.text!, font: forwardLabel.font!, width: width - 20, height: 1000)
                forwardLabel.snp.makeConstraints({ (make) in
                    make.top.equalTo(10)
                    make.leading.equalTo(10)
                    make.height.equalTo(forwardLabelSize)
                })
                
                
                forwardView.backgroundColor = UIColor.lightGray
                forwardView.snp.makeConstraints { (make) in
                    
                    make.top.equalTo(contentLabel.snp.bottom).offset(10)
                    make.width.equalTo(width)
                    make.height.equalTo((clvSize.height+40+forwardLabelSize.height))
                    
                }
            }
            
            pictureCollectionView.snp.makeConstraints({ (make) in
                
                if viewModel?.status.retweeted_status != nil {
                    make.top.equalTo(forwardLabel.snp.bottom).offset(10)
                }else {
                    make.top.equalTo(contentLabel.snp.bottom).offset(10)
                }
                
                make.leading.equalTo(10)
                make.width.equalTo(clvSize.width)
                make.height.equalTo(clvSize.height)
            })
            
            footerView.snp.makeConstraints { (make) in
                make.top.equalTo(pictureCollectionView.snp.bottom).offset(10)
                make.width.equalTo(self)
                make.height.equalTo(44)
            }

            contentView.snp.makeConstraints { (make) in
                make.bottom.equalTo(footerView)
                make.leading.equalTo(self)
                make.top.equalTo(self)
                make.trailing.equalTo(self)
            }
        }
    }
    
    
    // MARK: - 外部控制方法
    func calculateRowHeight(viewModel: StatusViewModel) -> CGFloat {
        
        self.viewModel = viewModel
        
        self.layoutIfNeeded()

        return footerView.frame.maxY
    }
    
    
    // MARK: - 内部控制方法
    // 计算cell和collectionview的尺寸
    private func calculateSize() -> (CGSize, CGSize)
    {
        /*
         没有配图: cell = zero, collectionview = zero
         一张配图: cell = image.size, collectionview = image.size
         四张配图: cell = {90, 90}, collectionview = {2*w+m, 2*h+m}
         其他张配图: cell = {90, 90}, collectionview =
         */
        let count = viewModel?.thumbnail_pic?.count ?? 0
        
        // 没有配图
        if count == 0
        {
            return (CGSize.zero, CGSize.zero)
        }
        
        // 一张配图
        if count == 1
        {
            let key = viewModel!.thumbnail_pic!.first!.absoluteString
            // 从缓存中获取已经下载好的图片, 其中key就是图片的url
            let image = SDWebImageManager.shared().imageCache?.imageFromDiskCache(forKey: key)
            return (image!.size, image!.size)
           
        }
        
        
        let imageWidth: CGFloat = 90
        let imageHeight: CGFloat = 90
        let imageMargin: CGFloat = 10
        // 四张配图
        if count == 4
        {
            let col = 2
            let row = col
            // 宽度 = 图片的宽度 * 列数 + (列数 - 1) * 间隙
            let width = imageWidth * CGFloat(col) + CGFloat(col - 1) * imageMargin
            // 宽度 = 图片的高度 * 行数 + (行数 - 1) * 间隙
            let height = imageHeight * CGFloat(row) + CGFloat(row - 1) * imageMargin
            return (CGSize(width: imageWidth, height: imageHeight), CGSize(width: width, height: height))
        }
        
        // 其他张配图
        let col = 3
        let row = (count - 1) / 3 + 1
        // 宽度 = 图片的宽度 * 列数 + (列数 - 1) * 间隙
        let width = imageWidth * CGFloat(col) + CGFloat(col - 1) * imageMargin
        // 宽度 = 图片的高度 * 行数 + (行数 - 1) * 间隙
        let height = imageHeight * CGFloat(row) + CGFloat(row - 1) * imageMargin
        
        
        return (CGSize(width: imageWidth, height: imageHeight), CGSize(width: width, height: height))
        
    }
 
 
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(iconImageView)
        addSubview(verifiedImageView)
        addSubview(nameLabel)
        addSubview(vipImageView)
        addSubview(timeLabel)
        addSubview(sourceLabel)
        addSubview(contentLabel)
        addSubview(forwardView)
        forwardView.addSubview(forwardLabel)
        addSubview(pictureCollectionView)
        addSubview(footerView)
        
        pictureCollectionView.delegate = self
        pictureCollectionView.dataSource = self
        
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    /**
     计算label的宽度和高
     */
    
    func getTextCGSize(textStr:String,font:UIFont,width:CGFloat,height:CGFloat) -> CGSize {
        
        let normalText: NSString = textStr as NSString
        let size = CGSize(width: width,height: height)
        let dic = NSDictionary(object: font, forKey: NSFontAttributeName as NSCopying)
        let stringSize = normalText.boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: dic as? [String : AnyObject], context:nil).size
        return stringSize
    }
}

extension HomeTableViewCell: UICollectionViewDataSource {
    
    //返回多少个cell
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return viewModel?.thumbnail_pic!.count ?? 0
    }
    //返回自定义的cell
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "pictureCell", for: indexPath as IndexPath) as! HomePictureCell

        cell.url = viewModel!.thumbnail_pic![indexPath.item] as URL?

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let url = viewModel!.bmiddle_pic![indexPath.item]
        
        let cell = collectionView.cellForItem(at: indexPath) as! HomePictureCell
        
        SDWebImageManager.shared().downloadImage(with: url, options: SDWebImageOptions(rawValue: 0), progress: { (curren, total) in
            cell.customIconImageView.progress = CGFloat(curren) / CGFloat(total)
        }) { (_, error, _, _, _) in
            
            // 2.弹出一个控制器(图片浏览器), 告诉控制器哪些图片需要展示, 告诉控制器当前展示哪一张
            NotificationCenter.default.post(name: Notification.Name(rawValue: XMGShowPhotoBrowserController), object: self, userInfo: ["bmiddle_pic": self.viewModel!.bmiddle_pic!, "indexPath": indexPath])
        }
    }

}

class HomePictureCell: UICollectionViewCell {
    
    var customIconImageView: XMGProgressImageView!
    
    var url: URL?
    {
        didSet{
             customIconImageView.sd_setImage(with: url)
        }
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        customIconImageView = XMGProgressImageView(frame: CGRect(x: 0, y: 0, width: 90, height: 90))
        contentView.addSubview(customIconImageView)
        contentView.clipsToBounds = true
        customIconImageView.contentMode = UIViewContentMode.scaleToFill
        customIconImageView.snp.makeConstraints { (make) in
            
            make.width.equalTo(self)
            make.height.equalTo(self)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

