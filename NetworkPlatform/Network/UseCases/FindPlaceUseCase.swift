//
//  FindPlaceUseCase.swift
//  KakaoMap_Sample
//
//  Created by Haehyeon Jeong on 26/05/2019.
//  Copyright © 2019 JHH. All rights reserved.
//

import Foundation

import Domain
import Alamofire
import RxSwift


final class FindPlaceUseCase: FindPlaceCase{
    private let network: Network
    init(){
        self.network = Network()
    }
    
    func findPlaceBy(categoryCode: CategoryCode = .gasStation,
                    position: Position,
                    radius : Int = 50,
                    page: Int = 1,
                    size: Int = 15) -> Observable<FindPlaces> {
        return network.rxJSONObservable(FindPlaceService.findPlaceBy(categoryCode: categoryCode,
                                                                     position: position,
                                                                     radius: radius,
                                                                     page: page,
                                                                     size: size)).map{
                                                                        return try JSONDecoder().decode(FindPlaces.self, from: $0)
        }
    }
}
