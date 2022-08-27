//
//  QuizContentData.swift
//  AI_MUNJANG
//
//  Created by admin on 2022/08/10.
//

import Foundation
class QuizContentData {
    static let shared = QuizContentData()

    var isDummyContensts:Bool = false
    

    var quizContentsList :QuizContents = []
    
    private init() {
        loadingContents(fileName:"quizContents")
    }
    
    func loadingContents(fileName:String){
        

        quizContentsList  = []
        
        guard let quizData = readLocalFile(forName:fileName) else { print("quizData is null"); return}
        guard let quizContents = try? JSONDecoder().decode(QuizContents.self, from: quizData) else {
            print("quizContens is null");
            return }
        
        quizContentsList = quizContents
        print("quizContentsList: \(quizContentsList)")
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
