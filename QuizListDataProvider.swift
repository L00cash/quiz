//
//  QuizListDataProvider.swift
//  quiz
//
//  Created by Łukasz Bożek on 04/06/16.
//  Copyright © 2016 company. All rights reserved.
//

import UIKit
import CoreData

class QuizListDataProvider: NSObject, QuizListDataProviderProtocol {
    
    weak var tableView: UITableView? {
        didSet {
            tableView!.dataSource = self
        }
    }
    
    var downloadManager: DownloadManagerProtocol?
    let chunkSize: Int16 = 10
    var quizes: [Quiz]?
    weak var fetchFailedDelegate: QuizListDataProviderFailureDelegateProtocol?
    let cellIdentifier = "cell"
    var fetchingInProgress = false
    var cellsToReload: [NSIndexPath] = []
    
    lazy var managedObjectContext : NSManagedObjectContext = {
        let appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        return appDelegate.managedObjectContext
    }()
    
    lazy var entity: NSEntityDescription = {
        NSEntityDescription.entityForName("Quiz", inManagedObjectContext: self.managedObjectContext)
    }()!
    

    func fetchCoreData() {
        
        let fetchRequest = NSFetchRequest()
        fetchRequest.entity = entity
        
        do {
            try quizes = managedObjectContext.executeFetchRequest(fetchRequest) as? [Quiz]
        } catch {
            print(error)
            fetchFailedDelegate?.coreDataFetchFailure()
        }
    }
    
    func updateCells() {
        dispatch_async(dispatch_get_main_queue()) { 
            self.tableView?.reloadRowsAtIndexPaths(self.cellsToReload, withRowAnimation: UITableViewRowAnimation.None)
            self.cellsToReload = []
        }
    }

    
    func fetchWebData(amount: Int16, offset: Int16, shouldRegenerateTable: Bool) {
        
        fetchingInProgress = true
        downloadManager?.getQuizList(amount, offset: offset, onCompletion: { (quizArray, error) in
            
            guard error == nil else {
                self.fetchFailedDelegate?.webDataFetchFailure()
                return
            }
            
            for quiz in quizArray! {
                let quizObject = Quiz(quizInfo: quiz, entity: self.entity, insertIntoManagedObjectContext: self.managedObjectContext)
                self.quizes?.append(quizObject)
                print(quizObject)
            }
            
            self.fetchingInProgress = false
            
            self.updateCells()
            
            if shouldRegenerateTable {
                 dispatch_async(dispatch_get_main_queue()) {
                     self.tableView?.reloadData()
                }
            }
            
            do {
                try self.managedObjectContext.save()
            } catch {
                print(error)
                self.quizes = Array(self.quizes!.prefix(self.quizes!.count - quizArray!.count))
            }
        })
    }
}

//MARK: UITableViewDataSource
extension QuizListDataProvider: UITableViewDataSource {
    
    func loadingCell(cell: QuizCell) {
        cell.activityView.hidden = false
    }
    
    func configureCellForIndexPath(cell: QuizCell, indexPath: NSIndexPath) {
        let currentQuiz = quizes![indexPath.row]
        
        cell.activityView.hidden = true
        
        cell.title.text = currentQuiz.title
        cell.correctAnswers.text = "\(currentQuiz.questionsCorrect)" + " / " + "\(currentQuiz.questionsCount)"
        
        guard currentQuiz.questionsCount > 0 else {
            cell.startedQuizView.hidden = true
            cell.finishedQuizView.hidden = true
            return
        }
        
//        if 
        
        let percentageScore = currentQuiz.questionsCorrect / currentQuiz.questionsCount
        cell.percentageScore.text = "\(percentageScore)%"
        
        let attemptedQuestionsPercent = currentQuiz.questionsDone / Int16((currentQuiz.questions?.count)!)
        cell.attemptedQuestions.text = "\(attemptedQuestionsPercent)%"
//        cell.quizImage
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView?.dequeueReusableCellWithIdentifier(cellIdentifier) as! QuizCell
        
        if indexPath.row >= quizes!.count {
            cellsToReload.append(indexPath)
            loadingCell(cell)
            if fetchingInProgress == false {
                fetchWebData(chunkSize, offset: Int16((quizes?.count)!), shouldRegenerateTable: false)
            }
        } else {
            configureCellForIndexPath(cell, indexPath: indexPath)
        }
        
        
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if downloadManager!.userDefaults!.objectForKey("amountOfQuizes") == nil {
            fetchWebData(chunkSize, offset: 0, shouldRegenerateTable: true)
        }
        
        return downloadManager!.userDefaults!.integerForKey("amountOfQuizes")
    }
}