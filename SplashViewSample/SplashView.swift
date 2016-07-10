//
//  SplashView.swift
//  aircleaner
//
//  Created by Kooze on 16/7/7.
//  Copyright © 2016年 purisen. All rights reserved.
//

import UIKit

class SplashView: UIView {
    
    // const
    static let IMG_URL = "splash_img_url"
    static let ACT_URL = "splash_act_url"
    static let IMG_PATH = String(format: "%@/Documents/splash_image.jpg", NSHomeDirectory())
    
    // in portrait mode
    let screenWidth = UIScreen.mainScreen().bounds.size.width
    let screenHeight = UIScreen.mainScreen().bounds.size.height
    let statusHeight = UIApplication.sharedApplication().statusBarFrame.height
    
    let buttonSize: CGFloat = 36.0
    let buttonMargin: CGFloat = 16.0
    
    var durationTime: Int = 6 {
        didSet {
            skipButton?.setTitle("跳过\n\(durationTime) s", forState: .Normal)
        }
    }
    
    // data
    var imageUrl: String?
    var actionUrl: String?
    var timer: NSTimer?
    
    var tapSplashImageBlock: ((actionUrl: String?) -> Void)?
    var splashViewDissmissBlock: ((initiativeDismiss: Bool) -> Void)?
    
    // views
    var imageView: UIImageView?
    var skipButton: UIButton?
    
    init() {
        super.init(frame: CGRectMake(0, 0, screenWidth, screenHeight))
        initComponents()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // call this method at least in viewDidAppear func  
    class func showSplashView(duration: Int = 6,
                              defaultImage: UIImage?,
                              tapSplashImageBlock: ((actionUrl: String?) -> Void)?,
                              splashViewDismissBlock: ((initiativeDismiss: Bool) -> Void)?) {
        if isExistsSplashData() {
            let splashView = SplashView()
            splashView.tapSplashImageBlock = tapSplashImageBlock
            splashView.splashViewDissmissBlock = splashViewDismissBlock
            splashView.durationTime = duration
            UIApplication.sharedApplication().delegate?.window!!.addSubview(splashView)
        } else if let _defaultImage = defaultImage {
            let splashView = SplashView()
            splashView.tapSplashImageBlock = tapSplashImageBlock
            splashView.splashViewDissmissBlock = splashViewDismissBlock
            splashView.durationTime = duration
            splashView.imageView?.image = _defaultImage
            UIApplication.sharedApplication().delegate?.window!!.addSubview(splashView)
        }
    }
    
    class func simpleShowSplashView() {
        showSplashView(defaultImage: nil, tapSplashImageBlock: nil, splashViewDismissBlock: nil)
    }
    
    func initComponents() {
        // init data
        imageUrl = NSUserDefaults.standardUserDefaults().valueForKey(SplashView.IMG_URL) as? String
        actionUrl = NSUserDefaults.standardUserDefaults().valueForKey(SplashView.ACT_URL) as? String
        
        // initViews
        self.backgroundColor = UIColor.whiteColor()
        
        imageView = UIImageView(frame: CGRectMake(0, 0, screenWidth, screenHeight))
        imageView?.userInteractionEnabled = true
        let recognize = UITapGestureRecognizer(target: self, action: #selector(tapImageAction))
        imageView?.addGestureRecognizer(recognize)
        imageView?.image = UIImage(contentsOfFile: SplashView.IMG_PATH)
        self.addSubview(imageView!)
        
        skipButton = UIButton(frame: CGRectMake(screenWidth - buttonSize - buttonMargin,
            buttonMargin + statusHeight, buttonSize, buttonSize))
        skipButton?.layer.cornerRadius = buttonSize / 2
        skipButton?.clipsToBounds = true
        skipButton?.backgroundColor = UIColor(red: 0.3, green: 0.3, blue: 0.3, alpha: 0.3)
        skipButton?.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        skipButton?.titleLabel?.font = UIFont.systemFontOfSize(10)
        skipButton?.titleLabel?.textAlignment = .Center
        skipButton?.titleLabel?.numberOfLines = 2
        skipButton?.setTitle("跳过\n\(durationTime) s", forState: .Normal)
        skipButton?.addTarget(self, action: #selector(skipAction), forControlEvents: .TouchUpInside)
        self.addSubview(skipButton!)
        
        setupTimer()
    }
    
    func tapImageAction() {
        if let _tapSplashImageBlock = self.tapSplashImageBlock {
            self.skipAction()
            _tapSplashImageBlock(actionUrl: self.actionUrl)
        }
    }
    
    
    func skipAction() {
        dismissSplashView(true)
    }
    
    func setupTimer() {
        timer = NSTimer.scheduledTimerWithTimeInterval(1.0,
                                                       target: self,
                                                       selector: #selector(timerCycleAction),
                                                       userInfo: nil,
                                                       repeats: true)
    }
    
    func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    func timerCycleAction() {
        if 0 == durationTime {
            dismissSplashView(false)
        } else {
            durationTime -= 1
        }
    }
    
    func dismissSplashView(initiativeDismiss: Bool) {
        
        stopTimer()
        UIView.animateWithDuration(0.6,
                                   animations: {
                                    self.alpha = 0.0
                                    self.transform = CGAffineTransformMakeScale(1.5, 1.5)
            },
                                   completion: {(finished) -> Void in
                                    self.removeFromSuperview()
                                    if let _splashViewDissmissBlock = self.splashViewDissmissBlock {
                                        _splashViewDissmissBlock(initiativeDismiss: initiativeDismiss)
                                    }
        })
    }
    
    class func isExistsSplashData() -> Bool{
        let latestImgUrl = NSUserDefaults.standardUserDefaults().valueForKey(IMG_URL) as? String
        let isFileExists = NSFileManager.defaultManager().fileExistsAtPath(IMG_PATH)
        
        return nil != latestImgUrl && isFileExists
    }
    
    class func updateSplashData(imgUrl: String?, actUrl: String?) {
        if nil == imgUrl {
            // no data
            return
        }
        
        NSUserDefaults.standardUserDefaults().setValue(imgUrl, forKey: IMG_URL)
        NSUserDefaults.standardUserDefaults().setValue(actUrl, forKey: ACT_URL)
        NSUserDefaults.standardUserDefaults().synchronize()
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), {
            let imageURL = NSURL(string: imgUrl!)
            if let _imageURL = imageURL {
                let data = NSData(contentsOfURL: _imageURL)
                if let _data = data {
                    let image = UIImage(data: _data)
                    if let _image = image {
                        UIImagePNGRepresentation(_image)?.writeToFile(IMG_PATH, atomically: true)
                    }
                }
                
            }
        })
    }
}
