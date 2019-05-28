//
//  Rx+.swift
//  KakaoMap_Sample
//
//  Created by JHH on 28/05/2019.
//  Copyright © 2019 JHH. All rights reserved.
//

import Foundation

import RxCocoa
import RxSwift

extension ObservableType {
    func asDriverOnErrorJustComplete() -> Driver<Element> {
        return asDriver { error in
            return Driver.empty()
        }
    }
    
    func mapToVoid() -> Observable<Void> {
        return map { _ in }
    }
}

extension SharedSequenceConvertibleType {
    func mapToVoid() -> SharedSequence<SharingStrategy, Void> {
        return map { _ in }
    }
}

public extension BehaviorRelay where Element: RangeReplaceableCollection {
    func append(contentsOf subelements: Element) {
        var newValue = value
        newValue.append(contentsOf: subelements)
        accept(newValue)
    }
}
