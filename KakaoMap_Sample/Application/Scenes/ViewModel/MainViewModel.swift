//
//  MainViewModel.swift
//  KakaoMap_Sample
//
//  Created by JHH on 28/05/2019.
//  Copyright © 2019 JHH. All rights reserved.
//

import Foundation

import RxSwift
import RxCocoa

final class MainViewModel{
    
    private let useCase: FindPlaceCase
    private let navigator: MainNavigator
    private let disposeBag = DisposeBag()
    
    init(useCase: FindPlaceCase, navigator: MainNavigator) {
        self.useCase   = useCase
        self.navigator = navigator
    }
}

// MARK: ViewModelType

extension MainViewModel: ViewModelType{
    struct Input {
        let findPlaceTrigger: Driver<CategoryCode>
        let refresh: Driver<Position>
        let currentLocation: Driver<Position>
        let refreshShowTrigger: Driver<Position>
    }
    
    struct Output {
        let markers: Driver<[Position]>
        let placesViewModel: Driver<[PlaceItemViewModel]>
        let refreshShow: Driver<Void>
    }
    
    
    func transform(input: Input) -> Output {
        let categoryCode = BehaviorSubject<CategoryCode>(value: .hospital)
        let places       = PublishSubject<FindPlaces>()
        
        input.findPlaceTrigger
            .drive(categoryCode)
            .disposed(by: self.disposeBag)
        
        input.findPlaceTrigger
            .withLatestFrom(input.currentLocation){ ($0,$1) }
            .debug("findPlaceTrigger")
            .flatMapLatest{ [weak self] (code, position) in
                self?.findPlace(code: code, position: position) ?? Driver.never()
        }.drive(places)
        .disposed(by: self.disposeBag)
        
        input.refresh
            .withLatestFrom(categoryCode.asDriverOnErrorJustComplete()){ ($0,$1) }
            .debug("refresh")
            .flatMapLatest{ [weak self] (position, code) in
                self?.findPlace(code: code, position: position) ?? Driver.never()
        }.drive(places)
        .disposed(by: self.disposeBag)
        
        let refreshShow = input.refreshShowTrigger
            .withLatestFrom(input.findPlaceTrigger)
            .mapToVoid()
        
        let markers = places.filter{ $0.places != nil }
            .map{
                $0.places!.map{
                    Position(x: $0.x, y: $0.y)
                }
        }
        
        let viewModel = places
            .filter{ $0.places != nil }
            .map{ $0.places!.map{  PlaceItemViewModel(with: $0)  } }
        
        
        return Output(markers: markers.asDriverOnErrorJustComplete(),
                      placesViewModel: viewModel.asDriverOnErrorJustComplete(),
                      refreshShow: refreshShow)
    }
    
    private func findPlace(code: CategoryCode,
                           position: Position,
                           radius: Int = 300,
                           page: Int = 1,
                           size: Int = 15
                           )-> Driver<FindPlaces>
    {
        return self.useCase.findPlaceBy(categoryCode: code,
                                  position: position,
                                  radius: 300,
                                  page: 1,
                                  size: 15).asDriverOnErrorJustComplete()
    }
}
