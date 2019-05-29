//
//  UseCaseProvide.swift
//  KakaoMap_Sample
//
//  Created by Haehyeon Jeong on 26/05/2019.
//  Copyright © 2019 JHH. All rights reserved.
//

import Foundation

public protocol UseCaseProvider{
   func makeFindPlaceUseCase() -> FindPlaceUseCase
}
