//
//  Quiz+CoreDataProperties.swift
//  quiz
//
//  Created by Łukasz Bożek on 04/06/16.
//  Copyright © 2016 company. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Quiz {

    @NSManaged var photoUrl: String?
    @NSManaged var questionsCorrect: Int16
    @NSManaged var questionsCount: Int16
    @NSManaged var questionsDone: Int16
    @NSManaged var title: String?
    @NSManaged var id: Int32
    @NSManaged var questions: NSSet?

}
