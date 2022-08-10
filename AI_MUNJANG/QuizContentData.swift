//
//  QuizContentData.swift
//  AI_MUNJANG
//
//  Created by admin on 2022/08/10.
//

import Foundation
class QuizContentData {
    static let shared = QuizContentData()

    var id: String?
    var password: String?
    var name: String?

    
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
        
        
    }
}
