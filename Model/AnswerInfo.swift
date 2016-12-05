//
//  AnswerInfo.swift
//  quiz
//
//  Created by Łukasz Bożek on 04/06/16.
//  Copyright © 2016 company. All rights reserved.
//

import Foundation

struct AnswerInfo {
    var order: Int16
    var text: String!
    var isCorrect: Bool = false
    
    init(dictionary: NSDictionary) {
        order = (dictionary.value(forKey: "order") as! NSNumber).int16Value
        text = "\(dictionary.value(forKey: "text")!)"
        
        if let correct = dictionary.object(forKey: "isCorrect") as? NSNumber {
            isCorrect = correct.boolValue
        }
    }
}
