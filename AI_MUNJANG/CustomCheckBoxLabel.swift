//
//  CustomCheckBoxLabel.swift
//  AI_MUNJANG
//
//  Created by admin on 2022/07/18.
//

import UIKit

class CustomCheckBoxLabel: UIView {

    @IBOutlet weak var checkButton: UIButton!
    
    @IBOutlet weak var checkButtonLabel: UILabel!
    @IBOutlet weak var checkButtonSubButton: UIButton!
    var isCheckedBox = false
    
    
    
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
        if let view = Bundle.main.loadNibNamed("CustomCheckBoxLabel", owner: self, options: nil)?.first as? UIView {
            view.frame = self.bounds
            checkButton.tintColor = .darkGray
            addSubview(view)
            
        }
    }
    
    @IBAction func clickedCheckButton(_ sender: UIButton) {
        print("clicked checkButton")
        sender.isSelected.toggle()
    }
    
    @IBAction func clickedCheckButtonSubButton(_ sender: Any) {
        print("clicked clickedCheckButtonSubButton")
    }
    
}
