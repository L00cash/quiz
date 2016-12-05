//
//  DownloadManagerProtocol.swift
//  quiz
//
//  Created by Łukasz Bożek on 04/06/16.
//  Copyright © 2016 company. All rights reserved.
//

import Foundation

protocol DownloadManagerProtocol {
    func getQuizList(_ amount: Int16, offset: Int16, onCompletion: @escaping ListRespose) -> Void
    func getQuizDetails(_ quizId: String, onCompletion: @escaping QuizResponse) -> Void
    var userDefaults: UserDefaults? {get set}
}
