//
//  QuizViewDataProviderProtocol.swift
//  quiz
//
//  Created by Łukasz Bożek on 04/06/16.
//  Copyright © 2016 company. All rights reserved.
//

import UIKit

protocol QuizViewDataProviderProtocol: UITableViewDataSource {
    init(quiz: Quiz, questionNbr: Int, downloadManager: DownloadManagerProtocol, delegate: QuizViewDataProviderDelegateProtocol)
    weak var delegate: QuizViewDataProviderDelegateProtocol? {get set}
    var tableView: UITableView? {get set}
    func answer(_ answerNumber: Int) -> Answer
    func checkCorrectAnswer(_ selectedAnswer: Int)
    var downloadManager: DownloadManagerProtocol?  {get set}
}
