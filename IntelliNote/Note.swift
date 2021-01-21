//
//  Note.swift
//  IntelliNote
//
//  Created by Arminas Ruzgas on 2021-01-21.
//

import Foundation

struct Note: Identifiable {
    var id = UUID()
    var text: String = ""
    var title: String {
        var substring = String(text.prefix(50))
        if text.count > substring.count {
            substring += "..."
        }
        return substring
    }
}
