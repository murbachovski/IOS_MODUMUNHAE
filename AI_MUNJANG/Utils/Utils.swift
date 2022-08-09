//
//  Utils.swift
//  AI_MUNJANG
//
//  Created by admin on 2022/07/13.
//

import Foundation
import UIKit

public func isValidPassword(password:String) -> Bool {
    let passwordRegex = "^(?=.*[A-Za-z])(?=.*\\d)(?=.*[$@$!%*#?&])[A-Za-z\\d$@$!%*#?&]{7,}$"
    return NSPredicate(format: "SELF MATCHES %@", passwordRegex).evaluate(with: password)
}


func hexStringToUIColor (hex:String, alpha:CGFloat = 1.0) -> UIColor {
    var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

    if (cString.hasPrefix("#")) {
        cString.remove(at: cString.startIndex)
    }

    if ((cString.count) != 6) {
        return UIColor.gray
    }

    var rgbValue:UInt64 = 0
    Scanner(string: cString).scanHexInt64(&rgbValue)

    return UIColor(
        red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
        green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
        blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
        alpha: alpha
    )
}


func getFontName() {
        for family in UIFont.familyNames {

            let sName: String = family as String
            print("family: \(sName)")
                    
            for name in UIFont.fontNames(forFamilyName: sName) {
                print("name: \(name as String)")
            }
        }
    }

func changeMainNC() { //
    let vc = UIStoryboard(name: "Main", bundle: .main).instantiateViewController(withIdentifier: "mainNavigationController") as! UINavigationController
    let ad = UIApplication.shared.delegate as! AppDelegate
    ad.window?.rootViewController = vc
}


func changeLoginNC() { //LoginNavigationController
    
    let vc = UIStoryboard(name: "Main", bundle: .main).instantiateViewController(withIdentifier: "LoginNavigationController") as! UINavigationController
    let ad = UIApplication.shared.delegate as! AppDelegate
    ad.window?.rootViewController = vc
}


extension Date {
    
    func toString( dateFormat format: String ) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.timeZone = TimeZone.autoupdatingCurrent
        dateFormatter.locale = Locale.current
        return dateFormatter.string(from: self)
    }
    
    func toStringKST( dateFormat format: String ) -> String {
        return self.toString(dateFormat: format)
    }
    
    func toStringUTC( dateFormat format: String ) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        return dateFormatter.string(from: self)
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
    
    func asFont(targetString: String, font: UIFont?) {
        let fullText = text ?? ""
        let range = (fullText as NSString).range(of: targetString)
        let attributedString = NSMutableAttributedString(string: fullText)
        attributedString.addAttribute(.font, value: font as Any, range: range)
        attributedText = attributedString
    }
}


class ActualGradientButton: UIButton {

    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds
    }

    private lazy var gradientLayer: CAGradientLayer = {
        let l = CAGradientLayer()
        l.frame = self.bounds
        l.colors = [hexStringToUIColor(hex: "#04BF55").cgColor, hexStringToUIColor(hex: "#11998E").cgColor]
        l.startPoint = CGPoint(x: 0, y: 0.5)
        l.endPoint = CGPoint(x: 1, y: 0.5)
        l.cornerRadius = 8
        layer.insertSublayer(l, at: 0)
        return l
    }()
}

extension UIButton {
    func setRightImage(right: UIImage? = nil) {
       
        if let rightImage = right{
            setImage(rightImage, for: .normal)
            imageEdgeInsets = UIEdgeInsets(top: 5, left: 0, bottom: 0, right: 100)
            titleEdgeInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 10)
            rightImage.withRenderingMode(.alwaysTemplate)
            contentHorizontalAlignment = .left
        }

    }
}

@IBDesignable class PaddingLabel: UILabel {

    @IBInspectable var topInset: CGFloat = 4.0
    @IBInspectable var bottomInset: CGFloat = 4.0
    @IBInspectable var leftInset: CGFloat = 8.0
    @IBInspectable var rightInset: CGFloat = 8.0

    override func drawText(in rect: CGRect) {
        let insets = UIEdgeInsets(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset)
        super.drawText(in: rect.inset(by: insets))
    }

    override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        return CGSize(width: size.width + leftInset + rightInset,
                      height: size.height + topInset + bottomInset)
    }

    override var bounds: CGRect {
        didSet {
            preferredMaxLayoutWidth = bounds.width - (leftInset + rightInset)
        }
    }
}
