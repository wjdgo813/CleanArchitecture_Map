//
//  UseCaseProvider.swift
//  KakaoMap_Sample
//
//  Created by JHH on 27/05/2019.
//  Copyright © 2019 JHH. All rights reserved.
//

import Foundation

import Domain

public final class UseCaseProvider: Domain.UseCaseProvider{
    public init(){ }
    
    public func makeFindPlaceUseCase() -> Domain.FindPlaceUseCase{
        return FindPlaceUseCase()
    }
}
