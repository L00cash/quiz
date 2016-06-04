//
//  Question+CoreDataProperties.swift
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

extension Question {

    @NSManaged var title: String?
    @NSManaged var imageUrl: String?
    @NSManaged var quiz: Quiz?
    @NSManaged var answers: NSSet?

}
