//
//  ViewController.swift
//  OneImagePicker
//
//  Created by cindy on 2017/11/23.
//  Copyright © 2017年 Jui-hsin.Chen. All rights reserved.
//

import UIKit
import Photos

class ScrollViewController: UIViewController, UIScrollViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var scrollView: UIScrollView!
    var imageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()

        setScrollView()
        setViewAndButton()
        
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    func setScrollView() {

        // Set Up Scroll View
        scrollView = UIScrollView(frame: CGRect(x:0, y:0, width: view.bounds.size.width, height: (view.bounds.size.height - 44)))
        imageView = UIImageView(frame: CGRect(x:0, y:0, width: 2000, height: 2000))
        imageView.image = UIImage(named: "icon_photo")?.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = UIColor.white
        imageView.contentMode = .scaleAspectFit
        scrollView.contentSize = imageView.bounds.size
        view.addSubview(scrollView)
        scrollView.addSubview(imageView)
        

        //當裝置旋轉時，會重新調整大小
        scrollView.autoresizingMask = [.flexibleWidth, .flexibleHeight]

        //1.將滾動區域的位置從原點
        scrollView.contentOffset = CGPoint(x: 0, y: 0)

        //2. 縮放功能需要指定delegate self 跟縮放比例
        scrollView.delegate = self
        scrollView.maximumZoomScale = 2.0
        scrollView.zoomScale = 1.0
    }
    
    
    func setViewAndButton() {
        // Set Up Background Color
        self.view.backgroundColor = UIColor(red: 43/255, green: 43/255, blue: 43/255, alpha: 1)
        // Set Up Yellow View
        let yellowViewFrame = CGRect(x: 0, y: (view.bounds.size.height - 77), width: view.bounds.size.width, height: 77)
        let yellowView = UIView(frame: yellowViewFrame)
        yellowView.backgroundColor = UIColor(red: 249/255, green: 223/255, blue: 23/255, alpha: 1)
        yellowView.layer.masksToBounds = false
        yellowView.layer.shadowColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.25).cgColor
        yellowView.layer.shadowOpacity = 1
        yellowView.layer.shadowOffset = CGSize(width: 0, height: 0)
        yellowView.layer.shadowRadius = 10
        self.view.addSubview(yellowView)
        
        // Set Up Button
        let button = UIButton(frame: CGRect(x: (yellowView.bounds.size.width/2 - 90), y: (yellowView.bounds.size.height/2 - 22), width: 180, height: 44))
        button.backgroundColor = UIColor(red: 43/255, green: 43/255, blue: 43/255, alpha: 1)
        button.setTitle("Pick an Image", for: .normal)
        button.titleLabel?.font = UIFont (name: "SFUIText", size: 20)

        button.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .heavy)
        button.layer.masksToBounds = false
        button.layer.cornerRadius = 2.0
        button.layer.shadowColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.25).cgColor
        button.layer.shadowOpacity = 1
        button.layer.shadowOffset = CGSize(width: 0, height: 2)
        button.layer.shadowRadius = 4
        button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        yellowView.addSubview(button)
    }
    
    @objc func buttonAction() {
        
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let controller = UIImagePickerController()
            controller.delegate = self
            controller.sourceType = .photoLibrary
            self.present(controller, animated: true, completion: nil)
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController){
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]){
       guard let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage
        else { return }
    
        imageView.image = selectedImage
        dismiss(animated: true, completion: nil)
       
    }
    
    // 2.加了縮放功能 protocol (UIScrollViewDelegate) 需要implement 的function
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    //3. 為了讓圖片縮小填滿且有Aspect Fit
    fileprivate func updateMinZoomScaleForSize(_ size: CGSize) {
        let widthScale = size.width / imageView.bounds.width
        let heightScale = size.height / imageView.bounds.height
        
        let minScale = min(widthScale, heightScale)
        scrollView.minimumZoomScale = minScale
        scrollView.zoomScale = minScale
        
    }
    
    //3. 呼叫
    override func viewWillLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateMinZoomScaleForSize(view.bounds.size)
    }
    
    //4.讓圖片置中, 每次縮放之後會被呼叫
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        let imageViewSize = imageView.frame.size
        let scrollViewSize = scrollView.bounds.size
        
        let verticalPadding = imageViewSize.height < scrollViewSize.height ? (scrollViewSize.height - imageViewSize.height) / 2 : 0
        let horizontalPadding = imageViewSize.width < scrollViewSize.width ? (scrollViewSize.width - imageViewSize.width) / 2 : 0
        
        scrollView.contentInset = UIEdgeInsets(top: verticalPadding, left: horizontalPadding, bottom: verticalPadding, right: horizontalPadding)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

