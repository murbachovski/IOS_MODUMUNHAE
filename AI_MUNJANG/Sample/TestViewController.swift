//
//  TestViewController.swift
//  AI_MUNJANG
//
//  Created by DONG CHEOL KIM on 2022/07/06.
//

import UIKit

class TestViewController: UIViewController,UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    var tableViewItems = ["단문AI 요청", "8필터AI 요청", "Adaptive View"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self

        
        // Do any additional setup after loading the view.
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
        print(indexPath.row)
        
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
        
        } else if indexPath.row == 2 {
      
        guard let adaptiveViewController = self.storyboard?.instantiateViewController(withIdentifier: "AdaptiveViewController")  as? AdaptiveViewController else {return}
        navigationController?.pushViewController(adaptiveViewController, animated: true)
        }
    }

}
