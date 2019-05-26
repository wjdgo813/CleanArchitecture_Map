//
//  FindPlaceCase.swift
//  KakaoMap_Sample
//
//  Created by Haehyeon Jeong on 26/05/2019.
//  Copyright © 2019 JHH. All rights reserved.
//

import Foundation

import RxSwift

protocol FindPlaceCase {
    func findPlaceBy(categoryCode:CategoryCode,
                     position: Position,
                     radius:Int,
                     page: Int ,
                     size: Int) -> Observable<Data>
}
