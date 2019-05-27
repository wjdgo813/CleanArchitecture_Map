//
//  UseCaseProvider.swift
//  KakaoMap_Sample
//
//  Created by JHH on 27/05/2019.
//  Copyright © 2019 JHH. All rights reserved.
//

import Foundation

final class NetworkUseCaseProvider: UseCaseProvide{
    func makeFindPlaceUseCase() -> FindPlaceCase{
        return FindPlaceUseCase()
    }
}
