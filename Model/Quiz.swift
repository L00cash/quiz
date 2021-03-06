//
//  Quiz.swift
//  quiz
//
//  Created by Łukasz Bożek on 04/06/16.
//  Copyright © 2016 company. All rights reserved.
//

import Foundation
import CoreData


class Quiz: NSManagedObject {

// Insert code here to add functionality to your managed object subclass
    
    init(quizInfo: QuizInfo, entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)
        
        title = quizInfo.title
        photoUrl = quizInfo.photoUrl
        id = quizInfo.id
        questionsCount = quizInfo.questionCount
    }
    
    override init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)
    }
}
