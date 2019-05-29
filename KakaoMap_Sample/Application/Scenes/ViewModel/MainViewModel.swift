//
//  MainViewModel.swift
//  KakaoMap_Sample
//
//  Created by JHH on 28/05/2019.
//  Copyright © 2019 JHH. All rights reserved.
//

import Foundation

import Domain
import RxSwift
import RxCocoa

final class MainViewModel{
    
    private let useCase: FindPlaceUseCase
    private let navigator: MainNavigator
    let disposeBag = DisposeBag()
    
    init(useCase: FindPlaceUseCase, navigator: MainNavigator) {
        self.useCase   = useCase
        self.navigator = navigator
    }
}

// MARK: ViewModelType

extension MainViewModel: ViewModelType{
    struct Input {
        let categoryClickTrigger: Driver<CategoryCode>
        let refreshTrigger: Driver<Position>
        let currentLocation: Driver<Position>
        let refreshShowTrigger: Driver<Position>
        let loadMoreTrigger: Driver<Void>
        let selection : Driver<IndexPath>
    }
    
    struct Output {
        let markers         : Driver<[Position]>
        let placesViewModel : Driver<[PlaceItemViewModel]>
        let refreshShow     : Driver<Void>
        let moreButtonHidden: Driver<Bool>
        let isEmptyPlaces   : Driver<Void>
        let selectedPlace   : Driver<Place?>
    }
    
    
    func transform(input: Input) -> Output {
        var pageNumber       = 1
        let categoryCode     = BehaviorSubject<CategoryCode>(value: .hospital)
        let places           = BehaviorRelay<FindPlaces>(value: FindPlaces())
        let recentSearchInfo = PublishSubject<(Position,CategoryCode)>()
        let category         = input.categoryClickTrigger.withLatestFrom(input.currentLocation){ ($1,$0) }
        let refresh          = input.refreshTrigger.withLatestFrom(categoryCode.asDriverOnErrorJustComplete()){ ($0,$1) }
        let loadMore         = input.loadMoreTrigger.withLatestFrom(recentSearchInfo.asDriverOnErrorJustComplete()).do(onNext: { _ in  pageNumber += 1})
        let fetch            = Driver.merge(category,refresh).do(onNext: { _ in pageNumber = 1})
        
        input.categoryClickTrigger
            .drive(categoryCode)
            .disposed(by: self.disposeBag)
        
        category
            .drive(recentSearchInfo)
            .disposed(by: self.disposeBag)
        
        refresh
            .drive(recentSearchInfo)
            .disposed(by: self.disposeBag)
        
        fetch.flatMapLatest{ [weak self] (position, code) in
            self?.findPlace(code: code, position: position) ?? Driver.never()
            }.drive(places)
            .disposed(by: self.disposeBag)
        
        loadMore.debug("loadMoreTrigger")
            .flatMapLatest{ [weak self] (position, code) in
                self?.findPlace(code: code, position: position, page:pageNumber) ?? Driver.never()
            }.map{
                var newValue = places.value
                newValue.isEnd = $0.isEnd
                newValue.places?.append(contentsOf: $0.places!)
                return newValue
            }.drive(places)
            .disposed(by: self.disposeBag)
        
        let refreshShow = input.refreshShowTrigger
            .withLatestFrom(input.categoryClickTrigger)
            .mapToVoid()
        
        let markers = places.filter{ $0.places != nil }
            .map{
                $0.places!.map{
                    Position(x: $0.x, y: $0.y)
                }
        }
        
        let viewModel = places
            .debug("viewModel")
            .filter{ $0.places != nil }
            .map{ $0.places!.map{  PlaceItemViewModel(with: $0)  } }
        
        let selectedPlace = input.selection.withLatestFrom(places.asDriver()){ (indexPath, pl) -> Place? in
            return pl.places?[indexPath.row]
        }
        
        let moreButtonIsHidden = places.skip(1).map{
            return $0.isEnd ? true : false
        }
        
        let isEmptyPlaces = places
            .filter{ $0.places != nil }
            .filter{ $0.places?.count ?? 0 == 0 }
            .mapToVoid()
        
        return Output(markers: markers.asDriverOnErrorJustComplete(),
                      placesViewModel: viewModel.asDriverOnErrorJustComplete(),
                      refreshShow: refreshShow,
                      moreButtonHidden: moreButtonIsHidden.asDriverOnErrorJustComplete(),
                      isEmptyPlaces: isEmptyPlaces.asDriverOnErrorJustComplete(),
                      selectedPlace: selectedPlace)
    }
    
    private func findPlace(code: CategoryCode,
                           position: Position,
                           radius: Int = 500,
                           page: Int = 1,
                           size: Int = 15
                           )-> Driver<FindPlaces>
    {
        return self.useCase.findPlaceBy(categoryCode: code,
                                  position: position,
                                  radius: 200,
                                  page: page,
                                  size: 15).asDriverOnErrorJustComplete()
    }
}
