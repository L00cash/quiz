//
//  EndOfQuizView.swift
//  quiz
//
//  Created by Łukasz Bożek on 05/06/16.
//  Copyright © 2016 company. All rights reserved.
//

import UIKit

class EndOfQuizView: UIViewController {
    
    @IBOutlet weak var quizScore: UILabel!
    
    var correctAnswers: Int!
    var questionsCount: Int!
    
    override func viewDidLoad() {
        let score = Double(correctAnswers) / Double(questionsCount) * 100
        quizScore.text = "\(Int(score))%"
    }
    
}
