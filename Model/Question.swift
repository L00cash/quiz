//
//  Question.swift
//  quiz
//
//  Created by Łukasz Bożek on 04/06/16.
//  Copyright © 2016 company. All rights reserved.
//

import Foundation
import CoreData


class Question: NSManagedObject {

// Insert code here to add functionality to your managed object subclass
    
    
    init(quiz: Quiz, quiestionInfo: QuestionInfo, entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)
        
        title = quiestionInfo.title
        imageUrl = quiestionInfo.imageUrl
        order = quiestionInfo.order
        self.quiz = quiz
        let answerEntity = NSEntityDescription.entity(forEntityName: "Answer", in: context!)
        
        var arr: [Answer] = []
        for answer in quiestionInfo.answers! {
            arr.append(Answer(question: self, answerInfo: answer, entity: answerEntity!, insertIntoManagedObjectContext: context))
        }
        
        answers = NSSet(array: arr)
        
    }
    
    override init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)
    }
}
