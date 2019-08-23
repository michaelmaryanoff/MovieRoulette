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
    
    
    
    static func searchForMovies(withTheseGenres genreCodes: Set<Int>?, completion: @escaping(Bool, [String], Error?) -> Void) {
        
        // Makes sure that we have some genre codes to pass through
        guard let genreCodes = genreCodes else {
            print("there are no genre codes")
            completion(false, [], nil)
            return
        }
        
       // An empty string to hold the genre codes that we are going to pass through
        var genreParams = ""
        
        // Loops through the codes and forms the URL based off of the codes passed through
        for code in genreCodes {
            let newCodeParam = "&with_genres=\(code)"
            genreParams += newCodeParam
        }
        
        // Forms a url to make a request to get a list of movies that meet the criteria
        let url = Endpoints.base + "/discover/movie" + Endpoints.apiKeyParam + genreParams
        
        var titleStringArray = [String]()
        
        // Make the request with the url
        AF.request(url, method: .get).validate().responseJSON {
            (response) in

            // An empty array of titles that we will add the search results to


            // A switch statement where we determine what to do with the results
            switch response.result {

            // What to do if we get some valid json data
            case .success(let value):
                let json = JSON(value)

                // Getting an array of titles
                let jsonArrayMap = json["results"].arrayValue.map {
                    $0["title"].stringValue
                }

                // Creating a string array of titles
                for item in jsonArrayMap {
                    titleStringArray.append(item)
                }
                completion(true, titleStringArray, nil)

                // Generating a random number using the titleStringArray as the upper limit

                case .failure(let error):
                print("Here was the error in \(#function): print \(error.localizedDescription)")
            }

        }
        
        print("titleStringArray all the way down here is` is \(titleStringArray)")
    }
    
//    class func getGenres() {
//        print(Endpoints.getGenres.url)
//        AF.request(Endpoints.getGenres.url).responseJSON { (response) in
////            print("Request: \(String(describing: response.request!))")
////            print("Result: \(response.result)")
//        }
//    }
    
    
}
