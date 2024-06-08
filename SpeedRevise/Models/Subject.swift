//
//  Subject.swift
//  SpeedRevise
//
//  Created by Aevin Jais on 08/06/2024.
//

import Foundation

struct Subject: Identifiable, Codable {
    let id: String
    var name: String
    var notes: [Note]
    var quizzes: [Quiz]
}

struct Note: Identifiable, Codable {
    let id: String
    var name: String
    var description: String?
    var content: String
    let creationDate: Date
}

struct Quiz: Identifiable, Codable {
    let id: String
    var name: String
    var questions: [Question]
    let creationDate: Date
    let difficulty: Difficulty
}

enum Difficulty: String, Codable {
    case easy
    case medium
    case hard
}

struct Question: Identifiable, Codable {
    let id: String
    let question: String
    let answer: String
}
