//
//  Note.swift
//  IntelliNote
//
//  Created by Arminas Ruzgas on 2021-01-21.
//

import Foundation

class Note: Identifiable, ObservableObject {
    var id = UUID()
    var text: String = ""
    var sentiment = "🤣"
}
