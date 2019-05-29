//
//  ViewController.swift
//  KakaoMap_Sample
//
//  Created by Haehyeon Jeong on 26/05/2019.
//  Copyright © 2019 JHH. All rights reserved.
//

import UIKit

import Domain
import SnapKit
import RxSwift
import RxCocoa

final class MainViewController: BaseViewController, CanShowAlert {
    // MARK: Properties
    
    private var viewModel: MainViewModel
    private let currentLocation = PublishSubject<Position>()
    private let gestureLocation = PublishSubject<Position>()
    private var disposeBag: DisposeBag{
        return viewModel.disposeBag
    }
    
    // MARK: - UI Components
    
    private let findMapView: MainMapView = {
        let view = MainMapView()
        return view
    }()
    
    private let tableView: UITableView = {
        let tb = UITableView(frame: CGRect.zero,style: .grouped)
        tb.estimatedRowHeight = 100
        tb.rowHeight = UITableView.automaticDimension
        tb.insetsContentViewsToSafeArea = true
        tb.register(PlaceTableViewCell.self, forCellReuseIdentifier: "PlaceTableViewCell")
        var frame = CGRect.zero
        frame.size.height = .leastNormalMagnitude
        tb.tableHeaderView = UIView(frame: frame)
        return tb
    }()
    
    private let moreLoadButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("더보기", for: .normal)
        button.backgroundColor = .white
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.borderWidth = 1
        button.isHidden = true
        return button
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
        self.title = "KAKAO MAP"
        self.view.addSubview(self.findMapView)
        self.view.addSubview(self.tableView)
        self.layout()
    }
    
    override func setupBind() {
        self.bindView()
        self.bindViewModel()
    }
    
    private func bindView(){
        self.tableView.delegate = self
        self.findMapView.mapView.delegate = self
    }

    private func bindViewModel(){
        let input = MainViewModel.Input(categoryClickTrigger: self.findMapView.categoryMarkerClickObservable.asDriverOnErrorJustComplete(),
                                        refreshTrigger: self.findMapView.refreshClickEvent.asDriverOnErrorJustComplete(),
                                        currentLocation: self.currentLocation.asDriverOnErrorJustComplete(),
                                        refreshShowTrigger: self.gestureLocation.asDriverOnErrorJustComplete(),
                                        loadMoreTrigger: self.moreLoadButton.rx.tap.asDriver(),
                                        selection: self.tableView.rx.itemSelected.asDriver())
        
        let output = viewModel.transform(input: input)
        output.markers.drive(onNext: { [weak self] positions in
            self?.showList()
            self?.drawMarker(positions: positions)
        }).disposed(by: self.disposeBag)
        
        output.placesViewModel
            .drive(self.tableView.rx.items(cellIdentifier: "PlaceTableViewCell", cellType: PlaceTableViewCell.self)){ tableView, viewModel, cell in
                cell.bind(viewModel)
            }.disposed(by: self.disposeBag)
        
        output.refreshShow.drive(onNext:{ [weak self] in
            self?.findMapView.refreshButton.isHidden = false
        }).disposed(by: self.disposeBag)
        
        output.moreButtonHidden.debug("moreButtonHidden")
            .drive(onNext: {
                self.moreLoadButton.isHidden = $0
            }).disposed(by: self.disposeBag)
        
        output.isEmptyPlaces.drive(onNext:{ [weak self] in
            self?.showAlert(title:"알림",message:"주변에 찾으시는 장소가 없습니다.")
            self?.hideList()
        }).disposed(by:self.disposeBag)
        
        output.selectedPlace.drive(onNext: { [weak self] place in
            guard let place = place else { return }
            let mapPoint = MTMapPoint(geoCoord: MTMapPointGeo(latitude: Double(place.y) ?? 0.0,
                                                              longitude: Double(place.x) ?? 0.0))
            self?.findMapView.mapView.setMapCenter(mapPoint, animated: true)
        }).disposed(by: self.disposeBag)
    }
    
}

// MARK: Layout

extension MainViewController{
    private func layout(){
        self.findMapView.snp.makeConstraints{
            $0.top.equalToSuperview()
            $0.left.equalToSuperview()
            $0.right.equalToSuperview()
            $0.height.equalTo(self.view.snp.height)
        }
        
        self.tableView.snp.makeConstraints{
            $0.left.equalToSuperview()
            $0.right.equalToSuperview()
            $0.bottom.equalTo(self.view.safeArea.bottom)
            $0.top.equalTo(self.findMapView.snp.bottom)
        }
    }
}

// MARK: UITableViewDelegate

extension MainViewController{
    private func showList(){
        UIView.animate(withDuration: 0.4) {
            self.findMapView.snp.remakeConstraints{
                $0.top.equalToSuperview()
                $0.left.equalToSuperview()
                $0.right.equalToSuperview()
                $0.height.equalTo(self.view.snp.height).multipliedBy(0.5)
            }
            
            self.view.layoutIfNeeded()
        }
    }
    
    private func hideList(){
        UIView.animate(withDuration: 0.4) {
            self.findMapView.snp.remakeConstraints{
                $0.top.equalToSuperview()
                $0.left.equalToSuperview()
                $0.right.equalToSuperview()
                $0.height.equalTo(self.view.snp.height)
            }
            
            self.view.layoutIfNeeded()
        }
    }
}

// MARK: MTMapViewDelegate

extension MainViewController: MTMapViewDelegate{
    func mapView(_ mapView: MTMapView!, updateCurrentLocation location: MTMapPoint!, withAccuracy accuracy: MTMapLocationAccuracy) {
        let current = location.mapPointGeo()
        self.currentLocation.onNext(Position(x: "\(current.longitude)",
                                       y: "\(current.latitude)"))
    }
    
    func mapView(_ mapView: MTMapView!, dragStartedOn mapPoint: MTMapPoint!) {
        let map = mapPoint.mapPointGeo()
        self.gestureLocation.onNext(Position(x: "\(map.latitude)",
                                             y: "\(map.longitude)"))
    }
    
    func mapView(_ mapView: MTMapView!, selectedPOIItem poiItem: MTMapPOIItem!) -> Bool {
        mapView.setMapCenter(poiItem.mapPoint, animated: true)
        return false
    }
    
    
    private func drawMarker(positions:[Position]){
        var poiitemArr = [MTMapPOIItem]()
        for position in positions{
            let item = MTMapPOIItem()
            item.markerType = .yellowPin
            item.showDisclosureButtonOnCalloutBalloon = true
            item.markerSelectedType = .redPin
            item.showAnimationType = .springFromGround
            item.mapPoint = MTMapPoint(geoCoord: MTMapPointGeo(latitude: Double(position.y) ?? 0.0,
                                                               longitude: Double(position.x) ?? 0.0))
            
            poiitemArr.append(item)
        }
        
        self.findMapView.mapView.addPOIItems(poiitemArr)
        self.findMapView.mapView.fitAreaToShowAllPOIItems()
    }
}

// MARK: UITableViewDelegate

extension MainViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let containerView = UIView()
        containerView.addSubview(self.moreLoadButton)
        self.moreLoadButton.snp.makeConstraints{
            $0.top.equalToSuperview()
            $0.left.equalToSuperview()
            $0.right.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
        return containerView
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if self.moreLoadButton.isHidden{
            return 0
        }
        return 50
    }
}
