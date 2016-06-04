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
    
    override func viewDidAppear(animated: Bool) {
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataProvider = QuizListDataProvider()
        let downloadManager = DownloadManager()
        downloadManager.userDefaults = NSUserDefaults.standardUserDefaults()
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

}

extension QuizListController: QuizListDataProviderFailureDelegateProtocol {
    
    func coreDataFetchFailure() {
        let alertController = UIAlertController(title: "Fetch error", message: "Unable to fetch data from local database", preferredStyle: UIAlertControllerStyle.Alert)
        self.presentViewController(alertController, animated: false, completion: nil)
        alertController.addAction(UIAlertAction(title: "Ok", style: .Cancel, handler: { action in
            switch action.style{
            case .Default:
                print("default")
                
            case .Cancel:
                print("cancel")
                
            case .Destructive:
                print("destructive")
            }
        }))
    }
    
    func webDataFetchFailure() {
        let alertController = UIAlertController(title: "Fetch error", message: "Unable to fetch data from web serwis", preferredStyle: UIAlertControllerStyle.Alert)
        self.presentViewController(alertController, animated: false, completion: nil)
        alertController.addAction(UIAlertAction(title: "Ok", style: .Cancel, handler: { action in
            switch action.style{
            case .Default:
                print("default")
                
            case .Cancel:
                print("cancel")
                
            case .Destructive:
                print("destructive")
            }
        }))
    }
}

