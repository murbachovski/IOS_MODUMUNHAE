//
//  AlertService.swift
//  SampleProject
//
//  Created by DONG CHEOL KIM on 2022/07/15.
//

import Foundation
import UIKit

class AlertService {
    
    
    func alert(title:String, body:String, cancelTitle:String, confirTitle:String, thirdButtonCompletion:( () ->Void)? = nil, fourthButtonCompletion:( () ->Void)? = nil ) -> CustomAlertViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        let alertVC = storyboard.instantiateViewController(withIdentifier: "CustomAlertViewController") as! CustomAlertViewController
        alertVC.alertTitle = title
        alertVC.alertBody = body
        alertVC.thirdButtonTitle = cancelTitle
        alertVC.fourthButtonTitle = confirTitle
        
        alertVC.thirdButtonAction = thirdButtonCompletion
        alertVC.fourthButtonAction = fourthButtonCompletion
        return alertVC
        
    }
    
}
