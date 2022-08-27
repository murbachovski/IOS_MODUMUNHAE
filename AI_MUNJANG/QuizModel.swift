// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let quizContents = try? newJSONDecoder().decode(QuizContents.self, from: jsonData)

import Foundation

// MARK: - QuizContent
struct QuizContent: Codable {
    let id: String
    let type: String
    let mission: Int
    let title: String
    let jimun: String?
    let example: String
    let result, imageName: String?

    enum CodingKeys: String, CodingKey {
        case id = "ID"
        case type = "Type"
        case mission = "Mission"
        case title = "Title"
        case jimun = "Jimun"
        case example = "Example"
        case result = "Result"
        case imageName = "ImageName"
    }
}

typealias QuizContents = [QuizContent]
