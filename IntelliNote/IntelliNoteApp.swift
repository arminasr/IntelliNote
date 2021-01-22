//
//  IntelliNoteApp.swift
//  IntelliNote
//
//  Created by Arminas Ruzgas on 2021-01-20.
//

import SwiftUI

@main
struct IntelliNoteApp: App {
    var body: some Scene {
        
        WindowGroup {
            NotesView(viewModel: NotesViewModel())
        }
    }
}
