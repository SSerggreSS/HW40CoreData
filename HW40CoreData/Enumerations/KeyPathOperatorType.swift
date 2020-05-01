//
//  KeyPathOperator.swift
//  HW40CoreData
//
//  Created by Сергей on 27.04.2020.
//  Copyright © 2020 Sergei. All rights reserved.
//

import Foundation

enum KeyPathOperatorType: String {
    
    //Aggregation operators
    case none  = ""
    case avg   = "@avg"
    case count = "@count"
    case max   = "@max"
    case min   = "@min"
    case sum   = "@sum"
    
    //Array Operators
    case distinctUnionOfObjects = "@distinctUnionOfObjects"
    case unionOfObjects         = "@unionOfObjects"
    
    //Nesting Operators
    case distinctUnionOfArrays  = "@distinctUnionOfArrays"
    case unionOfArrays          = "@unionOfArrays"
    case distinctUnionOfSets    = "@distinctUnionOfSets"
   
    func createFullPath(leftKeyPath: String, rightKeyPath: String?) -> String {
        
        let keyOperatorRaw = self.rawValue
        
        let rightKeyPath = rightKeyPath != nil ? "." + rightKeyPath! : ""
        let fullPath = leftKeyPath + "." + keyOperatorRaw + rightKeyPath
        
        return fullPath
    }
    
}
