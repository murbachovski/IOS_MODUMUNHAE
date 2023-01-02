//
//  CustomTFAlertViewController.swift
//  AI_MUNJANG
//
//  Created by admin on 2022/10/25.
//

import UIKit

class CustomTFAlertViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var correctionTextField: UITextField!
    
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var confirmButton: UIButton!
    
    var alertTitle = String()
    var alertBody = String()
   
    var cancelButtonAction:(()->Void)?
    var confirmButtonAction:((String)->Void)?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        correctionTextField.delegate = self
        setupView()
        
    }
    
    func setupView() {
        containerView.layer.cornerRadius = 8
        containerView.layer.masksToBounds = true
        
    
        cancelButton.layer.borderWidth = 1
        cancelButton.layer.borderColor = hexStringToUIColor(hex: Constants.primaryColor).cgColor
        
        cancelButton.layer.cornerRadius = 8
        confirmButton.layer.cornerRadius = 8
        
        correctionTextField.placeholder = ""
        correctionTextField.becomeFirstResponder()
    }

    @IBAction func clickedCancelButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        cancelButtonAction?()
    }
    
    @IBAction func clickedConfirmButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        confirmButtonAction?(correctionTextField.text!)
    }
    
    
    // became first responder
    func textFieldDidBeginEditing(_ textField: UITextField){
        containerView.layer.borderColor = UIColor.blue.cgColor
    }
    
    
    // may be called if forced even if shouldEndEditing returns NO (e.g. view removed from window) or endEditing:YES called
    func textFieldDidEndEditing(_ textField: UITextField){
        containerView.layer.borderColor = UIColor.black.cgColor
    
        
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
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
       
        return true
    }
 
    
    
}
