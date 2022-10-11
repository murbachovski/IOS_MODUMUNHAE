// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let quizContents = try? newJSONDecoder().decode(QuizContents.self, from: jsonData)

import Foundation

// MARK: - QuizContent
struct QuizContent: Codable {
    let header: String
    let level: String
    let id: String
    let type: String
    let section:Int
    let missionSubject:String?  //index0에만 설정
    let mission: Int
    let title: String
    let jimun: String?
    let example: String
    let result, imageName: String?

    enum CodingKeys: String, CodingKey {
        case header: "Header"
        case level: "Level"
        case id = "ID"
        case type = "Type"
        case mission = "Mission"
        case section = "Section"
        case missionSubject = "MissionSubject"
        case title = "Title"
        case jimun = "Jimun"
        case example = "Example"
        case result = "Result"
        case imageName = "ImageName"
    }
}

typealias QuizContents = [QuizContent]
