//
//  QRCodeViewController.swift
//  weibo_swift
//
//  Created by yihui on 2017/10/31.
//  Copyright © 2017年 huig. All rights reserved.
//

import UIKit
import SnapKit
import AVFoundation

class QRCodeViewController: UIViewController {

    private lazy var qrView = UIView()
    private lazy var border = UIImageView()
    private lazy var scanline = UIImageView()
    fileprivate lazy var customLabel = UILabel()
    private lazy var nameCard = UIButton()
    private lazy var textF = UITextField()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor(white: 64.0/255.0, alpha: 1.0)
        
        // 导航条
        nav()
        
        // 工具条
        tabBar()
        
        // 冲击波视图
        qrcodeView()
        
        // 扫描结果视图
        customlabel()
        
        // 开始扫描二维码
        scanQRCode()
        
        textField()
        
        nameCardBtn()
        
        // 注册通知中心，监听键盘弹起的状态
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(QRCodeViewController.keyboardWillChange(_:)),
                                               name: .UIKeyboardWillChangeFrame, object: nil)
        
    }
    
    // gunabi键盘
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }

    // 键盘改变
    func keyboardWillChange(_ notification: Notification) {
        if let userInfo = notification.userInfo,
            let value = userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue,
            let duration = userInfo[UIKeyboardAnimationDurationUserInfoKey] as? Double,
            let curve = userInfo[UIKeyboardAnimationCurveUserInfoKey] as? UInt {
            
            let frame = value.cgRectValue
            let intersection = frame.intersection(self.view.frame)
            
            //self.view.setNeedsLayout()
            //改变下约束
            self.view.frame.origin.y = -intersection.height
            //            self.bottomConstraint.constant = intersection.height
            UIView.animate(withDuration: duration, delay: 0.0,
                           options: UIViewAnimationOptions(rawValue: curve), animations: {
                            _ in
                            self.view.layoutIfNeeded()
            }, completion: nil)
        }
    }

    // 跳转到我的名片
    @objc private func nameCardCilck() {
        
        let vc = QRCodeCreateViewController()
        let nav = UINavigationController(rootViewController: vc)
        
        present(nav, animated: true, completion: nil)
    }
    
    // 我的名片按钮
    private func nameCardBtn() {
        nameCard.frame = CGRect(x: (width - 100) * 0.5, y: textF.frame.maxY + 20, width: 100, height: 30)
        nameCard.setTitle("我的名片", for: .normal)
        nameCard.addTarget(self, action: #selector(QRCodeViewController.nameCardCilck), for: .touchUpInside)
        view.addSubview(nameCard)
    }
    
    // text 
    private func textField() {
        textF.frame = CGRect(x: (width - 200) * 0.5, y: customLabel.frame.maxY + 20, width: 200, height: 30)
        textF.text = "请输入要生成的名片内容"
        textF.textColor = UIColor.darkGray
        textF.textAlignment = NSTextAlignment.center
        view.addSubview(textF)
    }

    // label
    private func customlabel() {
        let customLabelW: CGFloat = 300
        let customLabelH: CGFloat = 50
        let customLabelX: CGFloat = (width - customLabelW) * 0.5
        let customLabelY: CGFloat = qrView.frame.maxY + 20
        customLabel.frame = CGRect(x: customLabelX, y: customLabelY, width: customLabelW, height: customLabelH)
        customLabel.text = "将二维码放入框内, 即可扫描二维码"
        customLabel.textColor = UIColor.white
        customLabel.numberOfLines = 0
        customLabel.textAlignment = NSTextAlignment.center
        view.addSubview(customLabel)
    }
    
    // 冲击波视图
    private func qrcodeView() {
        
        let qrViewWH: CGFloat = 200
        let qrViewX: CGFloat = (width - qrViewWH) * 0.5
        let qrViewY: CGFloat = 164
        
        qrView.frame = CGRect(x: qrViewX, y: qrViewY, width: qrViewWH, height: qrViewWH)
        qrView.clipsToBounds = true
        view.addSubview(qrView)
        
        border.frame.size = qrView.frame.size
        border.image = UIImage(named: "qrcode_border")
        qrView.addSubview(border)
        
        scanline.frame.size = qrView.frame.size
        scanline.image = UIImage(named: "qrcode_scanline_qrcode")
        qrView.addSubview(scanline)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        startAnimation()
    }
    
    /// 开启冲击波动画
    fileprivate func startAnimation()
    {
        // 1.设置冲击波底部和容器视图顶部对齐
        scanline.frame.origin.y = -qrView.frame.height
        view.layoutIfNeeded()
        
        // 2.执行扫描动画
        // 在Swift中一般情况下不用写self, 也不推荐我们写self
        // 一般情况下只有需要区分两个变量, 或者在闭包中访问外界属性才需要加上self
        // 优点可以提醒程序员主动思考当前self会不会形成循环引用
        UIView.animate(withDuration: 2.0, animations: { () -> Void in
            UIView.setAnimationRepeatCount(MAXFLOAT)
            self.scanline.frame.origin.y = self.qrView.frame.minY
            self.view.layoutIfNeeded()
        })
        
    }

    // 3.添加导航条
    private func nav(){
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "关闭", style: .plain, target: self, action: #selector(QRCodeViewController.closeBtnClick(btn:)))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "相册", style: .plain, target: self, action: #selector(QRCodeViewController.photoBtnClick(btn:)))
        
        // 导航条title
        navigationItem.title = "扫一扫"
        let dict:NSDictionary = [NSForegroundColorAttributeName: UIColor.white,NSFontAttributeName : UIFont.boldSystemFont(ofSize: 16)]
        navigationController?.navigationBar.titleTextAttributes = dict as? [String : AnyObject]
        navigationController?.navigationBar.barTintColor = UIColor(white: 32.0/255.0, alpha: 1.0)
    }
    

    // 底部工具条
    private func tabBar() {
        
        let vH: CGFloat = 49
        let v = UIView(frame: CGRect(x: 0, y: height - vH , width: width, height: vH))
        v.backgroundColor = UIColor(white: 32.0/255.0, alpha: 1.0)
        v.alpha = 0.8
        b1.isSelected = true
        b1.addTarget(self, action: #selector(QRCodeViewController.qrCodeClick(btn:)), for: .touchUpInside)
        b2.addTarget(self, action: #selector(QRCodeViewController.barCodeClick(btn:)), for: .touchUpInside)
        
        v.addSubview(b1)
        v.addSubview(b2)
        view.addSubview(v)
    }
    
    
    // 底部工具条按钮
    private lazy var b1: UIButton = self.addBtn(x: width * 0.25, image: "qrcode_tabbar_icon_qrcode", title: "二维码")
    private lazy var b2: UIButton = self.addBtn(x: width * 0.75, image: "qrcode_tabbar_icon_barcode", title: "条形码")
    
    // 创建btn
    private func addBtn(x: CGFloat,image: String, title: String) -> UIButton {
        let b:UIButton = UIButton(frame: CGRect(x: width * 0.5, y: 0, width: width * 0.5, height: 49))
        b.center = CGPoint(x: x ,y: 20)
        b.titleLabel?.font = UIFont.boldSystemFont(ofSize: 10) //文字大小
        b.set(image: image, title: title, titlePosition: .bottom, additionalSpacing: -8.0)
        return b
    }
    
    // tabBar按钮点击方法
    @objc private func qrCodeClick(btn: UIButton) {
        
        HHLog("")
        b1.isSelected = true
        b2.isSelected = false
        qrcodeIsBarcode(height: 200, label: "将二维码放入框内, 即可扫描二维码")
    }
    @objc private func barCodeClick(btn: UIButton) {
        HHLog("")
        b1.isSelected = false
        b2.isSelected = true
        qrcodeIsBarcode(height: 150, label: "将条形码放入框内, 即可扫描条形码")
    }
    
    // 切换动画
    private func qrcodeIsBarcode(height: CGFloat?, label: String?) {
       
        // 设置label
        if let l = label {
            customLabel.text = l
        }
        // 根据当前选中的按钮重新设置二维码容器高度
        if let h = height {
            qrView.frame.size.height = h
            border.frame.size.height = h
            scanline.frame.size.height = h
            view.layoutIfNeeded()
            // 移除动画
            scanline.layer.removeAllAnimations()
            
            // 重新开启动画
            startAnimation()
        }
    }
    
    // nav按钮点击方法
    @objc private func closeBtnClick(btn: UIButton)
    {
        dismiss(animated: true, completion: nil)
    }
    @objc private func photoBtnClick(btn: UIButton)
    {
        if !UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary)
        {
            return
        }
        
        // 2.创建相册控制器
        let imagePickerVC = UIImagePickerController()
        
        imagePickerVC.delegate = self
        // 3.弹出相册控制器
        present(imagePickerVC, animated: true, completion: nil)
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
        HHLog("销毁")
    }
    
    // MARK: - 内部控制方法
    fileprivate func scanQRCode()
    {
        // 1.判断输入能否添加到会话中
        if !session.canAddInput(input)
        {
            return
        }
        // 2.判断输出能够添加到会话中
        if !session.canAddOutput(output)
        {
            return
        }
        // 3.添加输入和输出到会话中
        session.addInput(input)
        session.addOutput(output)
        
        // 4.设置输出能够解析的数据类型
        // 注意点: 设置数据类型一定要在输出对象添加到会话之后才能设置
        output.metadataObjectTypes = output.availableMetadataObjectTypes
        
        // 5.设置监听监听输出解析到的数据
        output.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        
        // 6.添加预览图层
        view.layer.insertSublayer(previewLayer, at: 0)
        previewLayer.frame = view.bounds
        
        // 7.添加容器图层
        view.layer.addSublayer(containerLayer)
        containerLayer.frame = view.bounds
        
        // 8.开始扫描
        session.startRunning()
        
    }
    
    // MARK: - 懒加载
    /// 输入对象
    fileprivate lazy var input: AVCaptureDeviceInput? = {
        let device = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
        return try? AVCaptureDeviceInput(device: device)
    }()
    
    /// 会话
    fileprivate lazy var session: AVCaptureSession = AVCaptureSession()
    
    //    输出对象
    private lazy var output : AVCaptureMetadataOutput = {
        let out = AVCaptureMetadataOutput()
        let rect = self.view.frame
        let containerRect = self.qrView.frame
        
        let x = containerRect.origin.y / rect.height
        let y = containerRect.origin.x / rect.width
        let w = containerRect.height / rect.height
        let h = containerRect.width / rect.width
        
        out.rectOfInterest = CGRect(x: x, y: y, width: w, height: h)
        
        return out
    }()
    
    /// 预览图层
    fileprivate lazy var previewLayer: AVCaptureVideoPreviewLayer = AVCaptureVideoPreviewLayer(session: self.session)
    
    /// 专门用于保存描边的图层
    fileprivate lazy var containerLayer: CALayer = CALayer()
}

extension QRCodeViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate
{
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        // 1.取出选中的图片
        guard let image = info[UIImagePickerControllerOriginalImage] as? UIImage else
        {
            return
        }
        
        guard let ciImage = CIImage(image: image) else
        {
            return
        }
        
        // 2.从选中的图片中读取二维码数据
        // 2.1创建一个探测器
        let detector = CIDetector(ofType: CIDetectorTypeQRCode, context: nil, options: [CIDetectorAccuracy: CIDetectorAccuracyLow])
        // 2.2利用探测器探测数据
        let results = detector?.features(in: ciImage)
        // 2.3取出探测到的数据
        for result in results!
        {
            HHLog((result as! CIQRCodeFeature).messageString)

            customLabel.text = (result as! CIQRCodeFeature).messageString!
        }
        
        // 注意: 如果实现了该方法, 当选中一张图片时系统就不会自动关闭相册控制器
        picker.dismiss(animated: true, completion: nil)
    }
}

