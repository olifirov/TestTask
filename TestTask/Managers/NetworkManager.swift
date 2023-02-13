//
//  NetworlManager.swift
//  TestTask
//
//  Created by Дмитрий Олифиров on 08.02.2023.
//

import Foundation
import Alamofire

class NetworkManager {
    
    let baseUrl = "https://api.nytimes.com/svc/mostpopular/v2/"
    let mostEmailedRequest = "emailed/30.json"
    let mostShearedRequest = "shared/30.json"
    let mostViewedRequest = "viewed/30.json"
    let apiKey = "?api-key=n8JYFPv1wodA6L6hfcf8xnAPDKfHgrrg"
    
    func getArticles(contentType: ContentType, completionHandler: @escaping ([Article]) -> ()) {
        
        var requestTypeURLString = ""
        
        switch contentType {
        case .mostEmailed:
            requestTypeURLString = mostEmailedRequest
        case .mostShared:
            requestTypeURLString = mostShearedRequest
        case .mostViewed:
            requestTypeURLString = mostViewedRequest
        }
        
        let url = baseUrl + requestTypeURLString + apiKey
        
        AF.request(url, method: .get).responseDecodable(of: Result.self) { response in
            switch response.result {
            case .success(let value):
                completionHandler(value.results)
            case .failure(let error):
                print(error)
            }
        }
    }
}

