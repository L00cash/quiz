//
//  QuizViewDataProvider.swift
//  quiz
//
//  Created by Łukasz Bożek on 04/06/16.
//  Copyright © 2016 company. All rights reserved.
//

import UIKit
import CoreData

class QuizViewDataProvider: NSObject, QuizViewDataProviderProtocol {
    weak var delegate: QuizViewDataProviderDelegateProtocol?
    weak var quiz: Quiz?
    var questionNbr: Int?
    var downloadManager: DownloadManagerProtocol?
    var currentQuestion: Question?
    
    lazy var managedObjectContext : NSManagedObjectContext = {
        let appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        return appDelegate.managedObjectContext
    }()
    
    lazy var entity: NSEntityDescription = {
        NSEntityDescription.entityForName("Question", inManagedObjectContext: self.managedObjectContext)
    }()!
    
    required init(quiz: Quiz, questionNbr: Int, downloadManager: DownloadManagerProtocol, delegate: QuizViewDataProviderDelegateProtocol) {
        super.init()
        self.quiz = quiz
        self.questionNbr = questionNbr
        self.downloadManager = downloadManager
        self.delegate = delegate
        if quiz.questions?.count == 0 {
            fetchQuestions()
        } else {
            filterCurrentQuestion()
            
            if currentQuestion == nil  {
                delegate.showEndScreen()
                return
            }
            
            delegate.setupProgress(Int16(questionNbr), all: Int16(quiz.questions!.count))
            delegate.setupTitle(currentQuestion!.title!)
        }
    }
    
    var tableView: UITableView? {
        didSet {
            tableView?.dataSource = self
        }
    }
    
    func fetchQuestions() {
        downloadManager?.getQuizDetails(quiz!.id!, onCompletion: { (questionsInfo, error) in
            
            for info in questionsInfo! {
                _ = Question(quiz: self.quiz!, quiestionInfo: info, entity: self.entity, insertIntoManagedObjectContext: self.managedObjectContext)
            }
            
            do {
                try self.quiz!.managedObjectContext!.save()
                self.filterCurrentQuestion()
                self.delegate?.setupProgress(Int16(self.questionNbr!), all: Int16(self.quiz!.questions!.count))
                self.delegate?.setupTitle(self.currentQuestion!.title!)
                dispatch_async(dispatch_get_main_queue()) {
                    self.tableView?.reloadData()
                }
            } catch {
                print(error)
            }
            
        })
        
        
    }
    
    func filterCurrentQuestion() {
        let question = quiz?.questions?.filter({ (element) -> Bool in
            if let q = element as? Question {
                return Int(q.order) == questionNbr! + 1
            }
            return false
        })
        
        self.currentQuestion = question!.first as? Question
    }
    
    func answer(answerNumber: Int) -> Answer {
        let answer = self.currentQuestion?.answers?.filter({ (element) -> Bool in
            if let a = element as? Answer {
                return Int(a.order) == answerNumber + 1
            }
            return false
        })
        
        return answer!.first as! Answer
    }
    
    
    func checkCorrectAnswer(selectedAnswer: Int) {
        let ans = answer(selectedAnswer)
        
        if ans.isCorrect {
            quiz?.questionsCorrect += 1
        }
        quiz?.questionsDone += 1
        do {
            try quiz?.managedObjectContext?.save()
        } catch {
            //TODO: handle
            print("error occured while saving question answer")
        }
        
    }
    
}


//MARK: UITableViewDataSource
extension QuizViewDataProvider: UITableViewDataSource {
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
     
        let cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "answerCell")
        cell.textLabel?.adjustsFontSizeToFitWidth = true
        let ans = answer(indexPath.row)
        cell.textLabel?.text = ans.title!
        
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if  let answers = currentQuestion?.answers {
            return answers.count
        } else {
            return 0
        }
    }
    
    
}