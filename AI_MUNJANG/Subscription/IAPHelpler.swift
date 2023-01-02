//
//  IAPHelpler.swift
//  AI_MUNJANG
//
//  Created by admin on 2022/07/29.
//

import StoreKit

let sharePassword = "c410db4864b64c72b821131a5893ced3"

public typealias ProductIdentifier = String
public typealias ProductsRequestCompletionHandler = (_ success: Bool, _ products: [SKProduct]?) -> Void


extension Notification.Name {
    static let IAPHelperPurchaseNotification = Notification.Name("IAPHelperPurchaseNotification")
}

open class IAPHelper: NSObject  {
    private let productIdentifiers: Set<ProductIdentifier>
    private var purchasedProductIdentifiers: Set<ProductIdentifier> = []
    private var productsRequest: SKProductsRequest?
    private var productsRequestCompletionHandler: ProductsRequestCompletionHandler?
    
    
    
    
    public init(productIds: Set<ProductIdentifier>) {
        productIdentifiers = productIds

        for productIdentifier in productIds {
            let purchased = UserDefaults.standard.bool(forKey: productIdentifier)

            if purchased {
                purchasedProductIdentifiers.insert(productIdentifier)
                print("Previously purchased: \(productIdentifier)")
            } else {
                print("Not purchased: \(productIdentifier)")
            }
        }

        super.init()
        SKPaymentQueue.default().add(self)
    }
}

extension IAPHelper {
    public func requestProducts(_ completionHandler: @escaping ProductsRequestCompletionHandler) {
        productsRequest?.cancel()
        productsRequestCompletionHandler = completionHandler
        productsRequest = SKProductsRequest(productIdentifiers: productIdentifiers)
        productsRequest!.delegate = self
        productsRequest!.start()
    }
    
    public func buyProduct(_ product: SKProduct) {
        print("Buying \(product.productIdentifier)...")
        let payment = SKPayment(product: product)
        SKPaymentQueue.default().add(payment)
    }
    
    public func isProductPurchased(_ productIdentifier: ProductIdentifier) -> Bool {
        return purchasedProductIdentifiers.contains(productIdentifier)
    }
    
    public class func canMakePayments() -> Bool {
        return SKPaymentQueue.canMakePayments()
    }
    
    public func restorePurchases() {
        SKPaymentQueue.default().restoreCompletedTransactions()
    }
}

extension IAPHelper: SKProductsRequestDelegate {
    public func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        print("Loaded list of products...")
        let products = response.products
        productsRequestCompletionHandler?(true, products)
        clearRequestAndHandler()
        
        for p in products {
            print("Found product: \(p.productIdentifier) \(p.localizedTitle) \(p.price.floatValue)")
        }
    }
    
    public func request(_ request: SKRequest, didFailWithError error: Error) {
        print("Failed to load list of products.")
        print("Error: \(error.localizedDescription)")
        productsRequestCompletionHandler?(false, nil)
        clearRequestAndHandler()
    }
    
    private func clearRequestAndHandler() {
        productsRequest = nil
        productsRequestCompletionHandler = nil
    }
}

