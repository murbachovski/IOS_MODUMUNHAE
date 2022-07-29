//
//  SubscriptionViewController.swift
//  AI_MUNJANG
//
//  Created by admin on 2022/07/21.
//

import UIKit
import StoreKit

public struct InAppProducts {
    public static let product = "com.seogamdo.AI_MUNJANG.month"
    private static let productIdentifiers: Set<ProductIdentifier> = [InAppProducts.product]
    public static let store = IAPHelper(productIds: InAppProducts.productIdentifiers)
}

class SubscriptionViewController: UIViewController {

    @IBOutlet weak var subscribeContainer: UIView!
    @IBOutlet weak var customNaviView: CustomNaviBarView!
    @IBOutlet weak var subscribeChargeLabel: UILabel!
    @IBOutlet weak var subscribeButton: UIButton!
    
    var monthProduct: SKProduct?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //상품을 조회
        InAppProducts.store.requestProducts { success, products in
            self.monthProduct =  products?.first
        }
        

        NotificationCenter.default.addObserver(self, selector: #selector(methodOfReceivedNotification(notification:)), name: .IAPHelperPurchaseNotification, object: nil)


        setupUI()
    }
    
    @objc func methodOfReceivedNotification(notification:Notification){
        print(notification.userInfo as Any)
        if notification.object as! String == InAppProducts.product{
            print("정상적으로 구독이 완료됨")
            dismiss(animated: true)
        }
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
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tappedLabel(tapGestureRecognizer:)))
        subscribeChargeLabel.addGestureRecognizer(tapGesture)
        subscribeChargeLabel.isUserInteractionEnabled = true
        
        
        customNaviView.buttonCompletion {
            print("close button is clicked")
            self.dismiss(animated: true)
        }
    }
    @objc func tappedLabel(tapGestureRecognizer: UITapGestureRecognizer) {
        clickedSubscribeButton(subscribeButton)
    }

    
    @IBAction func clickedSubscribeButton(_ sender: UIButton) {
        print("subscribe clicked")
        if Core.shared.isUserLogin() {
            guard let monthProduct = monthProduct else {
                return
            }

            InAppProducts.store.buyProduct(monthProduct)
            
        }else{
            let alert = AlertService().alert(title: "", body: "상품을 구독하기 위해 로그인 하시겠습니까?", cancelTitle: "취소", confirTitle: "확인", thirdButtonCompletion: nil) {
                changeLoginNC()
            }
            present(alert, animated: true)
        }
    }
    

}
