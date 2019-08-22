//
//  MovieSelectionParameters.swift
//  MovieRoulette
//
//  Created by Michael Maryanoff on 8/22/19.
//  Copyright © 2019 Michael Maryanoff. All rights reserved.
//

import Foundation

struct MovieSelectionParameters {
    
    var genresSet = Set<Int>()
    var actor: Int?
    var yearMinimum: Int?
    var yearMaximum: Int?
    
//    static func shared() -> MovieSelectionParameters {
//        struct Singleton {
//            private init() {}
//            static var shared = MovieSelectionParameters(actor: nil, yearMinimum: nil, yearMaximum: nil)
//        }
//        return Singleton.shared
//    }
}


