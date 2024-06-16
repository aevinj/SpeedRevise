//
//  Subject.swift
//  SpeedRevise
//
//  Created by Aevin Jais on 08/06/2024.
//

import Foundation

struct Subject: Identifiable, Codable {
    init(name: String) {
        self.id = UUID().uuidString
        self.name = name
    }
    let id: String
    var name: String
}

struct Topic: Identifiable, Codable {
    init(name: String) {
        self.id = UUID().uuidString
        self.name = name
    }
    let id: String
    let name: String
}

struct Note: Identifiable, Codable {
    let id: String
    var name: String
    var description: String?
    var content: String
    let creationDate: Date
}

struct Quiz: Identifiable, Codable {
    init(name: String, filteredContent: [FilteredMessage], unfilteredContent: [OpenAIMessage], difficulty: Difficulty) {
        self.id = UUID().uuidString
        self.name = name
        self.filteredContent = filteredContent
        self.unfilteredContent = unfilteredContent
        self.creationDate = Date()
        self.difficulty = difficulty
    }
    
    let id: String
    var name: String
    let filteredContent: [FilteredMessage]
    let unfilteredContent: [OpenAIMessage]
    let creationDate: Date
    let difficulty: Difficulty
}

enum Difficulty: String, Codable, CaseIterable, Identifiable{
    case easy
    case medium
    case hard
    
    var id: Self {self}
}
