//
//  Position.swift
//  KakaoMap_Sample
//
//  Created by Haehyeon Jeong on 26/05/2019.
//  Copyright © 2019 JHH. All rights reserved.
//

import Foundation

public struct Position: Codable {
    public let x: String
    public let y: String
    
    public init(x: String,
                y: String){
        self.x = x
        self.y = y
    }
}
