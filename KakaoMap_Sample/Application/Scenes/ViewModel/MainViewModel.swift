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
        let position: Driver<Position>
    }
    
    struct Output {
        let markers: Driver<[Position]>
        let placesViewModel: Driver<[PlaceItemViewModel]>
    }
    
    
    func transform(input: Input) -> Output {
        let categoryCode = BehaviorSubject<CategoryCode>(value: .hospital)
        let places       = PublishSubject<FindPlaces>()
        
        input.findPlaceTrigger
            .drive(categoryCode)
            .disposed(by: self.disposeBag)
        
        input.findPlaceTrigger
            .distinctUntilChanged()
            .withLatestFrom(input.position){ ($0,$1) }
            .debug("findPlaceTrigger")
            .flatMapLatest{ [weak self] (code, position) in
                self?.useCase.findPlaceBy(categoryCode: code,
                                          position: position,
                                          radius: 2000,
                                          page: 1,
                                          size: 15).asDriverOnErrorJustComplete() ?? Driver.never()
        }.drive(places)
        .disposed(by: self.disposeBag)
        
        input.refresh
            .withLatestFrom(categoryCode.asDriverOnErrorJustComplete()){ ($0,$1) }
            .debug("refresh")
            .flatMapLatest{ [weak self] (position, code) in
                self?.useCase.findPlaceBy(categoryCode: code,
                                          position: position,
                                          radius: 2000,
                                          page: 1,
                                          size: 15).asDriverOnErrorJustComplete() ?? Driver.never()
        }.drive(places)
        .disposed(by: self.disposeBag)
        
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
                      placesViewModel: viewModel.asDriverOnErrorJustComplete())
    }
}
