//
//  CustomButtonView.swift
//  SampleProject
//
//  Created by DONG CHEOL KIM on 2022/07/11.
//

import UIKit

class CustomButtonView: UIView {

    @IBOutlet weak var button: UIButton!
    var completionHandler: ()->Void = {}
    
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
        if let view = Bundle.main.loadNibNamed("CustomButtonView", owner: self, options: nil)?.first as? UIView {
            view.frame = self.bounds
            
            addSubview(view)
            
        }
    }
    
    func buttonCompletion(buttonCompletion:@escaping ()->(Void)){
        completionHandler = buttonCompletion
    }
    
    
    func convertButtonStatus(status:Bool?,backgroundColor:UIColor?, titleColor:UIColor?){
        if status == true {
            
            button.isUserInteractionEnabled = true
            button.setTitleColor(titleColor ?? .white, for: .normal)
            button.titleLabel?.font =  UIFont(name: "NanumSquareEB", size: 17)
            button.backgroundColor = backgroundColor ?? hexStringToUIColor(hex: "#CACACA")
            
        }else{
            button.isUserInteractionEnabled = false
            button.setTitleColor(titleColor ?? .white, for: .normal)
            button.titleLabel?.font =  UIFont(name: "NanumSquareEB", size: 17)
            button.backgroundColor = backgroundColor ?? hexStringToUIColor(hex: "#CACACA")
                        
        }
    }

  
    @IBAction func clickedButton(_ sender: UIButton) {
        completionHandler()
    }

}
