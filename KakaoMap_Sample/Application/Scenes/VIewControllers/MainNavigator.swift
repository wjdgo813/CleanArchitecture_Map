//
//  DefaultMainNavigator.swift
//  KakaoMap_Sample
//
//  Created by JHH on 27/05/2019.
//  Copyright © 2019 JHH. All rights reserved.
//

import Foundation

import Domain

protocol MainNavigator {
    func toMain()
}

final class DefaultMainNavigator: MainNavigator{
    private let services: UseCaseProvide
    private let navigationController: UINavigationController
    
    init(services: UseCaseProvide,
         navigationController: UINavigationController){
        self.services = services
        self.navigationController = navigationController
    }
    
    func toMain(){
        let vc = MainViewController(viewModel: MainViewModel(useCase: self.services.makeFindPlaceUseCase(),
                                                             navigator: self))
        self.navigationController.setViewControllers([vc], animated: true)
    }
}
