//
//  NotesViewModel.swift
//  IntelliNote
//
//  Created by Arminas Ruzgas on 2021-01-21.
//

import UIKit

class NotesViewModel: ObservableObject {
    @Published var currentNote = Note()
    @Published var notes: [Note] = []
    @Published var isLoading = false
    
    private var textRecognitionService = TextRecognitionService()
    private var speechRecognitionService = SpeechRecognitionService()
    private var languageRecognitionService = LanguageRecognitionService()
    
    func saveNote(_ note: Note) {
        note.language = recognizeLanguage(in: note)
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
        speechRecognitionService.delegate = self
        speechRecognitionService.recognizeText(fromAudioFileWith: audioUrl)
    }
    
    private func recognizeLanguage(in note: Note) -> String? {
        return languageRecognitionService.detectedLanguage(for: note.text)
    }
}

extension NotesViewModel: TextRecognitionServiceDelegate {
    func didRecognizeTextFromImage(_ text: String) {
        isLoading = false
        currentNote.text.append(text)
        currentNote.language = recognizeLanguage(in: currentNote)
    }
    
    func didFailRecognizeTextFromImage() {
        isLoading = false
    }
}

extension NotesViewModel: SpeechRecognitionServiceDelegate {
    func didRecogniceTextFromAudio(_ text: String) {
        isLoading = false
        currentNote.text.append(text)
        currentNote.language = recognizeLanguage(in: currentNote)
    }
    
    func didFailRecognizeFromAudio() {
        isLoading = false
    }
}