extension QRCodeViewController: AVCaptureMetadataOutputObjectsDelegate
{
    /// 只要扫描到结果就会调用
    func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [Any]!, from connection: AVCaptureConnection!)
    {
        // 1.显示结果
        customLabel.text =  (metadataObjects.last as AnyObject).stringValue
        
        clearLayers()
        
        // 2.拿到扫描到的数据
        guard let metadata = metadataObjects.last as? AVMetadataObject else
        {
            return
        }
        // 通过预览图层将corners值转换为我们能识别的类型
        let objc = previewLayer.transformedMetadataObject(for: metadata)
        // 2.对扫描到的二维码进行描边
        drawLines(objc as! AVMetadataMachineReadableCodeObject)
    }
    
    /// 绘制描边
    fileprivate func drawLines(_ objc: AVMetadataMachineReadableCodeObject)
    {
        
        // 0.安全校验
        guard let array = objc.corners else
        {
            return
        }
        
        // 1.创建图层, 用于保存绘制的矩形
        let layer = CAShapeLayer()
        layer.lineWidth = 2
        layer.strokeColor = UIColor.green.cgColor
        layer.fillColor = UIColor.clear.cgColor
        
        // 2.创建UIBezierPath, 绘制矩形
        let path = UIBezierPath()
        var point = CGPoint.zero
        var index = 0
        point = CGPoint(dictionaryRepresentation: array[index] as! CFDictionary)!
        index += 1
        // 2.1将起点移动到某一个点
        path.move(to: point)
        
        // 2.2连接其它线段
        while index < array.count
        {
            point = CGPoint(dictionaryRepresentation: array[index] as! CFDictionary)!
            index += 1
            path.addLine(to: point)
        }
        // 2.3关闭路径
        path.close()
        
        layer.path = path.cgPath
        // 3.将用于保存矩形的图层添加到界面上
        containerLayer.addSublayer(layer)
    }
    
    /// 清空描边
    fileprivate func clearLayers()
    {
        guard let subLayers = containerLayer.sublayers else
        {
            return
        }
        for layer in subLayers
        {
            layer.removeFromSuperlayer()
        }
    }
}
