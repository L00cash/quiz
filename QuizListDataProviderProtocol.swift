//
//  QuizListDataProviderProtocol.swift
//  quiz
//
//  Created by Łukasz Bożek on 04/06/16.
//  Copyright © 2016 company. All rights reserved.
//

import UIKit

protocol QuizListDataProviderProtocol: UITableViewDataSource {
    weak var tableView: UITableView? {get set}
    var downloadManager: DownloadManagerProtocol?  {get set}
    weak var fetchFailedDelegate: QuizListDataProviderFailureDelegateProtocol? {get set}
    func fetchCoreData()
    func fetchWebData(amount: Int16, offset: Int16)
}