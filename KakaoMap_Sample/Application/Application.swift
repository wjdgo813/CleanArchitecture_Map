//
//  Application.swift
//  KakaoMap_Sample
//
//  Created by JHH on 27/05/2019.
//  Copyright © 2019 JHH. All rights reserved.
//

import Foundation

import Domain
import NetworkPlatform

final class Application{
    static let shared = Application()
    private let networkUseCaseProvider: Domain.UseCaseProvide
    
    private init(){
        self.networkUseCaseProvider = NetworkPlatform.NetworkUseCaseProvider()
    }
    
    func configureMainInterface(in window:UIWindow){
        let navigationController = UINavigationController()
        let navigator = DefaultMainNavigator(services: self.networkUseCaseProvider,
                                             navigationController: navigationController)
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        navigator.toMain()
        
    }
    
}
