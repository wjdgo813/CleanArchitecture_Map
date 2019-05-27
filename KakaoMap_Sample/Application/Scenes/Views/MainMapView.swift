//
//  MainMapView.swift
//  KakaoMap_Sample
//
//  Created by JHH on 27/05/2019.
//  Copyright © 2019 JHH. All rights reserved.
//

import Foundation

import SnapKit

final class MainMapView: BaseView{
    let mapView: MTMapView = {
        let mv = MTMapView(frame: CGRect.zero)
        mv.baseMapType = .standard
        return mv
    }()
    
    override func setupUI() {
        self.addSubview(self.mapView)
        self.layout()
    }
}


extension MainMapView{
    private func layout(){
        self.mapView.snp.makeConstraints{
            $0.top.equalToSuperview()
            $0.left.equalToSuperview()
            $0.right.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }
}
