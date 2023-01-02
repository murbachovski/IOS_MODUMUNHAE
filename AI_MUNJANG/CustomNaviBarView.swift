//
//  CustomNaviBarView.swift
//  AI_MUNJANG
//
//  Created by admin on 2022/07/21.
//

import UIKit

//전면 팝업의 상단 툴바를 통일시키기 위해 만듦

class CustomNaviBarView: UIView {

    var completionHandler: ()->Void = {}
    
    @IBOutlet var subTitle: UILabel!
    
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
        if let view = Bundle.main.loadNibNamed("CustomNaviBarView", owner: self, options: nil)?.first as? UIView {
            view.frame = self.bounds
            
            addSubview(view)
            
            if UIDevice.current.userInterfaceIdiom == .pad {
                subTitle.font = subTitle.font.withSize(22)
            }
            
        }
    }
    
    func buttonCompletion(buttonCompletion:@escaping ()->(Void)){
        completionHandler = buttonCompletion
    }
  
    @IBAction func clickedButton(_ sender: UIButton) {
        completionHandler()
    }
}
