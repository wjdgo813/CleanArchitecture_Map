//
//  UseCaseProvider.swift
//  KakaoMap_Sample
//
//  Created by JHH on 27/05/2019.
//  Copyright © 2019 JHH. All rights reserved.
//

import Foundation

import Domain

public final class NetworkUseCaseProvider: Domain.UseCaseProvide{
    public init(){
        
    }
    
    public func makeFindPlaceUseCase() -> FindPlaceCase{
        return FindPlaceUseCase()
    }
}
