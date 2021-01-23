//
//  SpeechRecognitionService.swift
//  IntelliNote
//
//  Created by Arminas Ruzgas on 2021-01-23.
//

import Speech

protocol SpeechRecognitionServiceDelegate: class {
    func didRecogniceTextFromAudio(_ text: String)
    func didFailRecognizeFromAudio()
}

class SpeechRecognitionService {
    weak var delegate: SpeechRecognitionServiceDelegate?
    
    init() {
        requestAuthorization()
    }
    
    func recognizeText(fromAudioFileWith url: URL) {
        guard let speechRecognizer = SFSpeechRecognizer(), speechRecognizer.isAvailable else {
            print("A recognizer is not supported for the current locale")
            delegate?.didFailRecognizeFromAudio()
            return
        }
        
        let request = SFSpeechURLRecognitionRequest(url: url)
        speechRecognizer.recognitionTask(with: request) { [weak self] (result, error) in
            guard let result = result else {
                print("Recognition failed with error: \(String(describing: error?.localizedDescription))")
                self?.delegate?.didFailRecognizeFromAudio()
                return
            }
            
            if result.isFinal {
                self?.delegate?.didRecogniceTextFromAudio(result.bestTranscription.formattedString)
            }
        }
        
    }
    
    private func requestAuthorization() {
        SFSpeechRecognizer.requestAuthorization { authStatus in
            OperationQueue.main.addOperation {
                switch authStatus {
                case .authorized:
                    print("authorized")
                case .denied:
                    print("User denied access to speech recognition")
                case .restricted:
                    print("Speech recognition restricted on this device")
                case .notDetermined:
                    print("Speech recognition not yet authorized")
                @unknown default:
                    fatalError()
                }
            }
        }
    }
}
