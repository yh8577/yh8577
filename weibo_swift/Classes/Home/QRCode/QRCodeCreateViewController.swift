//
//  QRCodeCreateViewController.swift
//  weibo_swift
//
//  Created by yihui on 2017/11/1.
//  Copyright © 2017年 huig. All rights reserved.
//

import UIKit

class QRCodeCreateViewController: UIViewController {

    private lazy var customImageVivew = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        nav()
        
        // 1.创建滤镜
        let filter = CIFilter(name: "CIQRCodeGenerator")
        // 2.还原滤镜默认属性
        filter?.setDefaults()
        // 3.设置需要生成二维码的数据到滤镜中
        // OC中要求设置的是一个二进制数据
        filter?.setValue("极客江南".data(using: String.Encoding.utf8), forKeyPath: "InputMessage")
        // 4.从滤镜从取出生成好的二维码图片
        guard let ciImage = filter?.outputImage else
        {
            return
        }
        
        customImage()
        
        customImageVivew.image = createNonInterpolatedUIImageFormCIImage(ciImage, size: 500)
        
    }
    
    
    private func customImage() {
        
        view.addSubview(customImageVivew)
        let customImageWH: CGFloat = 200
        customImageVivew.frame = CGRect(x: (width - customImageWH) * 0.5, y: 164, width: customImageWH, height: customImageWH)
        
    }
    
    /**
     生成高清二维码
     
     - parameter image: 需要生成原始图片
     - parameter size:  生成的二维码的宽高
     */
    fileprivate func createNonInterpolatedUIImageFormCIImage(_ image: CIImage, size: CGFloat) -> UIImage {
        
        let extent: CGRect = image.extent.integral
        let scale: CGFloat = min(size/extent.width, size/extent.height)
        
        // 1.创建bitmap;
        let width = extent.width * scale
        let height = extent.height * scale
        let cs: CGColorSpace = CGColorSpaceCreateDeviceGray()
        let bitmapRef = CGContext(data: nil, width: Int(width), height: Int(height), bitsPerComponent: 8, bytesPerRow: 0, space: cs, bitmapInfo: 0)!
        
        let context = CIContext(options: nil)
        let bitmapImage: CGImage = context.createCGImage(image, from: extent)!
        
        bitmapRef.interpolationQuality = CGInterpolationQuality.none
        bitmapRef.scaleBy(x: scale, y: scale);
        bitmapRef.draw(bitmapImage, in: extent);
        
        // 2.保存bitmap到图片
        let scaledImage: CGImage = bitmapRef.makeImage()!
        
        return UIImage(cgImage: scaledImage)
    }


    // 3.添加导航条
    private func nav(){
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "关闭", style: .plain, target: self, action: #selector(QRCodeCreateViewController.closeBtnClick(btn:)))
        
        // 导航条title
        navigationItem.title = "我的名片"
        let dict:NSDictionary = [NSForegroundColorAttributeName: UIColor.white,NSFontAttributeName : UIFont.boldSystemFont(ofSize: 16)]
        navigationController?.navigationBar.titleTextAttributes = dict as? [String : AnyObject]
        navigationController?.navigationBar.barTintColor = UIColor(white: 32.0/255.0, alpha: 1.0)
    }
    
    @objc private func closeBtnClick(btn: UIButton)
    {
        dismiss(animated: true, completion: nil)
    }

}
