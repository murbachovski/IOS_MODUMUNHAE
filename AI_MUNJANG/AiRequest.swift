//
//  AiRequest.swift
//  AI_MUNJANG
//
//  Created by DONG CHEOL KIM on 2022/07/06.
//

import Foundation



func requestByEight(url:String, sen:String){
    
    //
    var urlString = "\(url)?sen=\(sen)"
    if let encodedString = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
        print(encodedString)
        urlString = encodedString
    }

    let newUrl = URL(string: urlString)
    var request = URLRequest(url: newUrl!)
    
    request.httpMethod = "POST"

    let task = URLSession.shared.dataTask(with: request) { data, response, error in
      guard let data = data else {
        print(String(describing: error))

        return
      }

        let str = String(decoding: data, as: UTF8.self)
               print("결과물: \(str)")
        
        var dicData : Dictionary<String, Any> = [String : Any]()
                do {
                    // 딕셔너리에 데이터 저장 실시
                    dicData = try JSONSerialization.jsonObject(with: Data(str.utf8), options: []) as! [String:Any]
                } catch {
                    print(error.localizedDescription)
                }
                print("")
                print("===============================")
                print("[ViewController >> Json String to Dictionary]")
                print("dicData : ", dicData)
                print("result : ", dicData["result"] ?? "")
                
                print("===============================")
                print("")

        print("===============================")
        print("eight_div_sen : ", dicData["eight_div_sen"] ?? "")
        print("sen : ", dicData["sen"] ?? "")
        
        let eight_div :Dictionary<String, Any> = dicData["eight_div_sen"] as! [String:Any]
        print("문장확장 : ", eight_div["문장확장"] ?? "")
        print("앞정보확장 : ", eight_div["앞정보확장"] ?? "")
        print("대상 : ", eight_div["대상"] ?? "")
        print("대상알림 : ", eight_div["대상알림"] ?? "")
        print("뒤정보확장 : ", eight_div["뒤정보확장"] ?? "")
        print("정보 : ", eight_div["정보"] ?? "")
        print("정보알림 : ", eight_div["정보알림"] ?? "")
        print("마침표 : ", eight_div["마침표"] ?? "")
                         
    }
    task.resume()
}



func requestByDanmun(url:String, sen:String){
    
    var urlString = "\(url)?sen=\(sen)"
    if let encodedString = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
        print(encodedString)
        urlString = encodedString
    }

    
    let newUrl = URL(string: urlString)
    var request = URLRequest(url: newUrl!)
    
    request.httpMethod = "POST"

    let task = URLSession.shared.dataTask(with: request) { data, response, error in
      guard let data = data else {
        print(String(describing: error))

        return
      }

        let str = String(decoding: data, as: UTF8.self)
               print("결과물: \(str)")
        
        var dicData : Dictionary<String, Any> = [String : Any]()
                do {
                    // 딕셔너리에 데이터 저장 실시
                    dicData = try JSONSerialization.jsonObject(with: Data(str.utf8), options: []) as! [String:Any]
                } catch {
                    print(error.localizedDescription)
                }
                print("")
                print("===============================")
                print("[ViewController >> Json String to Dictionary]")
                print("dicData : ", dicData)
                print("===============================")
                print("")

        print("===============================")
 
        
        let resultDiv : Array<String> = dicData["div_sen"] as! [String]
        print("div_sen : ", resultDiv)
          
    }
    task.resume()
}


func convertStringToDictionary(text: String) -> [String:AnyObject]? {
    if let data = text.data(using: .utf8) {
        do {
            let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String:AnyObject]
            return json
        } catch {
            print("Something went wrong")
        }
    }
    return nil
}

