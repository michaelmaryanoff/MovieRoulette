//
//  CheckConnectivity.swift
//  MovieRoulette
//
//  Created by Michael Maryanoff on 9/1/19.
//  Copyright © 2019 Michael Maryanoff. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

//Adapted from stackoverflow post

class CheckConnectivity {
    class var isConnectedToInternet:Bool {
        return NetworkReachabilityManager()?.isReachable ?? false
    }
}
