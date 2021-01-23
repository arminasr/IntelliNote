//
//  TextRecognitionService.swift
//  IntelliNote
//
//  Created by Arminas Ruzgas on 2021-01-22.
//

import Vision

protocol TextRecognitionServiceDelegate: class {
    func didRecognizeTextFromImage(_ text: String)
    func didFailRecognizeTextFromImage()
}

class TextRecognitionService {
    weak var delegate: TextRecognitionServiceDelegate?
    
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
}

extension TextRecognitionService {
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


