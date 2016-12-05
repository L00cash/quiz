//
//  QuizInfo.swift
//  quiz
//
//  Created by Łukasz Bożek on 04/06/16.
//  Copyright © 2016 company. All rights reserved.
//

import Foundation

struct QuizInfo {
    var photoUrl: String? = nil
    let title: String
    let id: String
    let questionCount: Int16
    
    init(dictionary: NSDictionary) {
        title = dictionary.value(forKey: "title") as! String
        id = "\(dictionary.value(forKey: "id")!)"
        if let mainPhoto = dictionary.value(forKey: "mainPhoto") as? NSDictionary, let url = mainPhoto.value(forKey: "url") as? String {
            photoUrl = url
        }
        questionCount = (dictionary.value(forKey: "questions") as! NSNumber).int16Value
    }
}
