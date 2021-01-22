//
//  TextRecognitionService.swift
//  IntelliNote
//
//  Created by Arminas Ruzgas on 2021-01-22.
//

import UIKit
import Vision

protocol TextRecognitionServiceDelegate: class {
    func didRecognizeText(_ text: String)
    func didFailRecognizeText()
}

class TextRecognitionService {
    private var textRecognitionRequest = VNRecognizeTextRequest()
    weak var delegate: TextRecognitionServiceDelegate?
    
    init() {
        textRecognitionRequest = VNRecognizeTextRequest (completionHandler: { [weak self] (request, error) in
            if let recognizedText = request.results as? [VNRecognizedTextObservation] {
                let maximumCandidates = 1
                var transcript = ""
                
                for observation in recognizedText {
                    guard let candidate = observation.topCandidates(maximumCandidates).first else { continue }
                    transcript += candidate.string
                    transcript += "\n"
                }
                DispatchQueue.main.async { [weak self] in
                    self?.delegate?.didRecognizeText(transcript)
                }
            }
        })
    }
    
    func processImage(_ image: UIImage) {
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let cgImage = image.cgImage,
                  let textRecognitionRequest = self?.textRecognitionRequest else {
                self?.delegate?.didFailRecognizeText()
                return
            }
            
            let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
            do {
                try handler.perform([textRecognitionRequest])
            } catch {
                self?.delegate?.didFailRecognizeText()
            }
        }
    }
}
