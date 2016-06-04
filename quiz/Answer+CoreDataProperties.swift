//
//  Answer+CoreDataProperties.swift
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

extension Answer {

    @NSManaged var isCorrect: Bool
    @NSManaged var order: Int16
    @NSManaged var title: String?
    @NSManaged var question: Question?

}
