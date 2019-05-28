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
        
    }
    
    private let useCase: FindPlaceCase
    private let navigator: MainNavigator
    private let disposeBag = DisposeBag()
    
    init(useCase: FindPlaceCase, navigator: MainNavigator) {
        self.useCase   = useCase
        self.navigator = navigator
    }
    
    
    func transform(input: Input) -> Output {
        let places = input.findPlaceTrigger.debug("findPlaceTrigger").withLatestFrom(input.position){ ($0,$1) }.flatMapLatest{
            self.useCase.findPlaceBy(categoryCode: $0.0,
                                     position: $0.1,
                                     radius: 100,
                                     page: 1,
                                     size: 15).asDriverOnErrorJustComplete()
            }
        
        places.drive(onNext: { s in
            print("data : \(s)")
        }).disposed(by: self.disposeBag)
        
        return Output()
    }
}
