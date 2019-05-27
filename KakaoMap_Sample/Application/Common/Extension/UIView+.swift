//
//  UIView+.swift
//  KakaoMap_Sample
//
//  Created by Haehyeon Jeong on 28/05/2019.
//  Copyright © 2019 JHH. All rights reserved.
//

import Foundation

import SnapKit
extension UIView {
    var safeArea: ConstraintBasicAttributesDSL {
        if #available(iOS 11.0, *) {
            return self.safeAreaLayoutGuide.snp
        }
        
        return self.snp
    }
}
