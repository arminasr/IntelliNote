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
        notes.insert(note, at: 0)
        currentNote = Note()
    }
    
    func deleteNote(at indexSet: IndexSet) {
        notes.remove(atOffsets: indexSet)
    }
    
    func recognizeText(from image: UIImage) {
        isLoading = true
        textRecognitionService.delegate = self
        guard let cgImage = image.cgImage else { isLoading = false
            return
        }
        textRecognitionService.recognizeText(in: cgImage)
    }
    
    func recognizeText(from audioUrl: URL) {
        isLoading = true
        textRecognitionService.delegate = self
        textRecognitionService.recognizeText(fromAudioFileWith: audioUrl)
    }
}

extension NotesViewModel: TextRecognitionServiceDelegate {
    func didRecognizeTextFromImage(_ text: String) {
        isLoading = false
        currentNote.text.append(text)
    }
    
    func didFailRecognizeTextFromImage() {
        isLoading = false
    }
    
    func didRecogniceTextFromAudio(_ text: String) {
        isLoading = false
        currentNote.text.append(text)
    }
    
    func didFailRecognizeFromAudio() {
        isLoading = false
    }
}
