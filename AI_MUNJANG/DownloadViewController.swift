//
//  DownloadViewController.swift
//  AI_MUNJANG
//
//  Created by murba chovski on 2022/08/18.
//

import UIKit

class DownloadViewController: UIViewController, URLSessionDataDelegate {

    var curVersion = UserDefaults.standard.integer(forKey: "version_number")
    var serverVersion = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
        
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        Task{
            await checkToFowardScreen()
        }
    }
    
 
    
    func checkToFowardScreen() async  {
        await checkTheVersion(completion: { needs in
            DispatchQueue.main.async {
                if needs == true{
                    print("업데이트 필요")
                    self.updateContens()
                }else{
                    print("업데이트 불필요")
                    self.changeViewController()
                }
            }
        })
    }
        
    
    func updateContens(){
        //contens json을 다운로드 한다.
        
        
    }
  
    func checkTheVersion(completion: @escaping (Bool)->Void )  async{
        
        let urlString = "http://118.67.133.8/version_number"
        var request = URLRequest(url: URL(string: urlString)! )
            
        request.httpMethod = "GET"
        
        let task =  URLSession.shared.dataTask(with: request) { data, response, error in
          guard let data = data else {
            print(String(describing: error))

            return
          }

            let str = String(decoding: data, as: UTF8.self)
                   print("결과물: \(str)")
            
            var dicData : Dictionary<String, Int> = [String : Int]()
                    do {
                        // 딕셔너리에 데이터 저장 실시
                        dicData = try JSONSerialization.jsonObject(with: Data(str.utf8), options: []) as! [String:Int]
                        print("version_number_res: \(dicData["version_number"]! )")
                        self.serverVersion = dicData["version_number"]!
                        UserDefaults.standard.set(self.serverVersion, forKey: "version_number")
                        if self.curVersion < self.serverVersion {
                            completion(true)
                        }else{
                            completion(false)
                        }
                    } catch {
                        print(error.localizedDescription)
                    }
                             
        }
        task.resume()
    }
    
    fileprivate func changeViewController() {
        if Core.shared.isNewUser(){
            let vc = UIStoryboard(name: "Main", bundle: .main).instantiateViewController(withIdentifier: "OnBoardingViewController") as! OnBoardingViewController
            vc.modalPresentationStyle = .fullScreen
            vc.modalTransitionStyle = .crossDissolve
            self.present(vc, animated: true)
            
        }else{
            let nc = UIStoryboard(name: "Main", bundle: .main).instantiateViewController(withIdentifier: "mainNavigationController") as! UINavigationController
            nc.modalPresentationStyle = .fullScreen
            nc.modalTransitionStyle = .crossDissolve
            self.present(nc, animated: true)
        }
    }
    
    
}
