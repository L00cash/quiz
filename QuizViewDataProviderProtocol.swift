//
//  QuizViewDataProviderProtocol.swift
//  quiz
//
//  Created by Łukasz Bożek on 04/06/16.
//  Copyright © 2016 company. All rights reserved.
//

import UIKit

protocol QuizViewDataProviderProtocol: UITableViewDataSource {
    init(quiz: Quiz, questionNbr: Int, downloadManager: DownloadManagerProtocol)
    weak var delegate: QuizViewDataProviderDelegateProtocol? {get set}
    var tableView: UITableView? {get set}
    func answer(answerNumber: Int)
    var downloadManager: DownloadManagerProtocol?  {get set}
}