//
//  SenListViewController.swift
//  AI_MUNJANG
//
//  Created by admin on 2022/09/19.
//

import UIKit

class SenListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
  
    
    @IBOutlet weak var senListTableView: UITableView!
    var senList:[String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        senListTableView.dataSource = self
        senListTableView.delegate = self
        

        // Do any additional setup after loading the view.
    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return senList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = senList[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        analyzeDanmunAfterEight(str: senList[indexPath.row])
    }
    
    
    private func analyzeDanmunAfterEight(str:String){
        let senToAnalyze:String = str
        
        let urlString = "http://118.67.133.8/gpt_danmun_new"
        
        requestByDanmun(url: urlString, sen: senToAnalyze) { results in
            print("단문results:\(results)")
            
            let changedSentence = results.joined(separator: " VV ")
            print(changedSentence)
            self.requestAnalyzeEight(inputString: changedSentence)
        }
    }
    
    
    func requestAnalyzeEight(inputString: String) {
        let urlString = "http://118.67.133.8/eight_logic/m"

        requestByEight(url: urlString, sen: inputString) { resDic in
            print("resDic:\(resDic)")
            DispatchQueue.main.async {
                guard let analyzeResultViewController = self.storyboard?.instantiateViewController(withIdentifier: "AnalyzeResultViewController")  as? AnalyzeResultViewController else {return}
                analyzeResultViewController.analyzedData = resDic
                self.navigationController?.pushViewController(analyzeResultViewController, animated: true)
            }
        }
    }
}
