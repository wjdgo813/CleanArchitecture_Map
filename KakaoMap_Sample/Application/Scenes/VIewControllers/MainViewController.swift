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
    // MARK: - Properties
    
    private var viewModel: MainViewModel
    private let positionDriver = PublishSubject<Position>()
    
    private let findMapView: MainMapView = {
        let view = MainMapView()
        view.mapView.currentLocationTrackingMode = .onWithoutHeading
        return view
    }()
    
    init(viewModel: MainViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    
    override func setupUI() {
        self.view.addSubview(self.findMapView)
        self.layout()
    }
    
    override func setupBind() {
        self.findMapView.mapView.delegate = self
        let input = MainViewModel.Input(findPlaceTrigger: findMapView.categoryMarkerClickObservable.asDriverOnErrorJustComplete(),
                                        refresh: findMapView.refreshClickEvent.asDriverOnErrorJustComplete(),
                                        position: positionDriver.asDriverOnErrorJustComplete())
        
        let output = viewModel.transform(input: input)
    }
}

extension MainViewController{
    private func layout(){
        self.findMapView.snp.makeConstraints{
            $0.top.equalToSuperview()
            $0.left.equalToSuperview()
            $0.right.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }
}


extension MainViewController: MTMapViewDelegate{
    func mapView(_ mapView: MTMapView!, updateCurrentLocation location: MTMapPoint!, withAccuracy accuracy: MTMapLocationAccuracy) {
        let current = location.mapPointGeo()
        print("lat: \(current.latitude), long: \(current.longitude)")
        positionDriver.onNext(Position(x: "\(current.latitude)",
                                       y: "\(current.longitude)"))
    }
}
