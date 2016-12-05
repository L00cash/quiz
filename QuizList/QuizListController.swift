//
//  ViewController.swift
//  quiz
//
//  Created by Łukasz Bożek on 02/06/16.
//  Copyright © 2016 company. All rights reserved.
//

import UIKit

class QuizListController: UITableViewController {
    
    var dataProvider: QuizListDataProviderProtocol?
    
    override func viewDidAppear(_ animated: Bool) {
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataProvider = QuizListDataProvider()
        let downloadManager = DownloadManager()
        downloadManager.userDefaults = UserDefaults.standard
        dataProvider!.downloadManager = downloadManager
        dataProvider!.fetchFailedDelegate = self
        dataProvider?.fetchCoreData()
        dataProvider?.tableView = self.tableView
//        dataProvider?.fetchWebData(10, offset: 0)
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "openQuiz" {
            let selectedQuiz = dataProvider?.selectedQuiz()
            let destinationController = (segue.destination as! QuizViewController)
            destinationController.quiz = selectedQuiz
            destinationController.questionNumber = Int(selectedQuiz!.questionsDone)
        }
    }

}

extension QuizListController: QuizListDataProviderFailureDelegateProtocol {
    
    func coreDataFetchFailure() {
        let alertController = UIAlertController(title: "Fetch error", message: "Unable to fetch data from local database", preferredStyle: UIAlertControllerStyle.alert)
        self.present(alertController, animated: false, completion: nil)
        alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
            switch action.style{
            case .default:
                print("default")
                
            case .cancel:
                print("cancel")
                
            case .destructive:
                print("destructive")
            }
        }))
    }
    
    func webDataFetchFailure() {
        let alertController = UIAlertController(title: "Fetch error", message: "Unable to fetch data from web serwis", preferredStyle: UIAlertControllerStyle.alert)
        self.present(alertController, animated: false, completion: nil)
        alertController.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { action in
            switch action.style{
            case .default:
                print("default")
                
            case .cancel:
                print("cancel")
                
            case .destructive:
                print("destructive")
            }
        }))
    }
}

