//
//  Place.swift
//  KakaoMap_Sample
//
//  Created by Haehyeon Jeong on 26/05/2019.
//  Copyright © 2019 JHH. All rights reserved.
//

import Foundation

struct Place {
    let placeName   : String //장소명, 업체명
    let distance    : String  //중심좌표까지의 거리(x,y 파라미터를 준 경우에만 존재). 단위 meter
    let categoryName: String //카테고리 이름
    let adressName: String //전체 지번 주소
    let roadAdressName: String //전체 도로명 주소
    let id: String //장소 id
    let phone: String //전화번호
    let categoryGroupCode: CategoryCode//카테고리 그룹 코드
    let categoryGroupName: String//카테고리 그룹 명
    let position: Position //장소 좌표
}
