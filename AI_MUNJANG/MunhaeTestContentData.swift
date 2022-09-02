//
//  QuizContentData.swift
//  AI_MUNJANG
//
//  Created by admin on 2022/08/10.
//

import Foundation
class MunhaeTestContentData {
    static let shared = MunhaeTestContentData()

    var munhaeTestTotal :[MunhaeTestContent] = []
    
    private init() {
        loadingContents(fileName:"munhaeTestContents")
    }
    
    func loadingContents(fileName:String){
        
        guard let munhaeTestData = readLocalFile(forName:fileName) else { print("quizData is null"); return}
        guard let munhaeTestContents = try? JSONDecoder().decode(MunhaeTestContents.self, from: munhaeTestData) else { print("quizContens is null");  return }
        munhaeTestTotal = munhaeTestContents
//        print(munhaeTestTotal)
    }
    
    private func readLocalFile(forName name: String) -> Data? {
        do {
            
            let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString
            let jsonPath = paths.appendingPathComponent(name + ".json")
            let jsonData = try String(contentsOfFile: jsonPath).data(using: .utf8)
                return jsonData

        } catch {
            print(error)
        }
        
        return nil
    }
}
