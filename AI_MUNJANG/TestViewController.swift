//
//  TestViewController.swift
//  AI_MUNJANG
//
//  Created by DONG CHEOL KIM on 2022/07/06.
//

import UIKit

class TestViewController: UIViewController,UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!

    
    var tableViewItems = ["단문AI 요청", "8필터AI 요청", "Adaptive View", "OnBoarding", "공통 UI", "로그인 페이지","공통 팝업","약관등","회원가입","비밀번호 재설정", "비밀번호 재설정 상세","회원탈퇴","회원탈퇴 사유", "비밀번호 변경", "구독페이지"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self

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
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        if indexPath.row == 0 {
            //단문AI 요청,
            let url = "http://118.67.133.8/danmun/m"
            let sen = "나는 학교에 가고 엄마는 회사에 간다."
            requestByDanmun(url:url, sen: sen)
            
        }else if indexPath.row == 1 {
            //8필터 AI 요청,
            let url = "http://118.67.133.8/eight/m"
            let sen = "달팽이는 오렌지에서 기어 나온다."
            requestByEight(url:url, sen: sen)
        
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
        }
        
        
    }

}
