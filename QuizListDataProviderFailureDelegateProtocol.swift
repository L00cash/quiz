//
//  QuizListDataProviderFailureDelegateProtocol.swift
//  quiz
//
//  Created by Łukasz Bożek on 04/06/16.
//  Copyright © 2016 company. All rights reserved.
//

import Foundation

protocol QuizListDataProviderFailureDelegateProtocol: class {
    func coreDataFetchFailure()
    func webDataFetchFailure()
}