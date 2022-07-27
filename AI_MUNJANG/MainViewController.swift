//
//  MainViewController.swift
//  AI_MUNJANG
//
//  Created by DONG CHEOL KIM on 2022/07/06.
//

import UIKit

class MainViewController: UIViewController {


    override func viewDidLoad() {
        super.viewDidLoad()
 
       

    }
 
 

    //사용자가 구독 페이지 누른 경우 MainViewCotnroller는 그것을 인지하고 회원가입페이지를 띄어야 한다.
    @IBAction func clickedUserIcon(_ sender: UIBarButtonItem) {
        guard let myPageViewController = self.storyboard?.instantiateViewController(withIdentifier: "MyPageViewController")  as? MyPageViewController else {return}
        navigationController?.pushViewController(myPageViewController, animated: true)
    }
    
    @IBAction func clickedTestButton(_ sender: Any) {
        guard let testViewController = self.storyboard?.instantiateViewController(withIdentifier: "TestViewController")  as? TestViewController else {return}
        navigationController?.pushViewController(testViewController, animated: true)
        
    }
}

