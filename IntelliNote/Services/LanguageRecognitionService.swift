//
//  LanguageRecognitionService.swift
//  IntelliNote
//
//  Created by Arminas Ruzgas on 2021-01-23.
//

import NaturalLanguage


class LanguageRecognitionService {
    func detectedLanguage(for string: String) -> String? {
        guard let languageCode = NLLanguageRecognizer.dominantLanguage(for: string)?.rawValue else {
            return nil
        }

        return Locale.current.localizedString(forIdentifier: languageCode)
    }
}
