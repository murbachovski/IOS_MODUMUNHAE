//
//  CustomAlertViewController.swift
//  SampleProject
//
//  Created by DONG CHEOL KIM on 2022/07/15.
//

import UIKit

class CustomAlertViewController: UIViewController {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var bodyLabel: UILabel!
   
    
    @IBOutlet weak var firstButton: UIButton!
    @IBOutlet weak var secondButton: UIButton!
    @IBOutlet weak var thirdButton: UIButton!
    @IBOutlet weak var fourthButton: UIButton!
    
    var alertTitle = String()
    var alertBody = String()
    var firstButtonTitle = String()
    var secondButtonTitle = String()
    var thirdButtonTitle = String()
    var fourthButtonTitle = String()
    
    var firstButtonAction:(()->Void)?
    var secondButtonAction:(()->Void)?
    var thirdButtonAction:(()->Void)?
    var fourthButtonAction:(()->Void)?
    
    @IBOutlet weak var containerView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        // Do any additional setup after loading the view.
    }
    
    
    func setupView() {
        containerView.layer.cornerRadius = 8
        containerView.layer.masksToBounds = true
        
        if alertTitle != ""{
            titleLabel.text = alertTitle
        }else{
            titleLabel.isHidden = true
        }
        
        if alertBody != ""{ //body는 내용이 없더라도 일단 놔두자
            bodyLabel.text = alertBody
        }
        
        if firstButtonTitle != "" {
            firstButton.setTitle(firstButtonTitle, for: .normal)
        }else{
            firstButton.isHidden = true
        }
        
        if secondButtonTitle != "" {
            secondButton.setTitle(secondButtonTitle, for: .normal)
        }else{
            secondButton.isHidden = true
        }
        
        if thirdButtonTitle != "" {
            thirdButton.setTitle(thirdButtonTitle, for: .normal)
        }else{
            thirdButton.isHidden = true
        }
        
        if fourthButtonTitle != ""{
            fourthButton.setTitle(fourthButtonTitle, for: .normal)
        }else{
            fourthButton.isHidden = true
        }
        
        firstButton.layer.cornerRadius = 8
        secondButton.layer.cornerRadius = 8
        thirdButton.layer.cornerRadius = 8
        fourthButton.layer.cornerRadius = 8
        
        thirdButton.layer.borderWidth = 1
        thirdButton.layer.borderColor = hexStringToUIColor(hex: Constants.primaryColor).cgColor
        
        let attrString = NSMutableAttributedString(string: bodyLabel.text!)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 4
        attrString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, attrString.length))
        bodyLabel.attributedText = attrString
        bodyLabel.textAlignment = .center
    }
    
    @IBAction func didTapFirst(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        firstButtonAction?()
    }
    
    @IBAction func didTapSecond(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        secondButtonAction?()
    }
    
    @IBAction func didTapThird(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        thirdButtonAction?()
    }
    @IBAction func didTapFourth(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        fourthButtonAction?()
    }
    
    
}
