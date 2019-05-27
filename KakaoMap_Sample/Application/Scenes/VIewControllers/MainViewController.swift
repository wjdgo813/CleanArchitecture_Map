//
//  ViewController.swift
//  KakaoMap_Sample
//
//  Created by Haehyeon Jeong on 26/05/2019.
//  Copyright © 2019 JHH. All rights reserved.
//

import UIKit

import SnapKit
import RxSwift
import RxCocoa
import RxDataSources

final class MainViewController: BaseViewController {
    private let findMapView: MainMapView = {
        let view = MainMapView()
        return view
    }()
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        let mapView = MTMapView(frame: self.view.frame)
//        mapView.delegate = self
//        mapView.baseMapType = .standard
//        self.view.addSubview(mapView)
    }
    
    
    override func setupUI() {
        self.view.addSubview(self.findMapView)
        self.layout()
    }
}


extension MainViewController: MTMapViewDelegate{
    private func layout(){
        self.findMapView.snp.makeConstraints{
            $0.top.equalToSuperview()
            $0.left.equalToSuperview()
            $0.right.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }
}
