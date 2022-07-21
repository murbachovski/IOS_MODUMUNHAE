//
//  SubscriptionViewController.swift
//  AI_MUNJANG
//
//  Created by admin on 2022/07/21.
//

import UIKit

class SubscriptionViewController: UIViewController {

    @IBOutlet weak var subscribeContainer: UIView!
    @IBOutlet weak var customNaviView: CustomNaviBarView!
    @IBOutlet weak var subscribeChargeLabel: UILabel!
    @IBOutlet weak var subscribeButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        setupUI()
    }
    
    func setupUI() {
        
        
        subscribeButton.clipsToBounds = true
        subscribeButton.layer.cornerRadius = 8
        subscribeButton.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        
        subscribeContainer.layer.cornerRadius = 8
        subscribeContainer.layer.shadowOpacity = 1
        subscribeContainer.layer.shadowColor = UIColor.lightGray.cgColor
        subscribeContainer.layer.shadowOffset = CGSize(width: 0, height: 0)
        subscribeContainer.layer.shadowRadius = 8
        subscribeContainer.layer.masksToBounds = false
        
        
        let mainString = "￦10,000 /월"
        let stringToColor = "￦10,000"
        let range = (mainString as NSString).range(of: stringToColor)

        let mutableAttributedString = NSMutableAttributedString.init(string: mainString)
        mutableAttributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.red, range: range)
        
        subscribeChargeLabel.attributedText = mutableAttributedString
        
        
        customNaviView.buttonCompletion {
            print("close button is clicked")
            self.dismiss(animated: true)
        }
    }

    @IBAction func clickedSubscribeButton(_ sender: Any) {
        print("subscribe clicked")
    }
    

}
