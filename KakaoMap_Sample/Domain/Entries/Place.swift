//
//  Place.swift
//  KakaoMap_Sample
//
//  Created by Haehyeon Jeong on 26/05/2019.
//  Copyright © 2019 JHH. All rights reserved.
//

import Foundation

struct Place: Codable {
    var placeName   : String //장소명, 업체명
    var distance    : String  //중심좌표까지의 거리(x,y 파라미터를 준 경우에만 존재). 단위 meter
    var categoryName: String //카테고리 이름
    var addressName: String //전체 지번 주소
    var roadAddressName: String //전체 도로명 주소
    var id: String //장소 id
    var phone: String //전화번호
    let categoryGroupCode: CategoryCode//카테고리 그룹 코드
    var categoryGroupName: String//카테고리 그룹 명
    let x: String //장소 x좌표
    let y: String //장소 y좌표
    
    
    enum CodingKeys: String, CodingKey {
        case distance, id, phone, x, y
        case placeName         = "place_name"
        case categoryName      = "category_name"
        case addressName       = "address_name"
        case roadAddressName   = "road_address_name"
        case categoryGroupCode = "category_group_code"
        case categoryGroupName = "category_group_name"
    }
    
    
    init(from decoder: Decoder) throws {
        let values         = try decoder.container(keyedBy: CodingKeys.self)
        self.placeName     = try values.decode(String.self, forKey: .placeName)
        self.distance      = try values.decode(String.self, forKey: .distance)
        self.categoryName  = try values.decode(String.self, forKey: .categoryName)
        self.addressName   = try values.decode(String.self, forKey: .addressName)
        self.roadAddressName = try values.decode(String.self, forKey: .roadAddressName)
        self.id            = try values.decode(String.self, forKey: .id)
        self.phone         = try values.decode(String.self, forKey: .phone)
        self.categoryGroupName = try values.decode(String.self, forKey: .categoryGroupName)
        self.categoryGroupCode = try values.decode(CategoryCode.self, forKey: .categoryGroupCode)
        self.x = try values.decode(String.self, forKey: .x)
        self.y = try values.decode(String.self, forKey: .y)
    }
}
