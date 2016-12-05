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
    var cellsToReload: [IndexPath] = []
    
    //TODO: dependency injection
    lazy var managedObjectContext : NSManagedObjectContext = {
        let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.managedObjectContext
    }()
    
    lazy var entity: NSEntityDescription = {
        NSEntityDescription.entity(forEntityName: "Quiz", in: self.managedObjectContext)
    }()!
    

    func fetchCoreData() {
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>()
        fetchRequest.entity = entity
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "id", ascending: true)]
        
        do {
            try quizes = managedObjectContext.fetch(fetchRequest) as? [Quiz]
        } catch {
            print(error)
            fetchFailedDelegate?.coreDataFetchFailure()
        }
    }
    
    func updateCells() {
        DispatchQueue.main.async { 
            self.tableView?.reloadRows(at: self.cellsToReload, with: UITableViewRowAnimation.none)
            self.cellsToReload = []
        }
    }

    
    func fetchWebData(_ amount: Int16, offset: Int16, shouldRegenerateTable: Bool) {
        
        fetchingInProgress = true
        downloadManager?.getQuizList(amount, offset: offset, onCompletion: { (quizArray, error) in
            
            guard error == nil else {
                self.fetchFailedDelegate?.webDataFetchFailure()
                return
            }
            
            for quiz in quizArray! {
                let quizObject = Quiz(quizInfo: quiz, entity: self.entity, insertIntoManagedObjectContext: self.managedObjectContext)
                self.quizes?.append(quizObject)
            }
            
            self.fetchingInProgress = false
            
            
            
            if shouldRegenerateTable {
                 DispatchQueue.main.async {
                     self.tableView?.reloadData()
                }
            } else {
                self.updateCells()
            }
            
            do {
                try self.managedObjectContext.save()
            } catch {
                print(error)
                self.quizes = Array(self.quizes!.prefix(self.quizes!.count - quizArray!.count))
            }
        })
    }
    
    func selectedQuiz() -> Quiz {
        let quiz = quizes![self.tableView!.indexPathForSelectedRow!.row]
        return quiz
    }
}

//MARK: UITableViewDataSource
extension QuizListDataProvider: UITableViewDataSource {
    
    func loadingCell(_ cell: QuizCell) {
        cell.activityView.isHidden = false
    }
    
    func configureCellForIndexPath(_ cell: QuizCell, indexPath: IndexPath) {
        let currentQuiz = quizes![indexPath.row]
        
        cell.activityView.isHidden = true
        
        cell.title.text = currentQuiz.title
        cell.correctAnswers.text = "\(currentQuiz.questionsCorrect)" + " / " + "\(currentQuiz.questionsCount)"
        cell.quizImage.sd_setImage(with: URL(string: currentQuiz.photoUrl!), placeholderImage: UIImage(named: "placeholder"))
        
        guard currentQuiz.questionsDone > 0 else {
            cell.startedQuizView.isHidden = true
            cell.finishedQuizView.isHidden = true
            return
        }
        
        if currentQuiz.questionsDone > 0 {
            if currentQuiz.questionsDone == currentQuiz.questionsCount {
                cell.startedQuizView.isHidden = true
                cell.finishedQuizView.isHidden = false
            } else {
                cell.startedQuizView.isHidden = false
                cell.finishedQuizView.isHidden = true
            }
        }
        
        
        let percentageScore = Float(currentQuiz.questionsCorrect) / Float(currentQuiz.questionsCount)
        cell.percentageScore.text = "\((percentageScore * 100).format(".0"))%"
        
        let attemptedQuestionsPercent = Float(currentQuiz.questionsDone) / Float(currentQuiz.questionsCount)
        cell.attemptedQuestions.text = "\((attemptedQuestionsPercent * 100).format(".0"))%"
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView?.dequeueReusableCell(withIdentifier: cellIdentifier) as! QuizCell
        
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if fetchingInProgress == false && downloadManager!.userDefaults!.object(forKey: "amountOfQuizes") == nil {
            fetchWebData(chunkSize, offset: 0, shouldRegenerateTable: true)
        }
        
        return downloadManager!.userDefaults!.integer(forKey: "amountOfQuizes")
    }
}
