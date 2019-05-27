//
//  MainMapView.swift
//  KakaoMap_Sample
//
//  Created by JHH on 27/05/2019.
//  Copyright © 2019 JHH. All rights reserved.
//

import Foundation

import SnapKit
import RxCocoa
import RxSwift

final class MainMapView: BaseView{
    
    // MARK: - UI Components
    
    let mapView: MTMapView = {
        let mv = MTMapView(frame: CGRect.zero)
        mv.baseMapType = .standard
        let makerItem = MTMapLocationMarkerItem()
        makerItem.radius = 10
        makerItem.fillColor = .red
        makerItem.strokeColor = .white
        mv.updateCurrentLocationMarker(makerItem)
        return mv
    }()
    
    private let categoryStackView: UIStackView = {
        let stackView  = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        stackView.alignment    = .leading
        stackView.spacing      = 5
        return stackView
    }()
    
    private let hospitalButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("병원", for: .normal)
        button.backgroundColor = .white
        button.tag = 1
        return button
    }()
    
    private let drugStoreButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("약국", for: .normal)
        button.backgroundColor = .white
        button.tag = 2
        return button
    }()
    
    private let gasStationButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("주유소", for: .normal)
        button.backgroundColor = .white
        button.tag = 3
        return button
    }()
    
    private let refreshButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("새로고침", for: .normal)
        button.backgroundColor = .white
        return button
    }()
    
    override func setupUI() {
        self.addSubview(self.mapView)
        self.addSubview(self.categoryStackView)
        self.addSubview(self.refreshButton)
        
        self.categoryStackView.addArrangedSubview(self.hospitalButton)
        self.categoryStackView.addArrangedSubview(self.drugStoreButton)
        self.categoryStackView.addArrangedSubview(self.gasStationButton)
        self.layout()
    }
}

// MARK: layout

extension MainMapView{
    private func layout(){
        self.mapView.snp.makeConstraints{
            $0.top.equalToSuperview()
            $0.left.equalToSuperview()
            $0.right.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
        
        self.refreshButton.snp.makeConstraints{
            $0.top.equalTo(self.safeArea.top).offset(10)
            $0.centerX.equalToSuperview()
        }
        
        self.categoryStackView.snp.makeConstraints{
            $0.right.equalToSuperview().offset(-10)
            $0.bottom.equalToSuperview().offset(-10)
        }
    }
}
