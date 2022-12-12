//
//  SubscriptionViewController.swift
//  AI_MUNJANG
//
//  Created by admin on 2022/07/21.
//

import UIKit
import StoreKit

public struct InAppProducts {
    public static let product = "com.seogamdo.AI_MUNJANG.monthly"
    private static let productIdentifiers: Set<ProductIdentifier> = [InAppProducts.product]
    public static let store = IAPHelper(productIds: InAppProducts.productIdentifiers)
}
//

class SubscriptionViewController: UIViewController {

    @IBOutlet var indicator: UIActivityIndicatorView!
    @IBOutlet weak var subscribeContainer: UIView!
    @IBOutlet weak var customNaviView: CustomNaviBarView!
    @IBOutlet weak var subscribeChargeLabel: UILabel!
    @IBOutlet weak var subscribeButton: UIButton!
    
    @IBOutlet weak var mainTitle: UILabel!
    @IBOutlet weak var subTitle: UILabel!
    
    var monthProduct: SKProduct?
    var isClickedSubscribeButton = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        indicator.color = UIColor.systemGray6
        // Do any additional setup after loading the view.
        //상품을 조회
        InAppProducts.store.requestProducts { success, products in
            self.monthProduct =  products?.first
        }
        

        NotificationCenter.default.addObserver(self, selector: #selector(methodOfReceivedNotification(notification:)), name: .IAPHelperPurchaseNotification, object: nil)


        setupUI()
    }
    
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//
//        if indicator.isAnimating {
//            indicator.stopAnimating()
//        }
//    }
    
    @objc func methodOfReceivedNotification(notification:Notification){
        print(notification.userInfo as Any)
        if notification.object as! String == InAppProducts.product && isClickedSubscribeButton == true {
            print("정상적으로 구독이 완료됨")
            isClickedSubscribeButton = false
            dismiss(animated: true)
        }
    }
    
    func setupUI() {
        
        mainTitle.font = UIFont(name: "NanumSquareEB", size: 19)
        
        
        subscribeButton.clipsToBounds = true
        subscribeButton.layer.cornerRadius = 8
        subscribeButton.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        subscribeButton.titleLabel?.font = UIFont(name: "NanumSquareEB", size: 17)
        
        subscribeContainer.layer.cornerRadius = 8
        subscribeContainer.layer.shadowOpacity = 1
        subscribeContainer.layer.shadowColor = UIColor.lightGray.cgColor
        subscribeContainer.layer.shadowOffset = CGSize(width: 0, height: 0)
        subscribeContainer.layer.shadowRadius = 8
        subscribeContainer.layer.masksToBounds = false
        
        
        let mainString = "￦9,900 /월"
        let stringToColor = "￦9,900"
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
        isClickedSubscribeButton = true
        if Core.shared.isUserLogin() {
            //시작
            indicator.color = hexStringToUIColor(hex: "#04BF55")
            self.indicator.startAnimating()
            guard let monthProduct = monthProduct else {
                return
            }
            InAppProducts.store.buyProduct(monthProduct)
        }else{
            let alert = AlertService().alert(title: "", body: "상품을 구독하기 위해 \n로그인 하시겠습니까?", cancelTitle: "취소", confirTitle: "확인", thirdButtonCompletion: nil) {
                changeLoginNC()
            }
            present(alert, animated: true)
        }
    }

    
}
