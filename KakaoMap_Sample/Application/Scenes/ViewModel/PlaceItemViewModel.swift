//
//  PlaceItemViewModel.swift
//  KakaoMap_Sample
//
//  Created by JHH on 28/05/2019.
//  Copyright © 2019 JHH. All rights reserved.
//

import Foundation

import Domain

final class PlaceItemViewModel {
    let placeName: String
    let roadAddressName: String
    let place: Place
    init(with place:Place) {
        self.place = place
        self.placeName = place.placeName
        self.roadAddressName = place.roadAddressName
    }
}
