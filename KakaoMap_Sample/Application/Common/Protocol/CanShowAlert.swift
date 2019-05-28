//
//  CanShowAlert.swift
//  KakaoMap_Sample
//
//  Created by Haehyeon Jeong on 29/05/2019.
//  Copyright © 2019 JHH. All rights reserved.
//

import UIKit

protocol CanShowAlert {
    func showAlert(title : String?,
                   message:String?)
}

extension CanShowAlert{
    func showAlert(title : String?,
                   message:String?){
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let confirmAlert = UIAlertAction(title: "확인", style: .default, handler: nil)
        alertController.addAction(confirmAlert)
        
        appDelegate?.searchFrontViewController().present(alertController,animated:true,completion:nil)
    }
}
