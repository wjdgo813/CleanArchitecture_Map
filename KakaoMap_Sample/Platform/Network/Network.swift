//
//  Network.swift
//  KakaoMap_Sample
//
//  Created by Haehyeon Jeong on 26/05/2019.
//  Copyright © 2019 JHH. All rights reserved.
//

import Foundation

import Alamofire
import RxSwift

final class Network{
    func rxJSONObservable(_ url: URLRequestConvertible)->Observable<Data>{
        return Observable.create{ emit in
            Alamofire.request(url).responseJSON(completionHandler: { response in
                print("result : \(response.value ?? "")")
                switch response.result{
                case .success(_):
                    if let data = response.data {
                        emit.onNext(data)
                    }
                    emit.onCompleted()
                case .failure(let error):
                    emit.onError(error)
                }
            })
            return Disposables.create()
        }
    }
}
