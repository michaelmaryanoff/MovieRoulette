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
    
    // Holds the raw API key data
    static let apiKey = "***REMOVED***"
    
    // Static endpoints to be used for each requests
    enum Endpoints {
        static let base = "https://api.themoviedb.org/3"
        static let apiKeyParam = "?api_key=\(TMDBClient.apiKey)"
    }
    
    // TODO: Create a switch on this to be used with URLComponents() later on
    enum QueryComponentType: String {
        case yearFrom = "primary_release_date.gte"
        case yearTo = "primary_release_date.lte"
        case withGenres = "with_genres"
        case withCast = "with_cast"
    }
    
    
    static func searchForMovies(withTheseGenres genreCodes: [Int]?, from yearFrom: Int?, to yearTo: Int?, withActorCode actorCode: Int?, completion: @escaping(Bool, [String], Error?) -> Void) {
        
        
        // Creates a default empty string to pass through as a query parameter if there is nothing to query
        var yearFromQueryParam = ""
        var yearToQueryParam = ""
        var genreParams = ""
        var actorQueryParam = ""
        
        // Checks to see if we have some genre codes to pass through
        if let genreCodes = genreCodes {
            for code in genreCodes {
                let newCodeParam = "&with_genres=\(code)"
                genreParams += newCodeParam
            }
        }
        
        if let yearFrom = yearFrom {
            yearFromQueryParam = "&primary_release_date.gte=\(yearFrom)-01-01"
        }
        
        if let yearTo = yearTo {
            yearToQueryParam = "&primary_release_date.lte=\(yearTo)-12-31"
        }
        
        if let actorCode = actorCode {
            actorQueryParam = "&with_cast=\(actorCode)"
        }
        
        // Forms a url to make a request to get a list of movies that meet the criteria
        let url = Endpoints.base + "/discover/movie" + Endpoints.apiKeyParam + genreParams + yearFromQueryParam + yearToQueryParam + actorQueryParam
        
                // Make the request with the formed URL
                AF.request(url, method: .get).responseJSON {
                    
                    (response) in
        
                    // A switch statement where we determine what to do with the results
                    switch response.result {
        
                    // What to do if we get some valid json data
                    case .success(let value):
                        
                        // Creates a temporary string array to be passed through the completion handler
                        var titleStringArray = [String]()
                        
                        titleStringArray = []
        
                        let json = JSON(value)
        
                        // Getting an array of titles
                        let jsonArrayMap = json["results"].arrayValue.map {
                            $0["title"].stringValue
                        }
        
                        // Appends movies to string array
                        for item in jsonArrayMap {
                            titleStringArray.append(item)
                        }
                        
                        
                        completion(true, titleStringArray, nil)
        
                    case .failure(let error):
                        
                        print("Here was the error in \(#function): \(error.localizedDescription)")
                        completion(false, [], error)
                    }
        
                }

    
    }
    
    // A network call that searches for an actor Id in order to create a url query
    static func searchForActorID(query: String?, completion: @escaping (Bool, [String], [Int], Error?) -> Void) {
        
        // Makese sure that we actually have an actor to pass through
        guard let query = query else {
            print("there was no query in \(#function)!")
            return
        }
        
        if query.isEmpty {
            print("no query")
            return
        }
        
        // Formats the query string to pass through
        // Creates an empty string if there is no query
        let queryString = "&query=\(query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")"
        
        // Formats the url
        let url = Endpoints.base + "/search/person" + Endpoints.apiKeyParam + queryString
        print("url is actor" + " " + "\(url)")
        
        // Creates a temporary string of actors and their corresponding Ids
        var actorStringArray = [String]()
        var idStringArray = [Int]()
        
        
        AF.request(url).validate().responseJSON {
            (response) in
            
            // Handles the response
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
                
                if let responseStatusCode = response.response?.statusCode {
                    if responseStatusCode == 422 {
                        print("could not find any actors with that name")
                    }
                    
                }
                print("error.asAFError?.errorDescription" + " " + "\(error.asAFError?.errorDescription)")
                completion(false, [], [], error)
            }
        }
    }
    
}

