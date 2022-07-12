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
    
    func convertButtonStatus(status:Bool, title:String, completion:@escaping ()->(Void)){
        if status == true {
            button.layer.borderWidth = 1
            button.layer.borderColor = UIColor.black.cgColor
            button.setTitle(title, for: .normal)
            button.setTitleColor(.black, for: .normal)
            button.isUserInteractionEnabled = true
            button.addTarget(self, action: #selector(buttonClicked(_:)), for: .touchUpInside)
            completionHandler = completion
        }else{
            button.layer.borderWidth = 1
            button.layer.borderColor = UIColor.lightGray.cgColor
            button.setTitle(title, for: .normal)
            button.setTitleColor(.lightGray, for: .normal)
            button.isUserInteractionEnabled = false
        }
    }

    @objc func buttonClicked(_ button:UIButton){
        completionHandler()
    }
    //방법 2: UINib 생성 후 instantiate
//    func alternativeCustomInit() {
//        if let view = UINib(nibName: "CustomButtonView", bundle: nil).instantiate(withOwner: self, options: nil).first as? UIView {
//            view.frame = self.bounds
//            addSubview(view)
//        }
//    }
}
