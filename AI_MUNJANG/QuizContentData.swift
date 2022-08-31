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
    var sectionZero :QuizContents = []
    var sectionOne :QuizContents = []
    var sectionTwo :QuizContents = []
    var sectionThree :QuizContents = []
    var sectionFour :QuizContents = []
    var sectionFive :QuizContents = []
    var sectionSix :QuizContents = []
    var sectionSeven :QuizContents = []
    var sectionEight :QuizContents = []

    var sectionTotal :[QuizContents] = []
    
    private init() {
        loadingContents(fileName:"quizContents")
    }
    
    func loadingContents(fileName:String){
        
         sectionOne  = []
         sectionTwo  = []
         sectionThree  = []
         sectionFour  = []
         sectionFive  = []
         sectionSix  = []
         sectionSeven  = []
         sectionEight  = []

         sectionTotal  = []
        
        guard let quizData = readLocalFile(forName:fileName) else { print("quizData is null"); return}
        guard let quizContents = try? JSONDecoder().decode(QuizContents.self, from: quizData) else { print("quizContens is null");  return }
        
        for  content in quizContents {

            if content.section == 1 {
                sectionZero.append(content)
            }
            if content.section == 2 {
                sectionOne.append(content)
            }
            if content.section == 3 {
                sectionTwo.append(content)
            }
            if content.section == 4 {
                sectionThree.append(content)
            }
            if content.section == 5 {
                sectionFour.append(content)
            }
            if content.section == 6 {
                sectionFive.append(content)
            }
            if content.section == 7 {
                sectionSix.append(content)
            }
            if content.section == 8 {
                sectionSeven.append(content)
            }
            if content.section == 9 {
                sectionEight.append(content)
            }

            sectionTotal = [sectionZero, sectionOne, sectionTwo, sectionThree, sectionFour, sectionFive, sectionSix, sectionSeven, sectionEight]
            
        }
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
