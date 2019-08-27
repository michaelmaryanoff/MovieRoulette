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
    
    static func searchForMovies(withTheseGenres genreCodes: Set<Int>?, from yearFrom: Int?, to yearTo: Int?, withActorCode actorCode: Int?, completion: @escaping(Bool, [String], Error?) -> Void) {
        
        // Makes sure that we have some genre codes to pass through
        guard let genreCodes = genreCodes else {
            print("there are no genre codes")
            completion(false, [], nil)
            return
        }
        
        guard let yearFrom = yearFrom else {
            print("there is no yearfrom")
            return
        }
        
        guard let yearTo = yearTo else {
            print("There is no yearTo")
            return
        }
        
        guard let actorCode = actorCode else {
            print("there is no actorcode")
            return
        }
        
        var yearFromQueryParam = ""
        var yearToQueryParam = ""
        var genreParams = ""
        var actorQueryParam = ""
        

        for code in genreCodes {
            let newCodeParam = "&with_genres=\(code)"
            genreParams += newCodeParam
        }
        
        yearFromQueryParam = "&primary_release_date.gte=\(yearFrom)-01-01"
        yearToQueryParam = "&primary_release_date.lte=\(yearTo)-12-31"
        actorQueryParam = "&with_cast=\(actorCode)"
        
        // Forms a url to make a request to get a list of movies that meet the criteria
        let url = Endpoints.base + "/discover/movie" + Endpoints.apiKeyParam + genreParams + yearFromQueryParam + yearToQueryParam + actorQueryParam
        
        var titleStringArray = [String]()
        
        // Make the request with the url
        AF.request(url, method: .get).validate().responseJSON {
            (response) in
            print(url)

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
    
    static func searchForActorID(query: String?, completion: @escaping (Bool, [String], [Int], Error?) -> Void) {
        
        guard let query = query else {
            print("there was not query in \(#function)!")
            return
        }
        var queryString = "&query=\(query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")"
        
        let url = Endpoints.base + "/search/person" + Endpoints.apiKeyParam + queryString
        
        var actorStringArray = [String]()
        
        var idStringArray = [Int]()
        
        var actorArray = [Actor]()
        
        AF.request(url).validate().responseJSON {
            (response) in
            print("url for \(#function): \(url)")
            
            switch response.result {
                
            case .success(let value):
                let json = JSON(value)
                
                let jsonArrayNameMap = json["results"].arrayValue.map {
                    $0["name"].stringValue
                }
                
                let jsonArrayIDMap = json["results"].arrayValue.map {
                    $0["id"].stringValue
                }
                
                for item in jsonArrayNameMap {
                    actorStringArray.append(item)
                }
                
                for item in jsonArrayIDMap {
                    let newItem = Int(item) ?? 0
                    idStringArray.append(newItem)
                }
                
                completion(true, actorStringArray, idStringArray, nil)
                
            
            case .failure(let error):
                print("Here was the error in \(#function): print \(error.localizedDescription)")
            }
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
