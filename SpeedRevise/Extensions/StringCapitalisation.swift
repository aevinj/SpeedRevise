//
//  StringCapitalisation.swift
//  SpeedRevise
//
//  Created by Aevin Jais on 04/06/2024.
//

extension String {
    var capitalizedFirst: String {
        guard let first = self.first else { return self }
        return first.uppercased() + self.dropFirst()
    }
}
