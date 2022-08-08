// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let quizContents = try? newJSONDecoder().decode(QuizContents.self, from: jsonData)

import Foundation

// MARK: - QuizContent
struct QuizContent: Codable {
    let id: String
    let type: String
    let section: String
    let mission: Int
    let title: String
    let jimun: String?
    let example: String
    let result, imageName: String?

    enum CodingKeys: String, CodingKey {
        case id = "ID"
        case type = "Type"
        case section = "Section"
        case mission = "Mission"
        case title = "Title"
        case jimun = "Jimun"
        case example = "Example"
        case result = "Result"
        case imageName = "ImageName"
    }
}
//
//enum Section: String, Codable {
//    case the1경 = "1경"
//    case the2경 = "2경"
//    case the3경 = "3경"
//    case the4경 = "4경"
//    case the5경 = "5경"
//    case the6경 = "6경"
//}
//
//enum TypeEnum: String, Codable {
//    case image = "Image"
//    case text = "Text"
//}

typealias QuizContents = [QuizContent]
