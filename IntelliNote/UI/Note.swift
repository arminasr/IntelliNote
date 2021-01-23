//
//  Note.swift
//  IntelliNote
//
//  Created by Arminas Ruzgas on 2021-01-21.
//

import Foundation
import Combine

class Note: Identifiable, ObservableObject {
    var text: String = ""
    var id = UUID()
    var language: String?
}
