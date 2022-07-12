//
//  CustomTextView.swift
//  AI_MUNJANG
//
//  Created by admin on 2022/07/12.
//

import UIKit

class CustomTextView: UIView,UITextViewDelegate {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var label: UILabel!
    
    let textViewPlaceHolder = "텍스트를 입력하세요"
    
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
        if let view = Bundle.main.loadNibNamed("CustomTextView", owner: self, options: nil)?.first as? UIView {
            view.frame = self.bounds
            addSubview(view)
            
            textView.delegate = self
          
            containerView.layer.borderWidth = 1
            containerView.layer.borderColor = UIColor.darkGray.cgColor
            containerView.layer.cornerRadius = 10
            
            
            
            textView.textContainerInset = UIEdgeInsets(top: 8.0, left: 8.0, bottom: 8.0, right: 8.0)
            textView.font = .systemFont(ofSize: 18)
            textView.text = textViewPlaceHolder
            textView.textColor = .lightGray
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == textViewPlaceHolder {
            textView.text = nil
            textView.textColor = .black
            containerView.layer.borderColor = UIColor.blue.cgColor
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        containerView.layer.borderColor = UIColor.black.cgColor
        if textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            textView.text = textViewPlaceHolder
            textView.textColor = .lightGray
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
            let inputString = text.trimmingCharacters(in: .whitespacesAndNewlines)
            guard let oldString = textView.text, let newRange = Range(range, in: oldString) else { return true }
            let newString = oldString.replacingCharacters(in: newRange, with: inputString).trimmingCharacters(in: .whitespacesAndNewlines)

            let characterCount = newString.count
            guard characterCount <= 50 else { return false }
            updateCountLabel(characterCount: characterCount)
            if(text == "\n") {
                textView.resignFirstResponder()
                return false
            }
            return true
        }
    
    private func updateCountLabel(characterCount: Int) {
         label.text = "\(characterCount)/50자"
         label.asColor(targetString: "\(characterCount)", color: characterCount == 0 ? .lightGray : .blue)
     }

}

extension UILabel {
    func asColor(targetString: String, color: UIColor?) {
        let fullText = text ?? ""
        let range = (fullText as NSString).range(of: targetString)
        let attributedString = NSMutableAttributedString(string: fullText)
        attributedString.addAttribute(.foregroundColor, value: color as Any, range: range)
        attributedText = attributedString
    }
}
