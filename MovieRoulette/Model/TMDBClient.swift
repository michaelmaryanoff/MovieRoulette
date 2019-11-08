//
//  TMDBClient.swift
//  MovieRoulette
//
//  Created by Michael Maryanoff on 8/20/19.
//  Copyright © 2019 Michael Maryanoff. All rights reserved.
//

import SwiftyJSON
import Alamofire

class TMDBClient {
    
    // MARK: - Constants
    
    // Replace APIKey.key with your own string
    static let apiKey = APIKey.apiKey
    
    // Static endpoints to be used for each requests
    enum EndpointConstants {
        static let host = "api.themoviedb.org"
        static let discoverPath = "/3/discover/movie"
        static let searchForActorPath = "/3/search/person"
    }
    
    enum SearchType {
        case spin
        case searchForActor
    }
    
    static func formulateBaseComponents(searchType: SearchType) -> URLComponents {
        var components = URLComponents()
        components.scheme = "https"
        components.host = TMDBClient.EndpointConstants.host
        
        switch searchType {
        case .spin:
            components.path = TMDBClient.EndpointConstants.discoverPath
        case .searchForActor:
            components.path = TMDBClient.EndpointConstants.searchForActorPath
        }
        return components
    }
    
    // MARK: - Search functions
    
    // Creates a URL used when "spinning" for a random movie
    static func formulateMovieSearchURL(withTheseGenres genreCodes: [Int]?, yearFrom: Int?, yearTo: Int?, withActorCode actorCode: Int?) -> URL {
        
        // Base url
        var components = formulateBaseComponents(searchType: .spin)

        // Adds the required API key
        var queryComponents = [URLQueryItem]()
        let apiKeyForURL = URLQueryItem(name: "api_key", value: TMDBClient.apiKey)
        queryComponents.append(apiKeyForURL)
        
        // Loops through genre codes array and appends codes to URL query
        if let genreCodes = genreCodes {
            for code in genreCodes {
                let genreQueryItem = URLQueryItem(name: "with_genres", value: "\(code)")
                queryComponents.append(genreQueryItem)
            }
        }
        
        if let yearFrom = yearFrom {
            let yearFromQueryItem = URLQueryItem(name: "primary_release_date.gte", value: "\(yearFrom)-01-01")
            queryComponents.append(yearFromQueryItem)
        }
        
        if let yearTo = yearTo {
            let yearToQueryItem = URLQueryItem(name: "primary_release_date.lte", value: "\(yearTo)-12-31")
            queryComponents.append(yearToQueryItem)
        }
        
        if let actorCode = actorCode {
            let actorCodeQueryItem = URLQueryItem(name: "with_cast", value: String(actorCode))
            queryComponents.append(actorCodeQueryItem)
        }
       
        components.queryItems = queryComponents
        
        guard let url = components.url else {
            print("could not form url!")
            return URL(string: "")!
        }
        return url
    }
    
    // Uses formatted URL when searching for a random movie
    static func searchForMovies(url: URL?, completion: @escaping(Bool, [String], Error?) -> Void) {
        
        guard let url = url else {
            print("Could not load url!")
            return
        }
        
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
    
    // A network call that searches for an actor ID in order to create a url query
    static func searchForActorID(query: String?, completion: @escaping (Bool, [String], [Int], Error?) -> Void) {
        
        // Makese sure that we actually have a search to pass through
        guard let query = query else {
            print("there was no query in \(#function)!")
            return
        }
        
        if query.isEmpty {
            print("There is no query")
            return
        }
        
        // Formats URL using URL components
        var urlComponents = TMDBClient.formulateBaseComponents(searchType: .searchForActor)
        let queryItemForSearch = URLQueryItem(name: "query", value: "\(query)")
        let apiKeyForURL = URLQueryItem(name: "api_key", value: TMDBClient.apiKey)
        urlComponents.queryItems = [apiKeyForURL, queryItemForSearch]
        
        // Ensures there is a valid string to format the query
        guard let url = urlComponents.url?.absoluteString else {
            print("Could not form URL")
            return
        }
        
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
                print("error.asAFError?.errorDescription" + " " + "\(String(describing: error.asAFError?.errorDescription))")
                completion(false, [], [], error)
            }
        }
    }
    
}

