//
//  NetworkManager.swift
//  Words
//
//  Created by Айдар Оспанов on 28.03.2023.
//

import Foundation
import Alamofire

enum Link {
    case wordURL
    
    var url: URL {
        return URL(string: "https://api.datamuse.com/words?ml=ringing+in+the+ears")!
    }
}

final class NetworkManager {
    
    static let shared = NetworkManager()
    
    private init() {}
    
    func fetch(from url: URL, completionHandler: @escaping(Result<[Word], AFError>) -> Void) {
        AF.request(url)
            .validate()
            .responseJSON { dataResponse in
                switch dataResponse.result {
                case .success(let value):
                    let words = Word.getWords(from: value)
                    completionHandler(.success(words))
                case .failure(let error):
                    completionHandler(.failure(error))
                }
            }
    }
    
}
