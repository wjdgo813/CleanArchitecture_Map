//
//  AppDelegate.swift
//  KakaoMap_Sample
//
//  Created by Haehyeon Jeong on 26/05/2019.
//  Copyright © 2019 JHH. All rights reserved.
//

import UIKit

let appDelegate = UIApplication.shared.delegate as? AppDelegate
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let window = UIWindow(frame: UIScreen.main.bounds)
        self.window = window
        Application.shared.configureMainInterface(in: window)

        return true
    }
    
    private func searchFrontViewController(_ viewController : UIViewController)->UIViewController{
        var vc = viewController
        if let presentVC = viewController.presentedViewController {
            vc = self.searchFrontViewController(presentVC)
        }
        return vc
    }
    
    func searchFrontViewController()->UIViewController{
        var vc = appDelegate?.window?.rootViewController
        vc = self.searchFrontViewController(vc!)
        return vc!
    }
}

