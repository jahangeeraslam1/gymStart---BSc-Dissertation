//
//  logsStruct.swift
//  gymStart
//
//  Created by Jahangeer Aslam on 08/03/2021.
//

import Foundation



struct logsStruct{
    var logID : Int?
    var exName : String?
    var exGroup : String?
    var exData : [String : [Int]]?
    var firebaseTimeStamp : String?
    var exDateAndTime : String?
}


struct cellStruct {
    let body : String
    let image : String

}


struct exercisesStruct {
    let exerciseName : String
    let exerciseImages : [String]
    let exerciseInstructions : String
    }


