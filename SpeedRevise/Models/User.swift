//
//  User.swift
//  SpeedRevise
//
//  Created by Aevin Jais on 01/06/2024.
//

import Foundation

struct User: Identifiable, Codable {
    let id: String
    let firstName: String
    let lastName: String
    let email: String
}
