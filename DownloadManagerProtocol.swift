//
//  DownloadManagerProtocol.swift
//  quiz
//
//  Created by Łukasz Bożek on 04/06/16.
//  Copyright © 2016 company. All rights reserved.
//

import Foundation

protocol DownloadManagerProtocol {
    func getQuizList(amount: Int16, offset: Int16, onCompletion: ListRespose) -> Void
    func getQuizDetails(quizId: String, onCompletion: QuizResponse) -> Void
    var userDefaults: NSUserDefaults? {get set}
}