//
//  QuestionInfo.swift
//  quiz
//
//  Created by Łukasz Bożek on 04/06/16.
//  Copyright © 2016 company. All rights reserved.
//

import Foundation

struct QuestionInfo {
    var imageUrl: String?
    var title: String?
    var order: Int16
    var answers: [AnswerInfo]? = []
    
    init(dictionary: NSDictionary) {
        if let image = dictionary.valueForKey("image") as? NSDictionary, let url = image.valueForKey("url") as? String {
            imageUrl = url
        }
        
        title = dictionary.valueForKey("text") as? String
        order = (dictionary.valueForKey("order") as! NSNumber).shortValue
        let answersDict = dictionary.valueForKey("answers") as? NSArray
        
        for dict in answersDict! {
            answers!.append(AnswerInfo(dictionary: dict as! NSDictionary))
        }
    }
}