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
        if let image = dictionary.value(forKey: "image") as? NSDictionary, let url = image.value(forKey: "url") as? String {
            imageUrl = url
        }
        
        title = dictionary.value(forKey: "text") as? String
        order = (dictionary.value(forKey: "order") as! NSNumber).int16Value
        let answersDict = dictionary.value(forKey: "answers") as? NSArray
        
        for dict in answersDict! {
            answers!.append(AnswerInfo(dictionary: dict as! NSDictionary))
        }
    }
}
