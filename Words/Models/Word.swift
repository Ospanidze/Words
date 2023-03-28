//
//  Word.swift
//  Words
//
//  Created by Айдар Оспанов on 28.03.2023.
//

import Foundation

struct Word {
    let word: String
    let score: Int
    
    init(word: String, score: Int) {
        self.word = word
        self.score = score
    }
    
    init(wordData: [String: Any]) {
        word = wordData["word"] as? String ?? ""
        score = wordData["score"] as? Int ?? 0
    }
    
    static func getWords(from value: Any) -> [Word] {
        guard let wordsData = value as? [[String: Any]] else { return [] }
        return wordsData.map { Word(wordData: $0) }
    }
}

//struct WelcomeElement: Codable {
//    let word: String
//    let score: Int
//    let tags: [Tag]
//}
//
//enum Tag: String, Codable {
//    case adj = "adj"
//    case adv = "adv"
//    case n = "n"
//    case prop = "prop"
//    case resultsTypeBackfillGloss = "results_type:backfill_gloss"
//    case resultsTypePrimaryExternal = "results_type:primary_external"
//    case syn = "syn"
//    case tagN = "N"
//    case v = "v"
//}
