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
        // Do any additional setup after loading the view.
    }

    @IBAction func clickedTestButton(_ sender: Any) {
        guard let testViewController = self.storyboard?.instantiateViewController(withIdentifier: "TestViewController")  as? TestViewController else {return}
        navigationController?.pushViewController(testViewController, animated: true)
        
    }
}

