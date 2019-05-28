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
    
    // MARK: - Properties
    
    lazy var categoryMarkerClickObservable: Observable<CategoryCode> = {
        return Observable.merge(self.hospitalButton.rx.tap.map{ _ in CategoryCode.hospital },
                                self.drugStoreButton.rx.tap.map{ _ in CategoryCode.drugStore },
                                self.gasStationButton.rx.tap.map{ _ in CategoryCode.gasStation }).do(onNext: { _ in
                                    self.mapView.removeAllPOIItems()
                                })
    }()
    
    lazy var refreshClickEvent: Observable<Position> = {
        return self.refreshButton.rx.tap
            .map{ _ in
                Position(x: "\(self.mapView.mapCenterPoint.mapPointGeo().longitude)",
                         y: "\(self.mapView.mapCenterPoint.mapPointGeo().latitude)") }
            .do(onNext: { _ in
                self.mapView.removeAllPOIItems()
            })
    }()
    
    // MARK: - UI Components
    
    let mapView: MTMapView = {
        let mv = MTMapView(frame: CGRect.zero)
        mv.baseMapType = .standard
        let markerItem = MTMapLocationMarkerItem()
        markerItem.radius = 10
        markerItem.fillColor = .red
        markerItem.strokeColor = .white
        mv.updateCurrentLocationMarker(markerItem)
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
        return button
    }()
    
    private let drugStoreButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("약국", for: .normal)
        button.backgroundColor = .white
        return button
    }()
    
    private let gasStationButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("주유소", for: .normal)
        button.backgroundColor = .white
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
            $0.right.equalTo(self.safeArea.right).offset(-10)
            $0.bottom.equalTo(self.safeArea.bottom).offset(-10)
        }
    }
}

