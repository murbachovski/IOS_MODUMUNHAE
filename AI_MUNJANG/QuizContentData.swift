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

            if content.section == "1경" {
                sectionOne.append(content)
            }
            if content.section == "2경" {
                sectionTwo.append(content)
            }
            if content.section == "3경" {
                sectionThree.append(content)
            }
            if content.section == "4경" {
                sectionFour.append(content)
            }
            if content.section == "5경" {
                sectionFive.append(content)
            }
            if content.section == "6경" {
                sectionSix.append(content)
            }
            if content.section == "7경" {
                sectionSeven.append(content)
            }
            if content.section == "8경" {
                sectionEight.append(content)
            }

            sectionTotal = [sectionOne, sectionTwo, sectionThree, sectionFour, sectionFive, sectionSix, sectionSeven, sectionEight]
            
        }
    }
    
    private func readLocalFile(forName name: String) -> Data? {
        do {
//            if let bundlePath = Bundle.main.path(forResource: name,
//                                                 ofType: "json"),
//
//            }
            
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
