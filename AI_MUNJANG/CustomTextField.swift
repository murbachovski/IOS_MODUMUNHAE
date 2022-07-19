//
//  CustomTextField.swift
//  AI_MUNJANG
//
//  Created by admin on 2022/07/19.
//

import UIKit

class CustomTextField: UIView, UITextFieldDelegate{

    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var titleLabel: UILabel!
    
    //일단 notice라벨은 무시, 다른 customView와 크기를 맞추기 위해 남겨둔다.
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        customInit()
        
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        customInit()
        
    }

    //방법 1: loadNibNamed(_:owner:options:) 사용
    func customInit() {
        if let view = Bundle.main.loadNibNamed("CustomTextField", owner: self, options: nil)?.first as? UIView {
            view.frame = self.bounds
            textField.delegate = self
            
            addSubview(view)
            
        }
    }
    
    
    
    // called when 'return' key pressed. return NO to ignore.
    func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        textField.resignFirstResponder()
        return true
    }

    // return NO to not change text
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool{
        
        
        return true
    }
  

}
