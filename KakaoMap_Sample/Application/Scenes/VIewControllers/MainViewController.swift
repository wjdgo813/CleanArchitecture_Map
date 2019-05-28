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

final class MainViewController: BaseViewController {
    // MARK: Properties
    
    private var viewModel: MainViewModel
    private let disposeBag = DisposeBag()
    private let myLocation = PublishSubject<Position>()
    
    // MARK: - UI Components
    
    private let findMapView: MainMapView = {
        let view = MainMapView()
        view.mapView.currentLocationTrackingMode = .onWithoutHeading
        return view
    }()
    
    private let tableVIew: UITableView = {
        let tb = UITableView(frame: CGRect.zero)
        tb.estimatedRowHeight = 100
        tb.rowHeight = UITableView.automaticDimension
        tb.insetsContentViewsToSafeArea = true
        tb.register(PlaceTableViewCell.self, forCellReuseIdentifier: "PlaceTableViewCell")
        return tb
    }()
    
    // MARK: Constructor
    
    init(viewModel: MainViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Overridden: BaseViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func setupUI() {
        self.view.addSubview(self.findMapView)
        self.view.addSubview(self.tableVIew)
        self.layout()
    }
    
    override func setupBind() {
        self.findMapView.mapView.delegate = self
        let input = MainViewModel.Input(findPlaceTrigger: findMapView.categoryMarkerClickObservable.asDriverOnErrorJustComplete(),
                                        refresh: findMapView.refreshClickEvent.asDriverOnErrorJustComplete(),
                                        position: myLocation.asDriverOnErrorJustComplete())
        
        let output = viewModel.transform(input: input)
        output.markers.drive(onNext: {
            self.drawMarker(positions: $0)
        }).disposed(by: self.disposeBag)
        
        output.placesViewModel
            .drive(self.tableVIew.rx.items(cellIdentifier: "PlaceTableViewCell", cellType: PlaceTableViewCell.self)){ tableView, viewModel, cell in
            cell.bind(viewModel)
        }.disposed(by: self.disposeBag)
    }
}

// MARK: Layout

extension MainViewController{
    private func layout(){
        self.findMapView.snp.makeConstraints{
            $0.top.equalToSuperview()
            $0.left.equalToSuperview()
            $0.right.equalToSuperview()
            $0.height.equalTo(self.view.snp.height).multipliedBy(0.5)
        }
        
        self.tableVIew.snp.makeConstraints{
            $0.left.equalToSuperview()
            $0.right.equalToSuperview()
            $0.bottom.equalTo(self.view.safeArea.bottom)
            $0.top.equalTo(self.findMapView.snp.bottom)
        }
    }
}


extension MainViewController: MTMapViewDelegate{
    func mapView(_ mapView: MTMapView!, updateCurrentLocation location: MTMapPoint!, withAccuracy accuracy: MTMapLocationAccuracy) {
        let current = location.mapPointGeo()
        print("lat: \(current.latitude), long: \(current.longitude)")
        myLocation.onNext(Position(x: "\(current.longitude)",
                                       y: "\(current.latitude)"))
    }
    
    func mapView(_ mapView: MTMapView!, dragStartedOn mapPoint: MTMapPoint!) {
        
    }
    
    
    private func drawMarker(positions:[Position]){
        var poiitemArr = [MTMapPOIItem]()
        for position in positions{
            let item = MTMapPOIItem()
            item.itemName = "ddd"
            item.markerType = .redPin
            item.showDisclosureButtonOnCalloutBalloon = true
            item.markerSelectedType = .redPin
            item.showAnimationType = .noAnimation
            item.mapPoint = MTMapPoint(geoCoord: MTMapPointGeo(latitude: Double(position.y) ?? 0.0,
                                                               longitude: Double(position.x) ?? 0.0))
            
            poiitemArr.append(item)
        }
        
        self.findMapView.mapView.addPOIItems(poiitemArr)
        self.findMapView.mapView.fitAreaToShowAllPOIItems()
    }
    
    /*
     _poiItem1 = [MTMapPOIItem poiItem];
     _poiItem1.itemName = @"Default Marker";
     _poiItem1.markerType = MTMapPOIItemMarkerTypeRedPin;
     _poiItem1.showDisclosureButtonOnCalloutBalloon = YES;
     
     _poiItem1.markerSelectedType = MTMapPOIItemMarkerSelectedTypeRedPin;
     
     _poiItem1.showAnimationType = MTMapPOIItemShowAnimationTypeDropFromHeaven;
     
     _poiItem1.mapPoint = [MTMapPoint mapPointWithGeoCoord:MTMapPointGeoMake(37.402110, 127.108451)];
     
     [_mapView addPOIItem:_poiItem1];
     [_mapView fitMapViewAreaToShowMapPoints:@[self.poiItem1.mapPoint]];
     */
}
