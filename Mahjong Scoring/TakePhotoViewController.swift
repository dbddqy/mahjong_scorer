//
//  TakePhotoViewController.swift
//  Mahjong Scoring
//
//  Created by 戚越 on 2018/12/29.
//  Copyright © 2018 Yue QI. All rights reserved.
//

import UIKit
import AVFoundation
import CoreML

class CGView:UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        //设置背景色为透明，否则是黑色背景
        self.backgroundColor = UIColor.clear
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        //获取绘图上下文
        guard let context = UIGraphicsGetCurrentContext() else {
            return
        }
        
        //创建一个矩形，它的所有边都内缩3
        let drawingRect = self.bounds.insetBy(dx: 0, dy: 0)
        
        //创建并设置路径
        let path = CGMutablePath()
        path.move(to: CGPoint(x:drawingRect.minX, y:drawingRect.minY))
        path.addLine(to:CGPoint(x:drawingRect.maxX, y:drawingRect.minY))
        path.addLine(to:CGPoint(x:drawingRect.maxX, y:drawingRect.maxY))
        path.addLine(to:CGPoint(x:drawingRect.minY, y:drawingRect.maxY))
        path.addLine(to:CGPoint(x:drawingRect.minY, y:drawingRect.minY))
        
        path.move(to: CGPoint(x:(drawingRect.minX+drawingRect.maxX)*0.5, y:drawingRect.minY))
        path.addLine(to:CGPoint(x:(drawingRect.minX+drawingRect.maxX)*0.5, y:drawingRect.maxY))
        
        
        for index in 0..<14 {
            let y1OfIndex: CGFloat = drawingRect.minY*CGFloat(index)/CGFloat(14)
            let y2OfIndex: CGFloat = drawingRect.maxY*CGFloat(index)/CGFloat(14)
            let yOfIndex: CGFloat = y1OfIndex + y2OfIndex
            path.move(to: CGPoint(x:drawingRect.minX, y:yOfIndex))
            path.addLine(to:CGPoint(x:drawingRect.maxX, y:yOfIndex))
        }
        //添加路径到图形上下文
        context.addPath(path)
        
        //设置笔触颜色
        context.setStrokeColor(UIColor.red.cgColor)
        //设置笔触宽度
        context.setLineWidth(1)
        
        //绘制路径
        context.strokePath()
    }
}

class TakePhotoViewController: UIViewController{

