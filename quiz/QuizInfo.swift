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
        title = dictionary.valueForKey("title") as! String
        id = "\(dictionary.valueForKey("id")!)"
        if let mainPhoto = dictionary.valueForKey("mainPhoto") as? NSDictionary, let url = mainPhoto.valueForKey("url") as? String {
            photoUrl = url
        }
        questionCount = (dictionary.valueForKey("questions") as! NSNumber).shortValue
    }
}
