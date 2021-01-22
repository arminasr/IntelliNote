//
//  TextRecognitionService.swift
//  IntelliNote
//
//  Created by Arminas Ruzgas on 2021-01-22.
//

import Vision
import Speech

protocol TextRecognitionServiceDelegate: class {
    func didRecognizeTextFromImage(_ text: String)
    func didFailRecognizeTextFromImage()
    
    func didRecogniceTextFromAudio(_ text: String)
    func didFailRecognizeFromAudio()
}

class TextRecognitionService {
    weak var delegate: TextRecognitionServiceDelegate?
    
    init() {
        requestAuthorization()
    }
}

// MARK: Vision - Text from Image

extension TextRecognitionService {
    func recognizeText(in cgImage: CGImage) {
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let textRecognitionRequest = self?.textRecognitionRequest else {
                self?.delegate?.didFailRecognizeTextFromImage()
                return
            }
            
            let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
            do {
                try handler.perform([textRecognitionRequest])
            } catch {
                self?.delegate?.didFailRecognizeTextFromImage()
            }
        }
    }
    
    private var textRecognitionRequest: VNRecognizeTextRequest {
        return VNRecognizeTextRequest(completionHandler: { [weak self] (request, error) in
            if let recognizedText = request.results as? [VNRecognizedTextObservation] {
                let maximumCandidates = 1
                var transcript = ""
                
                for observation in recognizedText {
                    guard let candidate = observation.topCandidates(maximumCandidates).first else { continue }
                    transcript += candidate.string
                    transcript += "\n"
                }
                DispatchQueue.main.async { [weak self] in
                    self?.delegate?.didRecognizeTextFromImage(transcript)
                }
            }
        })
    }
}

// MARK: Vision - Text from Audio

extension TextRecognitionService {
    func recognizeText(fromAudioFileWith url: URL) {
        guard let speechRecognizer = SFSpeechRecognizer(), speechRecognizer.isAvailable else {
            print("A recognizer is not supported for the current locale")
            delegate?.didFailRecognizeFromAudio()
            return
        }
        
        let request = SFSpeechURLRecognitionRequest(url: url)
        speechRecognizer.recognitionTask(with: request) { [weak self] (result, error) in
            guard let result = result else {
                print("Recognition failed, so check error for details and handle it")
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
    
    func recognizeFile(url:NSURL) {
       
    }
}
