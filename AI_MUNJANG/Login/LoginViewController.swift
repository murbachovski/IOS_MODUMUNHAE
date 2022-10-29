//
//  LoginViewController.swift
//  AI_MUNJANG
//
//  Created by admin on 2022/07/13.
//

import UIKit
import DropDown
import FirebaseAuth
import CryptoKit
import AuthenticationServices
//import NVActivityIndicatorView

class LoginViewController: UIViewController, ShowDropDelegate, CheckEmailAndPasswordValid, ASAuthorizationControllerPresentationContextProviding {
    @IBOutlet weak var logoimag: UIImageView!
    
    
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return view.window!
    }
    
    
   
//    let indicator = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50),
//                                            type: .lineSpinFadeLoader,
//                                            color: hexStringToUIColor(hex: "#f7f9fb"),
//                                            padding: 0)
    lazy var indicator: UIActivityIndicatorView = {
            // 해당 클로저에서 나중에 indicator 를 반환해주기 위해 상수형태로 선언
            let activityIndicator = UIActivityIndicatorView()
            
            activityIndicator.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
            
            activityIndicator.center = self.view.center
            
            // 기타 옵션
        activityIndicator.color = hexStringToUIColor(hex: Constants.primaryColor)
            activityIndicator.hidesWhenStopped = true
            activityIndicator.style = .medium
            
            // stopAnimating을 걸어주는 이유는, 최초에 해당 indicator가 선언되었을 때, 멈춘 상태로 있기 위해서
            activityIndicator.stopAnimating()
            
            return activityIndicator
            
        }()
    
    let dropdown = DropDown()
    var isUserSignUp = false

    @IBOutlet weak var emailContainerView: CustomEmailView!
    @IBOutlet weak var passwordContainerView: CustomPasswordView!
    
    @IBOutlet weak var loginButtonView: CustomButtonView!
    @IBOutlet weak var appleLoginButtonView: CustomButtonView!
    
    @IBOutlet weak var onlyTourButton: UIButton!
    
    @IBOutlet weak var searchPasswordButton: UIButton!
    
    @IBOutlet weak var tourStackView: UIStackView!
    
    var itemList = ["@naver.com","@hanmail.com","@daum.net","@gmail.com","@nate.com","@hotmail.com","@outlook.com","@icloud.com","@yahoo.com",
                "@lycos.co.kr","@dreamwiz.com","@empal.com","@korea.com","@paran.com","@empas.com","@me.com","@chol.com"]
 

    override func viewDidLoad() {
        super.viewDidLoad()
        //로그인페이지에서 비밀번호 재설정 혹은 회원가입페이지의 백버튼의 타이틀을 삭제
        self.navigationItem.backButtonTitle = " "
        
       
        isUserSignUp = Core.shared.isUserSignup()
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification , object: nil)
        
        if isUserSignUp == false {
            tourStackView.isHidden = false
            onlyTourButton.isHidden = false
            onlyTourButton.layer.cornerRadius = 10
            
            
        }else{
            tourStackView.isHidden = true
            
        }
        setupUI()
        
        self.view.addSubview(indicator)
        indicator.center = view.center
        

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loginButtonView.button.setTitleColor(.lightGray, for: .normal)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
        if indicator.isAnimating {
            indicator.stopAnimating()
        }
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        initDropDownUI()
        setDropdown()
    }
 
    fileprivate func setupUI() {
    
        
        emailContainerView.delegate = self
        emailContainerView.checkEmailDelegate = self
        emailContainerView.textField.keyboardType = .emailAddress
        
        passwordContainerView.textField.isSecureTextEntry = true
        passwordContainerView.textField.textContentType = .oneTimeCode
        passwordContainerView.textField.enablePasswordToggle()
        passwordContainerView.checkEmailDelegate = self
        
        
        appleLoginButtonView.button.layer.cornerRadius = 8
        appleLoginButtonView.button.setTitle("  Apple 계정으로 로그인", for: .normal)
        appleLoginButtonView.button.setImage(UIImage(named: "Apple Logo"), for: .normal)
        appleLoginButtonView.button.titleLabel?.font =  UIFont(name: "NanumSquareEB", size: 17)
        appleLoginButtonView.button.backgroundColor = .black
        appleLoginButtonView.buttonCompletion {
            self.clickedByAppleUser()            
        }
        
        
        loginButtonView.button.layer.cornerRadius = 8
        loginButtonView.button.setTitle("로그인", for: .normal)

        

        loginButtonView.convertButtonStatus(status: false, backgroundColor: hexStringToUIColor(hex: "#F7F7F7"), titleColor: .white)
        loginButtonView.buttonCompletion {
            self.clickedByEmailUser()
        }
    
        onlyTourButton.titleLabel?.font =  UIFont(name: "NanumSquareB", size: 17)
    }
    
    func initDropDownUI(){
        // DropDown View의 배경
        DropDown.appearance().textColor = UIColor.black // 아이템 텍스트 색상
        DropDown.appearance().selectedTextColor = UIColor.red // 선택된 아이템 텍스트 색상
        DropDown.appearance().backgroundColor = UIColor.white // 아이템 팝업 배경 색상
        DropDown.appearance().selectionBackgroundColor = UIColor.lightGray // 선택한 아이템 배경 색상
        DropDown.appearance().setupCornerRadius(8)
        dropdown.dismissMode = .automatic // 팝업을 닫을 모드 설정
    }
    
    func setDropdown() {
        // dataSource로 ItemList를 연결
        let itemList_added = itemList.map{ "\(emailContainerView.textField!.text ?? "")\($0)" }

        
        dropdown.dataSource = itemList_added
        
        // anchorView를 통해 UI와 연결
        dropdown.anchorView = self.emailContainerView.containerView
        
        // View를 갖리지 않고 View아래에 Item 팝업이 붙도록 설정
        dropdown.bottomOffset = CGPoint(x: 0, y: 40)
        
        // Item 선택 시 처리
        dropdown.selectionAction = { [weak self] (index, item) in
            //선택한 Item을 TextField에 넣어준다.
            self?.emailContainerView.textField.text = item
            
        }
        
        // 취소 시 처리
        dropdown.cancelAction = { [weak self] in
            //빈 화면 터치 시 DropDown이 사라지고 아이콘을 원래대로 변경
           
        }
    }
    
    func showDrop() {
        dropdown.show() // 아이템 팝업을 보여준다.
    }
    
    func checkEmailAndPasswordValid() {
        print("checkEmailAndPasswordValid is called")
        //Email의
        if emailContainerView.isValidStatus == true && passwordContainerView.isValidStatus == true {
            loginButtonView.convertButtonStatus(status: true, backgroundColor: hexStringToUIColor(hex: Constants.primaryColor), titleColor: .white)
        }else{
            loginButtonView.convertButtonStatus(status: false, backgroundColor: hexStringToUIColor(hex: "#F7F7F7"), titleColor: .white)
            loginButtonView.button.setTitleColor(.lightGray, for: .normal)
            
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification){
         print("keyboardWillHide")
        
        //이메일과 비밀번호가 정상적으로 입력되었는지 판단하여 이메일 버튼 활성화 여부 판단
        checkEmailAndPassword()
    }
    
    fileprivate func checkEmailAndPassword(){
        if let emailError = emailContainerView.subLabel.text, emailError.count == 0, let passwordError = passwordContainerView.noticeLabel.text, passwordError.count == 0  {
            if emailContainerView.textField.text?.count ?? -1 > 0 && passwordContainerView.textField.text?.count ?? -1 > 7 {
                loginButtonView.convertButtonStatus(status: true, backgroundColor: hexStringToUIColor(hex: Constants.primaryColor), titleColor: .white)
                }
            }
    }
    
    
    
   
    
    fileprivate func clickedByEmailUser(){
        print("EmailUser is clicked")
        indicator.startAnimating()
        emailContainerView.textField.resignFirstResponder()
        passwordContainerView.textField.resignFirstResponder()
        
        
        guard let email = emailContainerView.textField.text else { return }
        guard let password = passwordContainerView.textField.text else {return}
        
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
            self!.indicator.stopAnimating()
            if error != nil {
                // 1 이렇게 해야 한다. 권장0
                if let errorInforKey = error?._userInfo?["FIRAuthErrorUserInfoNameKey"] {
                    print("이메일 로그인에러: \(errorInforKey!)")
                    var errorString = ""
                    if errorInforKey as! String == "ERROR_WRONG_PASSWORD" {
                        print("ERROR_WRONG_PASSWORD")
                        errorString = "비밀번호를 다시 한 번 확인해주세요."
                        self?.passwordContainerView.textField.text = ""
                    }else if errorInforKey as! String == "ERROR_USER_NOT_FOUND" {
                        print("ERROR_USER_NOT_FOUND")
                       errorString = "가입된 이메일이 아닙니다."
                        self?.emailContainerView.textField.text = ""
                        self?.passwordContainerView.textField.text = ""
                    }else if errorInforKey as! String == "ERROR_NETWORK_REQUEST_FAILED" {
                        errorString = "네트워크 연결이 불안정합니다."
                    }else{
                        errorString = "알 수 없는 원인으로 \n로그인 요청에 장애가 발생했습니다. \n나중에 다시 시도해 주세요."
                    }
                    
                    let alert = AlertService().alert(title: "", body:errorString, cancelTitle: "", confirTitle: "확인", thirdButtonCompletion: nil, fourthButtonCompletion: nil)
                    self?.present(alert, animated: true)
 
                }
                
            }else{
                guard let user = authResult?.user, error == nil else {
                               print(error!.localizedDescription)                    
                               return
                             }
                print(user.displayName ?? "displayName 없음")
                print(user.email as Any)
                Core.shared.setUserLogin()
                
                print("\(user.displayName ?? "displayName 없음")정상적으로 로그인되었습니다")
                UserDefaults.standard.setValue(user.email, forKey: "userID")
                self?.setUpMyInfoByUserId()
                changeMainNC()
               
                
            }
            
        }
    }
    
    @IBAction func searchPasswordButton(_ sender: Any) {
        print("비밀번호 찾기 클릭됨.")
        
        guard let resetPasswordViewController = self.storyboard?.instantiateViewController(withIdentifier: "ResetPasswordViewController")  as? ResetPasswordViewController else {return}
        self.navigationController?.pushViewController(resetPasswordViewController, animated: true)
    }
    
    @IBAction func registerMembershipButton(_ sender: Any) {
        print("회원가입 버튼 클릭됨")
        guard let termsViewController = self.storyboard?.instantiateViewController(withIdentifier: "TermsViewController")  as? TermsViewController else {return}
        self.navigationController?.pushViewController(termsViewController, animated: true)
    }
    
    @IBAction func clickedOnlyTourButton(_ sender: Any) {
        print("그냥 구경만 할게요 클릭됨.")
        Core.shared.setIsNotUser()
        changeMainNC()
        
    }

    fileprivate func clickedByAppleUser(){
        if Core.shared.isSignupByApple() {
            startSignInWithAppleFlow()
        }else{
            guard let termsViewController = self.storyboard?.instantiateViewController(withIdentifier: "TermsViewController")  as? TermsViewController else {return}
            termsViewController.isAppleLogin = true
            self.navigationController?.pushViewController(termsViewController, animated: true)
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
extension LoginViewController: ASAuthorizationControllerDelegate {

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
          
          Core.shared.setUserLogin()
          print(user.displayName ?? "알수 없음")
          print(user.email as Any)
          UserDefaults.standard.setValue(user.email, forKey: "userID")
          self.setUpMyInfoByUserId()
          changeMainNC()
          
      }
    }
      
      
      
  }

  func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
    // Handle error.
    print("Sign in with Apple errored: \(error)")
  }
    
    fileprivate func setUpMyInfoByUserId() {
        if Core.shared.isUserLogin() == true {
            if let userID = UserDefaults.standard.value(forKey: "userID") as? String {
                print("login is called: \(userID)")
                DataFromFirestore.share.gettingDoc(userID: userID) { info in
                    MyInfo.shared.displayName = info.displayName
                    MyInfo.shared.learningProgress = info.learningProgress
                    MyInfo.shared.numberOfHearts = info.numberOfHearts
                    
                    print("😊😊😊😊😊😊😊login userInfo: \(MyInfo.shared)")
                }
            }
        }
    }

}
