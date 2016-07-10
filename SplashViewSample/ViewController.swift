//
//  ViewController.swift
//  SplashViewSample
//
//  Created by jkyeo on 16/7/10.
//  Copyright © 2016年 jkyeo. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        SplashView.updateSplashData("http://ww2.sinaimg.cn/large/72f96cbagw1f5mxjtl6htj20g00sg0vn.jpg", actUrl: "http://jkyeo.com")
    }
    
    override func viewDidAppear(animated: Bool) {
        SplashView.showSplashView(defaultImage: UIImage(named: "default_img"),
                                  tapSplashImageBlock: {(actionUrl) -> Void in
                                    print("splash image taped, actionUrl optional: \(actionUrl)")
            },
                                  splashViewDismissBlock: { (initiativeDismiss) in
                                    print("splash view dismissed, initiativeDismiss optional: \(initiativeDismiss)")
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

