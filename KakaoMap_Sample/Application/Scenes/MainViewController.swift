//
//  ViewController.swift
//  KakaoMap_Sample
//
//  Created by Haehyeon Jeong on 26/05/2019.
//  Copyright © 2019 JHH. All rights reserved.
//

import UIKit


class MainViewController: BaseViewController {
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let mapView = MTMapView(frame: self.view.frame)
        mapView.delegate = self
        mapView.baseMapType = .standard
        self.view.addSubview(mapView)
    }
}


extension MainViewController: MTMapViewDelegate{
    
}
