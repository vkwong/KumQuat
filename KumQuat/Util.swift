//
//  Util.swift
//  KumQuat
//
//  Created by labuser on 12/1/18.
//  Copyright © 2018 Vivian Wong. All rights reserved.
//

import Foundation

enum CollegeChoices {
    case wustl
    case slu
    case webster    
}

class Util {
    let ONE_MINUTE = 60
    let ONE_HOUR = 3600
    let ONE_DAY = 86400
    let ONE_MONTH = 2592000
    let ONE_YEAR = 31536000
    
    func convertUnixToHumanReadable(seconds: Int) -> String {
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

    static func getDorms(college: CollegeChoices) -> [String]{
        
        var dorms: [String] = [String]()
        
        switch(college){
        case .wustl:
            dorms.append("Beaumont")
            dorms.append("Brookings")
            dorms.append("Crow")
            dorms.append("Dauten")
            dorms.append("Eliot")
            dorms.append("Greenway")
            dorms.append("Hitzeman")
            dorms.append("Hurd")
            dorms.append("Lee")
            dorms.append("Liggett")
            dorms.append("Lopata House")
            dorms.append("The Lofts")
            dorms.append("Koenig")
            dorms.append("Millbrook")
            dorms.append("Mudd")
            dorms.append("Myers")
            dorms.append("Park")
            dorms.append("Rutledge")
            dorms.append("Shanedling")
            dorms.append("Umrath")
            dorms.append("University Drive")
            dorms.append("Village East")
            dorms.append("Village House")
            break
        case .slu:
            dorms.append("DeMattias Hall")
            dorms.append("Fusz Hall")
            dorms.append("Grand Forest Apartments")
            dorms.append("Grand Hall")
            dorms.append("Griesedieck Complex")
            dorms.append("Marchetti Towers")
            dorms.append("Marguerite Hall")
            dorms.append("Reinart Hall")
            dorms.append("Robert May Hall")
            dorms.append("Spring Hall")
            dorms.append("Village Apartmentss")
            break
        case .webster:
            dorms.append("Big Bend Apartments")
            dorms.append("East Hall")
            dorms.append("Glen Park Apartments")
            dorms.append("Hall Apartments")
            dorms.append("Maria Hall")
            dorms.append("Webster Village Apartments")
            dorms.append("West Hall")
            break
        }
        
        return dorms
    }
    
    static func getColleges() -> [String] {
        var colleges = [String]()
        colleges.append("Saint Louis University")
        colleges.append("Washington University in St. Louis")
        colleges.append("Webster University")
        return colleges
    }

}
