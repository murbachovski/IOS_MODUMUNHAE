//
//  TermsViewController.swift
//  AI_MUNJANG
//
//  Created by admin on 2022/07/18.
//

import UIKit
import FirebaseAuth
import CryptoKit
import AuthenticationServices

class TermsViewController: UIViewController, CheckButtonDelegate, ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return view.window!
    }

    @IBOutlet weak var termsMaintitle: UILabel!
    
    @IBOutlet weak var allCheckLabel: CustomCheckBoxLabel!
    
    @IBOutlet weak var useTermsCheckLabel: CustomCheckBoxLabel!
    
    @IBOutlet weak var personalInfoCheckLabel: CustomCheckBoxLabel!
    
    @IBOutlet weak var fourteenCheckLabel: CustomCheckBoxLabel!
    
    @IBOutlet weak var marketingInfoCheckLabel: CustomCheckBoxLabel!
    
    @IBOutlet weak var nextButton: CustomButtonView!
    
    var isAppleLogin = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()

    }
    
    
    
    fileprivate func setupUI() {
     
        
        
        self.navigationItem.title = "회원가입"
        self.navigationItem.backButtonTitle = " "
        
        termsMaintitle.font =  UIFont(name: "NanumSquareEB", size: 19)
        
        allCheckLabel.checkButtonLabel.text = "모두 동의합니다."
        allCheckLabel.checkButton.tag = 0
        allCheckLabel.checkSubButton.isHidden = true
        
        allCheckLabel.checkButtonLabel.font =  UIFont(name: "NanumSquareB", size: 15)
        
        useTermsCheckLabel.checkButtonLabel.text = "[필수] 이용약관 동의"
        useTermsCheckLabel.checkButton.tag = 1
        useTermsCheckLabel.checkSubButton.tag = 1
        
        personalInfoCheckLabel.checkButtonLabel.text = "[필수] 개인정보 수집・이용 동의"
        personalInfoCheckLabel.checkButton.tag = 2
        personalInfoCheckLabel.checkSubButton.tag = 2
        
        fourteenCheckLabel.checkButtonLabel.text = "[필수] 14세 이상입니다"
        fourteenCheckLabel.checkButton.tag = 3
        fourteenCheckLabel.checkSubButton.tag = 3
        
        marketingInfoCheckLabel.checkButtonLabel.text = "[선택] 마케팅 정보 수신 동의"
        marketingInfoCheckLabel.checkButton.tag = 4
        marketingInfoCheckLabel.checkSubButton.tag = 4
        
        nextButton.button.setTitle("다음", for: .normal)
        nextButton.button.titleLabel?.font = UIFont(name: "NanumSquareB", size: 20)
//        nextButton.convertButtonStatus(status: true, backgroundColor: .lightGray, titleColor: .white)
        nextButton.button.setTitleColor(.lightGray, for: .normal)
        nextButton.button.backgroundColor = hexStringToUIColor(hex: Constants.inActive_status)
        
        nextButton.button.layer.cornerRadius = 8
        nextButton.buttonCompletion {            
            self.clickedNextButton()
        }
        
        
        allCheckLabel.checkButtonDelegate = self
        useTermsCheckLabel.checkButtonDelegate = self
        personalInfoCheckLabel.checkButtonDelegate = self
        fourteenCheckLabel.checkButtonDelegate = self
        marketingInfoCheckLabel.checkButtonDelegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    
    func checkButtonClicked(_ sender: UIButton) {
        if sender.tag == 0 {
            if sender.isSelected == true {
                useTermsCheckLabel.checkButton.isSelected = false
                personalInfoCheckLabel.checkButton.isSelected = false
                fourteenCheckLabel.checkButton.isSelected = false
                marketingInfoCheckLabel.checkButton.isSelected = false
                allCheckLabel.checkButton.isSelected = false
            }else {
                useTermsCheckLabel.checkButton.isSelected = true
                personalInfoCheckLabel.checkButton.isSelected = true
                fourteenCheckLabel.checkButton.isSelected = true
                marketingInfoCheckLabel.checkButton.isSelected = true
                allCheckLabel.checkButton.isSelected = true
            }
            
        }else if sender.tag == 1 {
            useTermsCheckLabel.checkButton.isSelected = !useTermsCheckLabel.checkButton.isSelected
        }else if sender.tag == 2 {
            personalInfoCheckLabel.checkButton.isSelected = !personalInfoCheckLabel.checkButton.isSelected
        }else if sender.tag == 3 {
            fourteenCheckLabel.checkButton.isSelected = !fourteenCheckLabel.checkButton.isSelected
        }else if sender.tag == 4 {
            marketingInfoCheckLabel.checkButton.isSelected = !marketingInfoCheckLabel.checkButton.isSelected
        }
        
        //모두 동의 버튼 활성화여부 판단
        if useTermsCheckLabel.checkButton.isSelected && personalInfoCheckLabel.checkButton.isSelected && fourteenCheckLabel.checkButton.isSelected && marketingInfoCheckLabel.checkButton.isSelected {
            allCheckLabel.checkButton.isSelected = true
        }
        
        if useTermsCheckLabel.checkButton.isSelected == false || personalInfoCheckLabel.checkButton.isSelected  == false || fourteenCheckLabel.checkButton.isSelected == false || marketingInfoCheckLabel.checkButton.isSelected == false {
            allCheckLabel.checkButton.isSelected = false
        }
        

        
        //다음버튼 활성화 여부 판단
        if useTermsCheckLabel.checkButton.isSelected && personalInfoCheckLabel.checkButton.isSelected && fourteenCheckLabel.checkButton.isSelected {
            nextButton.button.isUserInteractionEnabled = true
            nextButton.button.setTitleColor(.white, for: .normal)
            nextButton.button.backgroundColor = hexStringToUIColor(hex: Constants.primaryColor)
        }else{
//            nextButton.convertButtonStatus(status: true, backgroundColor: .lightGray, titleColor: .white)
            nextButton.button.isUserInteractionEnabled = false
            nextButton.button.setTitleColor(.lightGray, for: .normal)
            nextButton.button.backgroundColor = hexStringToUIColor(hex: Constants.inActive_status)
        }
    }

    func checkSubButtonClicked(_ sender: UIButton) {
        var titleOfLabel = ""
            
        if sender.tag == 1 {
            titleOfLabel = "이용약관"
        }else if sender.tag == 2 {
            titleOfLabel = "개인정보 수집・이용"
        }else if sender.tag == 3 {
            titleOfLabel = "14세 이상"
        }else if sender.tag == 4 {
            titleOfLabel = "마케팅 정보 수신"
        }
        
        let termsDetailViewController = storyboard?.instantiateViewController(withIdentifier: "TermsDetailViewController") as! TermsDetailViewController
        termsDetailViewController.modalPresentationStyle = .fullScreen
        termsDetailViewController.titleOfLabel = titleOfLabel
        present(termsDetailViewController, animated: true)
    }

    func clickedNextButton(){
        
        //출발점이 애플로그인 버튼인지 회원가입 버튼(이메일)인지를 판단하여
        //애플로그인인 경우는 애플 라이브러리를 통해 회원가입,
        //회원가입 로그인인 경우는 다음 단계로 이동
        
        if isAppleLogin == true {
            startSignInWithAppleFlow()
        }else{
            let signUpViewController = storyboard?.instantiateViewController(withIdentifier: "SignUpViewController") as! SignUpViewController
            self.navigationController?.pushViewController(signUpViewController, animated: true)
        }
        
    }
    
    
    //MARK -APPLE LOGIN
    private func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        let charset: Array<Character> =
            Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        var result = ""
        var remainingLength = length
        
        while remainingLength > 0 {
            let randoms: [UInt8] = (0 ..< 16).map { _ in
                var random: UInt8 = 0
                let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
                if errorCode != errSecSuccess {
                    fatalError("Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)")
                }
                return random
            }
            
            randoms.forEach { random in
                if remainingLength == 0 {
                    return
                }
                
                if random < charset.count {
                    result.append(charset[Int(random)])
                    remainingLength -= 1
                }
            }
        }
        
        return result
    }
    
    
    private func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashedData = SHA256.hash(data: inputData)
        let hashString = hashedData.compactMap {
            return String(format: "%02x", $0)
        }.joined()
        
        return hashString
    }
    
    
    

    // Unhashed nonce.
    fileprivate var currentNonce: String?

    @available(iOS 13, *)
    func startSignInWithAppleFlow() {
      let nonce = randomNonceString()
      currentNonce = nonce
      let appleIDProvider = ASAuthorizationAppleIDProvider()
      let request = appleIDProvider.createRequest()
      request.requestedScopes = [.fullName, .email]
      request.nonce = sha256(nonce)

      let authorizationController = ASAuthorizationController(authorizationRequests: [request])
      authorizationController.delegate = self
      authorizationController.presentationContextProvider = self
      authorizationController.performRequests()
    }
    
    
}

