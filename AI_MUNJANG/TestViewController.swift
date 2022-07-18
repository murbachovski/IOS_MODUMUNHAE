//
//  TestViewController.swift
//  AI_MUNJANG
//
//  Created by DONG CHEOL KIM on 2022/07/06.
//

import UIKit

class TestViewController: UIViewController,UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!

    
    var tableViewItems = ["단문AI 요청", "8필터AI 요청", "Adaptive View", "OnBoarding", "공통 UI", "로그인 페이지","공통 팝업"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self

    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if Core.shared.isNewUser(){
            let vc = storyboard?.instantiateViewController(withIdentifier: "OnBoardingViewController") as! OnBoardingViewController
            vc.modalPresentationStyle = .fullScreen
            present(vc, animated: true)
        }
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
            
        } else if indexPath.row == 1 {
            //8필터 AI 요청,
            let url = "http://118.67.133.8/eight/m"
            let sen = "달팽이는 오렌지에서 기어 나온다."
            requestByEight(url:url, sen: sen)
        
        }else if indexPath.row == 2 {
            //아이패드와 모바일 대응
            guard let adaptiveViewController = self.storyboard?.instantiateViewController(withIdentifier: "AdaptiveViewController")  as? AdaptiveViewController else {return}
            navigationController?.pushViewController(adaptiveViewController, animated: true)
        
        }else if indexPath.row == 3 {
            //OnBoarding 보여주기
         
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
    }
        
        
    }

}
