//
//  Answer.swift
//  quiz
//
//  Created by Łukasz Bożek on 04/06/16.
//  Copyright © 2016 company. All rights reserved.
//

import Foundation
import CoreData


class Answer: NSManagedObject {

// Insert code here to add functionality to your managed object subclass
    init(question: Question, answerInfo: AnswerInfo, entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)
        
        isCorrect = answerInfo.isCorrect
        order = answerInfo.order
        title = answerInfo.text
        self.question = question
        
    }
    
    override init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)
    }
    
}
