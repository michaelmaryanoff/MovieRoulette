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
    
    static func searchForMovies(withTheseGenres genreCodes: Set<Int>?) {
        guard let genreCodes = genreCodes else {
            print("there are no genre codes")
            return
        }
        
        var genreParams = ""
        
        for code in genreCodes {
            let newCodeParam = "&with_genres=\(code)"
            genreParams += newCodeParam
        }
        
        let url = Endpoints.base + "/discover/movie" + Endpoints.apiKeyParam + genreParams
        print(url)
        AF.request(url).responseJSON { (response) in
            print("Response in function is \(response)")
            
        }
        
    }
    
//    class func getGenres() {
//        print(Endpoints.getGenres.url)
//        AF.request(Endpoints.getGenres.url).responseJSON { (response) in
////            print("Request: \(String(describing: response.request!))")
////            print("Result: \(response.result)")
//        }
//    }
    
    
}