    @IBOutlet weak var takephotobutton: UIButton!
    @IBAction func goBack(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    
    
    var captureSession = AVCaptureSession()
    
    var backCamera: AVCaptureDevice?
    var frontCamera: AVCaptureDevice?
    var currentDevice: AVCaptureDevice?
    
    var photoOutput: AVCapturePhotoOutput?
    
    var cameraPreviewLayer:AVCaptureVideoPreviewLayer?

    let model = MahjongClassifier()

    var image: UIImage?
    var cutImages: [UIImage] = []
    
    var toggleCameraGestureRecognizer = UISwipeGestureRecognizer()
    
    var zoomInGestureRecognizer = UISwipeGestureRecognizer()
    var zoomOutGestureRecognizer = UISwipeGestureRecognizer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let bounds = UIScreen.main.bounds
        let frame = CGRect(x: bounds.maxX*0.329, y: bounds.maxY*0.05, width: bounds.maxX*0.342, height: bounds.maxY*0.9)
        let cgView = CGView(frame: frame)
        self.view.addSubview(cgView)
        
        setupCaptureSession()
        setupDevice()
        setupInputOutput()
        setupPreviewLayer()
        captureSession.startRunning()
        
        toggleCameraGestureRecognizer.direction = .up
        toggleCameraGestureRecognizer.addTarget(self, action: #selector(self.switchCamera))
        view.addGestureRecognizer(toggleCameraGestureRecognizer)
        
        // Zoom In recognizer
        zoomInGestureRecognizer.direction = .right
        zoomInGestureRecognizer.addTarget(self, action: #selector(zoomIn))
        view.addGestureRecognizer(zoomInGestureRecognizer)
        
        // Zoom Out recognizer
        zoomOutGestureRecognizer.direction = .left
        zoomOutGestureRecognizer.addTarget(self, action: #selector(zoomOut))
        view.addGestureRecognizer(zoomOutGestureRecognizer)
        styleCaptureButton()
        // Do any additional setup after loading the view.
    }
    
    func styleCaptureButton() {
        takephotobutton.layer.borderColor = UIColor.white.cgColor
        takephotobutton.layer.borderWidth = 3
        takephotobutton.clipsToBounds = true
        takephotobutton.layer.cornerRadius = min(takephotobutton.frame.width, takephotobutton.frame.height) / 2
    }
    
    func setupCaptureSession() {
        captureSession.sessionPreset = AVCaptureSession.Preset.photo
    }
    
    func setupDevice() {
        let deviceDiscoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [AVCaptureDevice.DeviceType.builtInWideAngleCamera], mediaType: AVMediaType.video, position: AVCaptureDevice.Position.unspecified)
        let devices = deviceDiscoverySession.devices
        
        for device in devices {
            if device.position == AVCaptureDevice.Position.back {
                backCamera = device
            } else if device.position == AVCaptureDevice.Position.front {
                frontCamera = device
            }
        }
        currentDevice = backCamera
    }
    
    func setupInputOutput() {
        do {
            
            let captureDeviceInput = try AVCaptureDeviceInput(device: currentDevice!)
            captureSession.addInput(captureDeviceInput)
            photoOutput = AVCapturePhotoOutput()
            photoOutput!.setPreparedPhotoSettingsArray([AVCapturePhotoSettings(format: [AVVideoCodecKey : AVVideoCodecType.jpeg])], completionHandler: nil)
            captureSession.addOutput(photoOutput!)
            
            
        } catch {
            print(error)
        }
    }
    
    func setupPreviewLayer() {
        self.cameraPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        self.cameraPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
        self.cameraPreviewLayer?.connection?.videoOrientation = AVCaptureVideoOrientation.portrait
        self.cameraPreviewLayer?.frame = view.frame
        
        self.view.layer.insertSublayer(self.cameraPreviewLayer!, at: 0)
    }
    
    @IBAction func touchTakePhotoButton(_ sender: UIButton) {
        let settings = AVCapturePhotoSettings()
        self.photoOutput?.capturePhoto(with: settings, delegate: self)
        
    }
    
    @objc func switchCamera() {
        captureSession.beginConfiguration()
        
        // Change the device based on the current camera
        let newDevice = (currentDevice?.position == AVCaptureDevice.Position.back) ? frontCamera : backCamera
        
        // Remove all inputs from the session
        for input in captureSession.inputs {
            captureSession.removeInput(input as! AVCaptureDeviceInput)
        }
        
        // Change to the new input
        let cameraInput:AVCaptureDeviceInput
        do {
            cameraInput = try AVCaptureDeviceInput(device: newDevice!)
        } catch {
            print(error)
            return
        }
        
        if captureSession.canAddInput(cameraInput) {
            captureSession.addInput(cameraInput)
        }
        
        currentDevice = newDevice
        captureSession.commitConfiguration()
    }
    
    @objc func zoomIn() {
        if let zoomFactor = currentDevice?.videoZoomFactor {
            if zoomFactor < 5.0 {
                let newZoomFactor = min(zoomFactor + 1.0, 5.0)
                do {
                    try currentDevice?.lockForConfiguration()
                    currentDevice?.ramp(toVideoZoomFactor: newZoomFactor, withRate: 1.0)
                    currentDevice?.unlockForConfiguration()
                } catch {
                    print(error)
                }
            }
        }
    }
    
    @objc func zoomOut() {
        if let zoomFactor = currentDevice?.videoZoomFactor {
            if zoomFactor > 1.0 {
                let newZoomFactor = max(zoomFactor - 1.0, 1.0)
                do {
                    try currentDevice?.lockForConfiguration()
                    currentDevice?.ramp(toVideoZoomFactor: newZoomFactor, withRate: 1.0)
                    currentDevice?.unlockForConfiguration()
                } catch {
                    print(error)
                }
            }
        }
    }
    
    
    
    private func cutPhoto(){
        guard let resizedImage = self.image?.reSizeImage(reSize: CGSize(width: 180, height: 240)) else {return}
        self.cutImages.append(resizedImage)
        print(resizedImage.size)
        var cutImage: UIImage
        for i in 0..<14 {
            for j in 0..<2 {
                let cgImageCorpped = resizedImage.cgImage?.cropping(to: CGRect(x: 135+j*45, y: 30+i*30, width: 45, height: 30))
                cutImage = UIImage(cgImage: cgImageCorpped!)
                self.cutImages.append(cutImage)
            }
        }
        return
    }
    
    private func pixelValues(fromCGImage imageRef: CGImage?) -> ([UInt8]?){
        var width = 0
        var height = 0
        var pixelValues: [UInt8]?
        if let imageRef = imageRef {
            width = imageRef.width
            height = imageRef.height
            let bitsPerComponent = imageRef.bitsPerComponent
            let bytesPerRow = imageRef.bytesPerRow
            let totalBytes = height * bytesPerRow
            
            let colorSpace = CGColorSpaceCreateDeviceGray()
            var intensities = [UInt8](repeating: 0, count: totalBytes)
            
            let contextRef = CGContext(data: &intensities, width: width, height: height, bitsPerComponent: bitsPerComponent, bytesPerRow: bytesPerRow, space: colorSpace, bitmapInfo: 0)
            contextRef?.draw(imageRef, in: CGRect(x: 0.0, y: 0.0, width: CGFloat(width), height: CGFloat(height)))
            
            pixelValues = intensities
        }
        
        return (pixelValues)
    }
    
    private func dataToMlMultiArray(from data: [Double], size length: NSNumber) -> MLMultiArray{
        guard let mlMultiArray = try? MLMultiArray(shape:[length], dataType:MLMultiArrayDataType.double) else {
            fatalError("Unexpected runtime error. MLMultiArray")
        }
        for (index, element) in data.enumerated() {
            mlMultiArray[index] = NSNumber(floatLiteral: element)
        }
        return mlMultiArray
    }
    
    private func analysePhotos() -> [Int]{
        var result: [Int] = []
        for image in self.cutImages{
            let analyseResult = try? model.prediction(image: image as! CVPixelBuffer)
            result.append(Int(analyseResult!.classLabel)!)
        }
        return result
    }

//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "Preview_Segue" {
//            let firstViewController = segue.destination as! ViewController
//            firstViewController.mahjongScoring. = self.image
//        }
//    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension TakePhotoViewController: AVCapturePhotoCaptureDelegate {
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        if let imageData = photo.fileDataRepresentation() {
            self.image = UIImage(data: imageData)
//            performSegue(withIdentifier: "Preview_Segue", sender: nil)
            cutPhoto()
            let result = analysePhotos()
            var flag = false
            for number in result {
                print(number)
                if number != 35 { flag = true }
            }
            if flag {
                for image in self.cutImages{
                    UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
                }
            } else {
                let alert=UIAlertController(title:"无法识别",message: nil,preferredStyle:.actionSheet)
                let action = UIAlertAction(title: "返回", style: UIAlertAction.Style.default){
                    (ACTION) in
                    self.dismiss(animated: true, completion: nil)
                }
                alert.addAction(action)
                present(alert, animated: true, completion: nil)
            }
            dismiss(animated: true, completion: nil)
        }
    }
}

extension UIImage {
    /**
     *  重设图片大小
     */
    func reSizeImage(reSize:CGSize)->UIImage {
        //UIGraphicsBeginImageContext(reSize);
        UIGraphicsBeginImageContextWithOptions(reSize,false,UIScreen.main.scale);
        self.draw(in: CGRect(x:0, y:0, width: reSize.width, height: reSize.height));
        let reSizeImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!;
        UIGraphicsEndImageContext();
        return reSizeImage;
    }
    
}
