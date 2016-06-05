//
//  QuizViewController.swift
//  quiz
//
//  Created by Łukasz Bożek on 04/06/16.
//  Copyright © 2016 company. All rights reserved.
//

import UIKit

class QuizViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var questionTitle: UILabel!
    @IBOutlet weak var progress: UIProgressView!
    
    var dataProvider: QuizViewDataProviderProtocol?
    var quiz: Quiz?
    var questionNumber = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataProvider = QuizViewDataProvider(quiz: quiz!, questionNbr: questionNumber, downloadManager: DownloadManager(), delegate: self)
        dataProvider?.tableView = tableView
        dataProvider?.delegate = self
        tableView.delegate = self
    }
}


extension QuizViewController: QuizViewDataProviderDelegateProtocol {
    
    func setupProgress(done: Int16, all: Int16) {
        self.progress.setProgress(Float(done)/Float(all), animated: true)
    }
    
    func setupTitle(title: String) {
        dispatch_async(dispatch_get_main_queue()) {
            self.questionTitle.text = title
        }
    }
    
    func showEndScreen() {
        
        dispatch_async(dispatch_get_main_queue()) {
            let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("endView") as! EndOfQuizView
            controller.questionsCount = self.quiz?.questions?.count
            controller.correctAnswers = Int(self.quiz!.questionsCorrect)
            
            self.quiz?.questionsCorrect = 0
            
            let transition = CATransition.transitionFromRight()
            self.view.window?.layer.addAnimation(transition, forKey: kCATransition)
            self.presentViewController(controller, animated: false, completion: nil)
        }
    }
    
    func nextQuestion() {
        
    }
}

extension QuizViewController: UITableViewDelegate {
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        dataProvider?.answer(indexPath.row)
        
        dataProvider!.checkCorrectAnswer(indexPath.row)
        
        let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("quizView") as! QuizViewController
        controller.questionNumber = questionNumber + 1
        controller.quiz = quiz
        
        let transition = CATransition.transitionFromRight()
        self.view.window?.layer.addAnimation(transition, forKey: kCATransition)
        self.presentViewController(controller, animated: false, completion: nil)
    }
}