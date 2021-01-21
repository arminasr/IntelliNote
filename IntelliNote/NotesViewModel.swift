//
//  NotesViewModel.swift
//  IntelliNote
//
//  Created by Arminas Ruzgas on 2021-01-21.
//

import Foundation

class NotesViewModel: ObservableObject {
    @Published var currentNote = Note()
    @Published var notes: [Note] = []
    
    
    func saveNote(_ note: Note) {
        notes.append(note)
        currentNote = Note()
    }
    
    func deleteNote(at indexSet: IndexSet) {
        notes.remove(atOffsets: indexSet)
    }
}
