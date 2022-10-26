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
        
        let storyboard = UIStoryboard(name: whichStoryBoard(), bundle: .main)
        let alertVC = storyboard.instantiateViewController(withIdentifier: "CustomAlertViewController") as! CustomAlertViewController
        alertVC.alertTitle = title
        alertVC.alertBody = body
        alertVC.thirdButtonTitle = cancelTitle
        alertVC.fourthButtonTitle = confirTitle
        
        alertVC.thirdButtonAction = thirdButtonCompletion
        alertVC.fourthButtonAction = fourthButtonCompletion
        return alertVC
        
    }
    
    func alertTF(cancelButtonCompletion:(@escaping () ->Void), confirmButtonCompletion:(@escaping (String) ->Void)) -> CustomTFAlertViewController {
        
        let storyboard = UIStoryboard(name: whichStoryBoard(), bundle: .main)
        let alertVC = storyboard.instantiateViewController(withIdentifier: "CustomTFAlertViewController") as! CustomTFAlertViewController
 
        
        alertVC.cancelButtonAction = cancelButtonCompletion
        alertVC.confirmButtonAction = confirmButtonCompletion
        return alertVC
        
    }
    
    
}
