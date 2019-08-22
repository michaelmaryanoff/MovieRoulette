//
//  MovieSelectionParameters.swift
//  MovieRoulette
//
//  Created by Michael Maryanoff on 8/22/19.
//  Copyright © 2019 Michael Maryanoff. All rights reserved.
//

import Foundation

struct MovieSelectionParameters {
    let genresSet = Set<Int>()
    let actor: Int?
    let yearMinimum: Int?
    let yearMaximum: Int?
}
