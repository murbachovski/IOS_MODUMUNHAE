// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let quizContents = try? newJSONDecoder().decode(QuizContents.self, from: jsonData)

import Foundation

// MARK: - QuizContent
struct MunhaeTestContent: Codable {
    let id: Int
    let title: String
    let jimun: String?
    let example: String
    let result: String

    enum CodingKeys: String, CodingKey {
        case id = "ID"
        case title = "Title"
        case jimun = "Jimun"
        case example = "Example"
        case result = "Result"
    }
}

typealias MunhaeTestContents = [MunhaeTestContent]

