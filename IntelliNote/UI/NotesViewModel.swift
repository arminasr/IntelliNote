//
//  NotesViewModel.swift
//  IntelliNote
//
//  Created by Arminas Ruzgas on 2021-01-21.
//

import Foundation
import UIKit

class NotesViewModel: ObservableObject {
    @Published var currentNote = Note()
    @Published var notes: [Note] = []
    @Published var isLoading = false
    
    private var textRecognitionService = TextRecognitionService()
    
    func saveNote(_ note: Note) {
        notes.append(note)
        currentNote = Note()
    }
    
    func deleteNote(at indexSet: IndexSet) {
        notes.remove(atOffsets: indexSet)
    }
    
    func recognizeText(from image: UIImage) {
        isLoading = true
        textRecognitionService.delegate = self
        textRecognitionService.processImage(image)
    }
}

extension NotesViewModel: TextRecognitionServiceDelegate {
    func didRecognizeText(_ text: String) {
        isLoading = false
        currentNote.text.append(text)
    }
    
    func didFailRecognizeText() {
        isLoading = false
    }
}
