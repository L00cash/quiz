//
//  QuizCell.swift
//  quiz
//
//  Created by Łukasz Bożek on 04/06/16.
//  Copyright © 2016 company. All rights reserved.
//

import UIKit

class QuizCell: UITableViewCell {
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var correctAnswers: UILabel!
    @IBOutlet weak var percentageScore: UILabel!
    @IBOutlet weak var quizImage: UIImageView!
    
    @IBOutlet weak var finishedQuizView: UIView!
    @IBOutlet weak var startedQuizView: UIView!
    
    @IBOutlet weak var attemptedQuestions: UILabel!
    
    @IBOutlet weak var activityView: UIView!
    
}