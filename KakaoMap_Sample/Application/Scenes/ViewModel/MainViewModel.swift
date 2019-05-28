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

final class MainViewModel: ViewModelType{
    
    struct Input {
        let findPlaceTrigger: Driver<CategoryCode>
        let refresh: Driver<Void>
        let position: Driver<Position>
    }
    
    struct Output {
        let markers: Driver<[Position]>
        let placesViewModel: Driver<[PlaceItemViewModel]>
    }
    
    private let useCase: FindPlaceCase
    private let navigator: MainNavigator
    private let disposeBag = DisposeBag()//테스트 용
    
    init(useCase: FindPlaceCase, navigator: MainNavigator) {
        self.useCase   = useCase
        self.navigator = navigator
    }
    
    
    func transform(input: Input) -> Output {
        let places = input.findPlaceTrigger
            .withLatestFrom(input.position){ ($0,$1) }
            .flatMapLatest{ [weak self] (code, position) in
                self?.useCase.findPlaceBy(categoryCode: code,
                                         position: position,
                                         radius: 100,
                                         page: 1,
                                         size: 15).asDriverOnErrorJustComplete() ?? Driver.never()
            }
        
        let markers = places.filter{ $0.places != nil }
            .map{
                $0.places!.map{
                    Position(x: $0.x, y: $0.y)
                }
        }
        
        let viewModel = places
            .filter{ $0.places != nil }
            .map{ $0.places!.map{  PlaceItemViewModel(with: $0)  } }
        
        
        return Output(markers: markers.asDriver(), placesViewModel: viewModel)
    }
}
