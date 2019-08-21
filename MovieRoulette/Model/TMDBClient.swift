//
//  TMDBClient.swift
//  MovieRoulette
//
//  Created by Michael Maryanoff on 8/20/19.
//  Copyright © 2019 Michael Maryanoff. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire

class TMDBClient {
    
    static let apiKey = "***REMOVED***"
    
    enum Endpoints {
        static let base = "https://api.themoviedb.org/3"
        static let apiKeyParam = "?api_key=\(TMDBClient.apiKey)"
        
        case getGenres
        
        var stringValue: String {
            switch self {
            case .getGenres: return Endpoints.base + "/genre/movie/list" + Endpoints.apiKeyParam
            }
        }
        
        var url: URL {
            return URL(string: stringValue)!
        }
        
    }
    
    class func getGenres() {
        print(Endpoints.getGenres.url)
        AF.request(Endpoints.getGenres.url).responseJSON { (response) in
            print("Request: \(String(describing: response.request!))")
            print("Result: \(response.result)")
        }
    }
    
    
}