extension IAPHelper: SKPaymentTransactionObserver {
    public func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            switch (transaction.transactionState) {
            case .purchased:
                print("purchased 정상적으로 호출")
                complete(transaction: transaction)
                break
            case .failed:
                fail(transaction: transaction)
                break
            case .restored:
                print("restore 정상적으로 호출")
                restore(transaction: transaction)
                break
            case .deferred:
                break
            case .purchasing:
                break
            @unknown default:
                print("unknown")
                fatalError()
            }
        }
    }
    
    public func paymentQueueRestoreCompletedTransactionsFinished(_ queue: SKPaymentQueue) {
       print("restore call is finished")
    }
    
    private func complete(transaction: SKPaymentTransaction) {
        print("complete...")
        Core.shared.setUserSubscription() //구독완료되므로 isSubscription을 ON
        deliverPurchaseNotificationFor(identifier: transaction.payment.productIdentifier)
        SKPaymentQueue.default().finishTransaction(transaction)
        
    }
    
    private func restore(transaction: SKPaymentTransaction) {
        guard let productIdentifier = transaction.original?.payment.productIdentifier else {
            print("구입내역이 없다.")
            return }

        print("restore... \(productIdentifier)")
        
        deliverPurchaseNotificationFor(identifier: productIdentifier)
        SKPaymentQueue.default().finishTransaction(transaction)
    }
    
    private func fail(transaction: SKPaymentTransaction) {
        print("fail...")
        
        if let transactionError = transaction.error as NSError?,
            let localizedDescription = transaction.error?.localizedDescription,
            transactionError.code != SKError.paymentCancelled.rawValue {
            print("Transaction Error: \(localizedDescription)")
        }
        
        SKPaymentQueue.default().finishTransaction(transaction)
    }
    
    private func deliverPurchaseNotificationFor(identifier: String?) {
        guard let identifier = identifier else { return }

        purchasedProductIdentifiers.insert(identifier)
        UserDefaults.standard.set(true, forKey: identifier)
        NotificationCenter.default.post(name: .IAPHelperPurchaseNotification, object: identifier)
    }
    

      
    func checkReceiptValidation(isProduction: Bool = true, completion: @escaping( (Bool)->Void)) {
            let completionArg = completion
        guard let receiptFileURL = Bundle.main.appStoreReceiptURL else {return}
        let receiptData = try? Data(contentsOf: receiptFileURL)
            guard let recieptString = receiptData?.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0)) else{
                print("영수증 복원에 장애(구매이력없어서).")
                    return
            }

            var urlString: String = ""
            if isProduction {
                urlString = "https://buy.itunes.apple.com/verifyReceipt"
            } else {
                urlString = "https://sandbox.itunes.apple.com/verifyReceipt"
            }
            
            let url = URL(string: urlString)!

            let dic: [String: Any] = [
                "password": sharePassword,
                "receipt-data": recieptString
            ]
            
            var request = URLRequest(url: url)
            request.httpBody = try? JSONSerialization.data(withJSONObject: dic, options: [])
            request.httpMethod = "POST"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            
            let task = URLSession.shared.dataTask(with: request) {(data, response, error) in
                guard let data = data,
                      let object = try? JSONSerialization.jsonObject(with: data, options: []),
                      let json = object as? [String: Any] else {
                    return
                }
                print(json)
                if let statusCode = json["status"] as? Int,
                   statusCode == 21007 {
                    self.checkReceiptValidation(isProduction: false,completion: { valid in completionArg(valid)  })
                   }
                if let expireDate = self.getExpirationDateFromResponse(json as NSDictionary) {
                    print(expireDate)
                    let currentDateStr = Date().toStringUTC(dateFormat: "yyyy-MM-dd HH:mm:ss VV")
                    let expireDateStr = expireDate.toStringUTC(dateFormat: "yyyy-MM-dd HH:mm:ss VV")
                    print("currentDate: \(currentDateStr): KCT-TIME: \(Date().toStringKST(dateFormat: "yyyy-MM-dd HH:mm:ss VV"))")
                    print("expireDate: \(expireDate)")

                    if expireDateStr < currentDateStr {
                        if  MyInfo.shared.couponID != ""{
                           return
                        }
                        print("☠️구독 만료일자가 지나서 사용자의 사용을 제한해야")
                        Core.shared.setUserCancelSubscription()
                        completionArg(false)
                    }else{
                        print("😀구독 만료일자가 남아 있다.")
                        Core.shared.setUserSubscription()
                        
                        completionArg(true)
                        
                    }
                    
                    
                }
            }
            task.resume()
        }
    

    func getExpirationDateFromResponse(_ jsonResponse: NSDictionary) -> Date? {

            if let receiptInfo: NSArray = jsonResponse["latest_receipt_info"] as? NSArray {

                let lastReceipt = receiptInfo.firstObject as! NSDictionary
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy-MM-dd HH:mm:ss VV"

                
                if let expiresDate = lastReceipt["expires_date"] as? String {
                    return formatter.date(from: expiresDate)
                }
                
                return nil
            }
            else {
                return nil
            }
        }

}
