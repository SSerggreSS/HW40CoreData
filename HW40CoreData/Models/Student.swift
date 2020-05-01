//
//  Student.swift
//  HW40CoreData
//
//  Created by Сергей on 19.04.2020.
//  Copyright © 2020 Sergei. All rights reserved.
//

import Foundation

enum Gender: String {

    case male
    case female
    
}

class Student: NSObject {
    
    @objc dynamic var name: String
    @objc dynamic var surname: String
    @objc dynamic var dateOfBirth: Date
    @objc dynamic var gender: String
    @objc dynamic var trainingClass: String
    @objc dynamic var assessment = Int.random(in: 2...10)
    
    @objc weak var friend: Student? = nil
    
    init(name: String, surname: String, dateOfBirth: Date, gender: String, trainingClass: String) {
        
        self.name = name
        self.surname = surname
        self.dateOfBirth = dateOfBirth
        self.gender = gender
        self.trainingClass = trainingClass
        
    }
    
    override init() {
    
        self.name = ""
        self.surname = ""
        self.dateOfBirth = Date()
        self.gender = ""
        self.trainingClass = ""
        
        super.init()
        
    }
    
    static let keysProperties = (name: "name", surname: "surname",
                                 dateOfBirth: "dateOfBirth", gender: "gender",
                                 trainingClass: "trainingClass", assessment: "assessment", none: "")
    
    static let names = ["Mason", "Ethan", "Logan", "Lucas", "Jackson",
                        "Aiden", "Oliver", "Jacob", "Madison", "Liam",
                        "Emma", "Olivia", "Ava", "Sophia", "Isabella",
                        "Mia", "Charlotte", "Amelia", "Emily", "Sofia",
                        "Daniel", "Ellie", "Carter", "Aubrey", "Gabriel",
                        "Scarlett", "Henry", "Zoey", "Matthew","Hannah"]
    
    static let lastNames = ["Johnson", "Williams", "Jones", "Brown", "Davis",
                            "Miller", "Wilson", "Moore", "Taylor", "Anderson",
                            "Thomas", "Jackson", "White", "Harris", "Martin",
                            "Thompson", "Wood", "Lewis", "Scott", "Hill",
                            "Cooper", "King", "Green", "Walker", "Edwards",
                            "Turner", "Morgan", "Baker", "Hill", "Phillips"]
    
    static func createRandomStudent() -> Student {
        
        let name = Student.names.randomElement() ?? ""
        let surname = Student.names.randomElement() ?? ""
        let date = Date.randomDate(from: 1900, before: 2000)
        let gender = Bool.random() ? "Male" : "Female"
        let grade = "11"
        
        let student = Student(name: name, surname: surname, dateOfBirth: date,
                              gender: gender, trainingClass: grade)
        
        return student
    }
    
}
