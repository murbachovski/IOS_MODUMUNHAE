//
//  TestViewController.swift
//  AI_MUNJANG
//
//  Created by DONG CHEOL KIM on 2022/07/06.
//

import UIKit


class TestViewController: UIViewController,UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!

    
    var tableViewItems = ["단문AI 요청", "8필터AI 요청", "Adaptive View", "OnBoarding", "공통 UI", "로그인 페이지","공통 팝업","약관등","회원가입","비밀번호 재설정", "비밀번호 재설정 상세","회원탈퇴","회원탈퇴 사유", "비밀번호 변경", "구독페이지", "DummyJson 사용", "displayName 변경 및 hearts 추가 그리고 진도율 변경", "exampleAnotherMain", "문장추론", "문장교정", "googleCrash", "더미메인", "쿠폰 생성"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
       
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableViewItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReusableCell", for: indexPath)
        cell.textLabel?.text = tableViewItems[indexPath.row]
        
        if indexPath.row == 15 {
            if QuizContentData.shared.isDummyContensts {
                cell.textLabel?.text = "Dummy Data"
                    
            }else{
                cell.textLabel?.text = "Normal Data"
            }
                
            
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        if indexPath.row == 0 {
            //단문AI 요청,
            let url = "http://118.67.133.8/danmun/m"
            let sen = "나는 학교에 가고 엄마와 회사에 간다."
            requestByDanmun(url:url, sen: sen) { results in
                print(results)
            }
            
        }else if indexPath.row == 1 {
            //8필터 AI 요청,
//            let url = "http://118.67.133.8/eight/m" //Ai모델접근용
//            let url = "http://118.67.133.8/eight_logic/m" //단순 8필터 접근용
            let url = "http://118.67.133.8/sen_infer/m" //문장 추론 접근용
//            let url = "http://127.0.0.1:5000/eight_logic/m"
            let sen = "나는 학교에 가고 VV 수업을 들었다."
//            requestByEight(url:url, sen: sen) { resDic in
//            print(resDic)
//            }
            print("함수 실행 속동:", "+", progressTime({
                print(requestByInfer(url: url, sen: sen) { dicData in
                    for i in dicData {
                        print(i)
                    }
                })
            }))
            
        
        }else if indexPath.row == 2 {
            //아이패드와 모바일 대응
            guard let adaptiveViewController = self.storyboard?.instantiateViewController(withIdentifier: "AdaptiveViewController")  as? AdaptiveViewController else {return}
            navigationController?.pushViewController(adaptiveViewController, animated: true)
        
        }else if indexPath.row == 3 { 
            //OnBoarding 보여주기 위해 설정값 변경
            UserDefaults.standard.set(false, forKey: "isNewUser")
         
        }else if indexPath.row == 4 {
           //OnBoarding 보여주기
           guard let commonUIViewController = self.storyboard?.instantiateViewController(withIdentifier: "CommonUIViewController")  as? CommonUIViewController else {return}
           navigationController?.pushViewController(commonUIViewController, animated: true)
        }else if indexPath.row == 5 {
          //OnBoarding 보여주기
          guard let loginViewController = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController")  as? LoginViewController else {return}
          loginViewController.modalPresentationStyle = .fullScreen
          self.present(loginViewController, animated: true)
        }else if indexPath.row == 6 {
            let alertVC = AlertService().alert(title: "공지사항",
                                            body: "이게 기본이에요! 하지만 나는 애니메이션 하는동안...cell 클릭하면 그에 맞는행동들이 실행됐으면 좋겠어 하면 allowUserInteraction옵션을 사용하면 됩니다",
                                            cancelTitle: "아니요",
                                            confirTitle: "좋아요" ,
                                            thirdButtonCompletion: {
                                                 print("thirdButton Clicked -> 취소")
                                             }, fourthButtonCompletion: {
                                                 print("fourthButton Clicked -> 확인")
                                             }
         )
         present(alertVC, animated: true, completion: nil)
        }else if indexPath.row == 7 {
            //OnBoarding 보여주기
            guard let termsViewController = self.storyboard?.instantiateViewController(withIdentifier: "TermsViewController")  as? TermsViewController else {return}
            termsViewController.modalPresentationStyle = .fullScreen
            self.present(termsViewController, animated: true)
        }else if indexPath.row == 8 {
            //OnBoarding 보여주기
            guard let signUpViewController = self.storyboard?.instantiateViewController(withIdentifier: "SignUpViewController")  as? SignUpViewController else {return}
            signUpViewController.modalPresentationStyle = .fullScreen
            self.present(signUpViewController, animated: true)
        }else if indexPath.row == 9 {
            
            guard let resetPasswordViewController = self.storyboard?.instantiateViewController(withIdentifier: "ResetPasswordViewController")  as? ResetPasswordViewController else {return}
            resetPasswordViewController.modalPresentationStyle = .fullScreen
            self.present(resetPasswordViewController, animated: true)
        }else if indexPath.row == 10 {
            
            guard let resetPasswordDetailViewController = self.storyboard?.instantiateViewController(withIdentifier: "ResetPasswordDetailViewController")  as? ResetPasswordDetailViewController else {return}
            resetPasswordDetailViewController.modalPresentationStyle = .fullScreen
            self.present(resetPasswordDetailViewController, animated: true)
        }else if indexPath.row == 11 {
            
            guard let resignViewController = self.storyboard?.instantiateViewController(withIdentifier: "ResignViewController")  as? ResignViewController else {return}
            resignViewController.modalPresentationStyle = .fullScreen
            self.present(resignViewController, animated: true)
            
        }else if indexPath.row == 12 {
            
            guard let resignReasonViewController = self.storyboard?.instantiateViewController(withIdentifier: "ResignReasonViewController")  as? ResignReasonViewController else {return}
            resignReasonViewController.modalPresentationStyle = .fullScreen
            self.present(resignReasonViewController, animated: true)
        }else if indexPath.row == 13 {
            
            guard let changePasswordViewController = self.storyboard?.instantiateViewController(withIdentifier: "ChangePasswordViewController")  as? ChangePasswordViewController else {return}
            changePasswordViewController.modalPresentationStyle = .fullScreen
            self.present(changePasswordViewController, animated: true)
        }else if indexPath.row == 14 {
            
            guard let subscriptionViewController = self.storyboard?.instantiateViewController(withIdentifier: "SubscriptionViewController")  as? SubscriptionViewController else {return}
            subscriptionViewController.modalPresentationStyle = .fullScreen
            self.present(subscriptionViewController, animated: true)
        }else if indexPath.row == 15 {
            
            if QuizContentData.shared.isDummyContensts == false {
                QuizContentData.shared.isDummyContensts = true
                QuizContentData.shared.loadingContents(fileName: "dummyContents")
                tableView.cellForRow(at: indexPath)?.textLabel?.text = "Dummy Data"
            }else{
                QuizContentData.shared.isDummyContensts = false
                QuizContentData.shared.loadingContents(fileName: "quizContents")
                tableView.cellForRow(at: indexPath)?.textLabel?.text = "Normal Data"
            }
            changeMainNC()
            
            
        }else if indexPath.row == 16 {
            
            MyInfo.shared.displayName = "스미나"
//            MyInfo.shared.learningProgress = 3
            MyInfo.shared.numberOfHearts = 104
        }
        else if indexPath.row == 17 {
            //exampleAnotherMain
            guard let MunjangEightViewController = self.storyboard?.instantiateViewController(withIdentifier: "MunjangEightViewController")  as? MunjangEightViewController else {return}
            MunjangEightViewController.modalPresentationStyle = .fullScreen
            self.present(MunjangEightViewController, animated: true)
            
        }else if indexPath.row == 18 {
            //exampleAnotherMain
            guard let inferenceViewController = self.storyboard?.instantiateViewController(withIdentifier: "InferenceViewController")  as? InferenceViewController else {return}
//            inferenceViewController.modalPresentationStyle = .fullScreen
            self.present(inferenceViewController, animated: true)
            
        }else if indexPath.row == 19 {
//            let url = "http://118.67.133.8/sen_correction/m"
            let url = "http://127.0.0.1:5000/sen_correction/m"
            let sen = "나는 학교에 가고 엄마와 회사에 간다."
            requestByCorrection(url: url, sen: sen) { dicData in
                for i in dicData {
                    print(i)
                    DispatchQueue.main.async {
                        guard let correctionViewController = self.storyboard?.instantiateViewController(withIdentifier: "CorrectionViewController")  as? CorrectionViewController else {return}
                        correctionViewController.dicData = dicData
                        correctionViewController.originSentence = sen
                        self.present(correctionViewController, animated: true)
                    }
                }
            }
        }else if indexPath.row == 20 {
            fatalError("Crash was triggered")
        }else if indexPath.row == 21 {
            //exampleAnotherMain
            guard let dummyMainViewController = self.storyboard?.instantiateViewController(withIdentifier: "DummyMainViewController")  as? DummyMainViewController else {return}
//            dummyMainViewController.modalPresentationStyle = .fullScreen
            self.present(dummyMainViewController, animated: true)
        }else if indexPath.row == 22 {
           //쿠폰 생성하기
//            generateCoupons() //함부로 동작시키지 말 것..
        }
        
    }
    

}
