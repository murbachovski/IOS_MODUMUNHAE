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
    
    func convertButtonStatus(status:Bool,backgroundColor:UIColor, titleColor:UIColor, completion:@escaping ()->(Void)){
        if status == true {
            
            button.setTitleColor(.black, for: .normal)
            button.isUserInteractionEnabled = true
            button.addTarget(self, action: #selector(buttonClicked(_:)), for: .touchUpInside)
            completionHandler = completion
            
        }else{
            
            button.backgroundColor = .lightGray
            button.setTitleColor(.darkGray, for: .normal)
            button.isUserInteractionEnabled = false
        }
    }

    @objc func buttonClicked(_ button:UIButton){
        completionHandler()
    }
    
    

}
