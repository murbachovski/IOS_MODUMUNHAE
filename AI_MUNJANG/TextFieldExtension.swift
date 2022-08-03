//
//  TextFieldExtension.swift
//  AI_MUNJANG
//
//  Created by admin on 2022/07/13.
//

import Foundation
import UIKit

extension UITextField {
    fileprivate func setPasswordToggleImage(_ button: UIButton) {
        if(isSecureTextEntry){
            button.setImage(UIImage(named: "icEye24PxOn"), for: .normal)
            button.tintColor = .darkGray
        }else{
            button.setImage(UIImage(named: "icEye24PxOff"), for: .normal)
            button.tintColor = .darkGray

        }
    }

    func enablePasswordToggle(){
        let button = UIButton(type: .custom)
        setPasswordToggleImage(button)
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: -16, bottom: 4, right: 0)
        button.frame = CGRect(x: CGFloat(self.frame.size.width - 25), y: CGFloat(5), width: CGFloat(25), height: CGFloat(25))
        button.addTarget(self, action: #selector(togglePasswordView(_:)), for: .touchUpInside)
        self.rightView = button
        self.rightViewMode = .always
    }
        
    @objc func togglePasswordView(_ sender: Any) {
        self.isSecureTextEntry = !self.isSecureTextEntry
        setPasswordToggleImage(sender as! UIButton)
    }
    
}
