//
//  BaseView.swift
//  KakaoMap_Sample
//
//  Created by JHH on 27/05/2019.
//  Copyright © 2019 JHH. All rights reserved.
//

import UIKit

class BaseView: UIView {
    // MARK: Properties
    weak var vc: BaseViewController!
    
    // MARK: Initialize
    required init(controlBy viewController: BaseViewController) {
        vc = viewController
        super.init(frame: UIScreen.main.bounds)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        //Override
    }

    deinit {
        
    }
}
