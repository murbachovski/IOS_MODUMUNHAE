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
    
    var textViewPlaceHolder = "텍스트를 입력하세요"
    var restrictedCharacters = 50
    
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
            containerView.layer.borderColor = UIColor.lightGray.cgColor
            containerView.layer.cornerRadius = 10

            textView.textContainerInset = UIEdgeInsets(top: 8.0, left: 8.0, bottom: 8.0, right: 8.0)
            textView.font = .systemFont(ofSize: 16)
            textView.text = textViewPlaceHolder
            textView.textColor = .lightGray
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == textViewPlaceHolder {
            textView.text = nil
            textView.textColor = .black
            containerView.layer.borderColor = UIColor.darkGray.cgColor
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
            guard characterCount <= restrictedCharacters else { return false }
            updateCountLabel(characterCount: characterCount)
            if(text == "\n") {
                textView.resignFirstResponder()
                return false
            }
            return true
        }
    
    private func updateCountLabel(characterCount: Int) {
         label.text = "\(characterCount)/\(restrictedCharacters)자"
         label.asColor(targetString: "\(characterCount)", color: characterCount == 0 ? .lightGray : .blue)
     }
    
    
    func changePlaceHolder(placeholder:String){ //외부에서 플레이스홀더를 설정하는 메서드
        textViewPlaceHolder = placeholder
        textView.text = placeholder
    }

    func changeRestrictedCharacters(res:Int){ //외부에서 플레이스홀더를 설정하는 메서드
        restrictedCharacters = res
        updateCountLabel(characterCount: 0)
    }
}


