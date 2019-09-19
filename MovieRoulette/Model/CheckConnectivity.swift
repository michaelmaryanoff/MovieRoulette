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

// This class allows for a quick connectivity check before making a request
class CheckConnectivity {
    class var isConnectedToInternet:Bool {
        return NetworkReachabilityManager()?.isReachable ?? false
    }
}