@available(iOS 13.0, *)
extension TermsViewController: ASAuthorizationControllerDelegate {

  func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
    if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
      guard let nonce = currentNonce else {
        fatalError("Invalid state: A login callback was received, but no login request was sent.")
      }
      guard let appleIDToken = appleIDCredential.identityToken else {
        print("Unable to fetch identity token")
        return
      }
      guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
        print("Unable to serialize token string from data: \(appleIDToken.debugDescription)")
        return
      }
      // Initialize a Firebase credential.
      let credential = OAuthProvider.credential(withProviderID: "apple.com",
                                                idToken: idTokenString,
                                                rawNonce: nonce)
      // Sign in with Firebase.
      Auth.auth().signIn(with: credential) { (authResult, error) in
          if (error != nil) {
          // Error. If error.code == .MissingOrInvalidNonce, make sure
          // you're sending the SHA256-hashed nonce as a hex string with
          // your request to Apple.
              print(error?.localizedDescription ?? "장애발생")
          return
        }
        // User is signed in to Firebase with Apple.
        // ...
          
          
          guard let user = authResult?.user, error == nil else {
                         print(error!.localizedDescription)
                         return
                       }
          print(user.displayName ?? "알수 없음")
          print(user.email as Any)
          
          //회원가입시 사용자 이메일을 로컬에 userID로 설정
          UserDefaults.standard.setValue(user.email, forKey: "userID")
          
          //회원가입시 MyInfo 구성
          let learningDataDic: [String: [String : Int]] = [
              "Basic":["2" : 0,"3" : 0, "4" : 0, "5" : 0, "6" : 0, "7" : 0, "8" : 0],
              "Advanced":["1" : 0, "2" : 0]]
          MyInfo.shared.displayName = (user.email?.components(separatedBy: "@")[0])!
          MyInfo.shared.learningProgress = learningDataDic
          MyInfo.shared.numberOfHearts = 0
          
          
          //MyInfo를 Firebase에 전송
          DataFromFirestore.share.settingDoc(userID: user.email!, userInfo: MyInfo.shared)
          
          Core.shared.setSignupByApple()
          Core.shared.setUserLogin()
          changeMainNC()
          
      }
    }
      
      
      
  }

  func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
    // Handle error.
    print("Sign in with Apple errored: \(error)")
  }
    
    

}
