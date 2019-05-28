//
//  FindPlaceService.swift
//  KakaoMap_Sample
//
//  Created by Haehyeon Jeong on 26/05/2019.
//  Copyright © 2019 JHH. All rights reserved.
//

import Foundation

import Alamofire
import Domain

enum FindPlaceService: URLRequestConvertible{
    case findPlaceBy(categoryCode:CategoryCode, position: Position, radius:Int, page: Int , size: Int)
    
    func asURLRequest() throws -> URLRequest {
        let url = self.url
        var urlRequest = URLRequest(url: url.appendingPathComponent(self.path))
        urlRequest.httpMethod = self.method.rawValue
        urlRequest.setValue("KakaoAK 8a11d49c1a56ac7784ca743cb8341a0f", forHTTPHeaderField: "Authorization")
        do {
            urlRequest = try URLEncoding.default.encode(urlRequest, with: parameter)
        } catch {
            throw AFError.parameterEncodingFailed(reason: .jsonEncodingFailed(error: error))
        }

        return urlRequest
    }
    
    private var url: URL{
        switch self {
        default:
            return URL(string: "https://dapi.kakao.com/v2/local/search")!
        }
    }
    
    private var method: HTTPMethod{
        switch self {
        case .findPlaceBy(_,_,_,_,_):
            return .get
        }
    }
    
    
    private var path: String{
        switch self {
        case .findPlaceBy(_,_,_,_,_):
            return "/category.json"
        }
    }
    
    private var parameter: Parameters{
        var param: Parameters = [:]
        
        switch self {
        case .findPlaceBy(let categoryCode,
                          let position,
                          let radius,
                          let page,
                          let size):
            param["category_group_code"] = categoryCode.rawValue
            param["x"] = position.x
            param["y"] = position.y
            param["radius"] = radius
            param["page"] = page
            param["size"] = size
        }
        
        return param
    }
}
