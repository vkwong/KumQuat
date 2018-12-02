//
//  Util.swift
//  KumQuat
//
//  Created by labuser on 12/1/18.
//  Copyright © 2018 Vivian Wong. All rights reserved.
//

import Foundation


let ONE_MINUTE = 60
let ONE_HOUR = 3600
let ONE_DAY = 86400
let ONE_MONTH = 2592000
let ONE_YEAR = 31536000

func convertUnixToHuman(seconds: Int) -> String {
    if seconds < ONE_MINUTE {
        return "\(seconds) seconds"
    } else if seconds < ONE_HOUR {
        let num_mins = Int(seconds/ONE_MINUTE)
        return "\(num_mins) minutes"
    } else if seconds < ONE_DAY {
        let num_hours = Int(seconds/ONE_HOUR)
        return "\(num_hours) hours"
    } else if seconds < ONE_MONTH {
        let num_days = Int(seconds/ONE_DAY)
        return "\(num_days) days"
    } else if seconds < ONE_YEAR {
        let num_months = Int(seconds/ONE_MONTH)
        return "\(num_months) months"
    } else {
        let num_years = Int(seconds/ONE_YEAR)
        return "\(num_years) years"
    }
}
