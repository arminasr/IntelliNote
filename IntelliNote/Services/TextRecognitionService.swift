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
        
        // 1. Sending the request off the main thread
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let self = self else { return }
            
            //2. Creating object that processes image analysis requests
            let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
            do {
                
                //3. Performing the previously created request
                try handler.perform([self.textRecognitionRequest])
            } catch {
                self.delegate?.didFailRecognizeTextFromImage()
            }
        }
    }
}

extension TextRecognitionService {
    private var textRecognitionRequest: VNRecognizeTextRequest {
        
        // 1. Creating recognize request
        return VNRecognizeTextRequest(completionHandler: { [weak self] (request, error) in
            if let recognizedText = request.results as? [VNRecognizedTextObservation] {
            
                // 2. If request provides a result - take the top candidate from the returned Strings.
                let transcript = recognizedText.reduce("") { result, observation in
                    guard let candidate = observation.topCandidates(1).first?.string else { return "" }
                    return result.appending(candidate) + "\n"
                }
                
                DispatchQueue.main.async { [weak self] in
                    
                    // 3. Inform the delegate about successfull text recognitioon
                    self?.delegate?.didRecognizeTextFromImage(transcript)
                }
            }
        })
    }
}
