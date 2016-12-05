//
//  QuizData.swift
//  quiz
//
//  Created by Łukasz Bożek on 02/06/16.
//  Copyright © 2016 company. All rights reserved.
//

import Foundation

typealias ListRespose = ([QuizInfo]?, Error?) -> Void
typealias QuizResponse = ([QuestionInfo]?, Error?) -> Void


struct DownloadManagerConstants {
    static let quizListUrl = "http://quiz.o2.pl/api/v1/quizzes/"
    static let quizUrl = "http://quiz.o2.pl/api/v1/quiz/"
    
//    static let quizDetailsUrl = ""
}

class DownloadManager: NSObject, DownloadManagerProtocol {
    
    var userDefaults: UserDefaults?
    
    func getQuizList(_ amount: Int16, offset: Int16, onCompletion: @escaping ListRespose) {
        let url = DownloadManagerConstants.quizListUrl + "\(offset)/" + "\(amount)"
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = "GET"
        
        let session = URLSession.shared
        
        let task = session.dataTask(with: request) { (data, response, error) in
            var quizList: [QuizInfo]? = nil
            if error == nil {
                var dict: Dictionary<NSString, AnyObject>?
                var JSONerror: NSError?
                do {
                    dict = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as? Dictionary
                    
                    quizList = self.parseQuizList(dict!)
                    
                } catch let err as NSError {
                    JSONerror = err
                    print("Error -> \(err)")
                }
                
                onCompletion(quizList, JSONerror)
            } else {
                onCompletion(nil, error)
            }
        }
        
        
        task.resume()
    }

    
//    func getQuizList(_ amount: Int16, offset: Int16, onCompletion: @escaping ListRespose) -> Void {
//        
//    }
    
    internal func getQuizDetails(_ quizId: String, onCompletion: @escaping QuizResponse) {
        let url = DownloadManagerConstants.quizUrl + quizId + "/0"
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = "GET"
        
        let session = URLSession.shared
        
        let task = session.dataTask(with: request, completionHandler: {data, response, error -> Void in
            var questionList: [QuestionInfo] = []
            if error == nil {
                var dict: Dictionary<NSString, AnyObject>?
                var JSONerror: NSError?
                do {
                    dict = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as? Dictionary
                    
                    questionList = self.parseQuestionList(dict!)
                    
                } catch let err as NSError {
                    JSONerror = err
                    print("Error -> \(err)")
                }
                
                onCompletion(questionList, JSONerror)
            } else {
                onCompletion(nil, error)
            }
        })
        
        task.resume()
    }
    
    
    func parseQuestionList(_ dict: Dictionary<NSString, AnyObject>) -> [QuestionInfo] {
        let questions = dict["questions"] as! NSArray
        
        var arr = [QuestionInfo]()
        for question in questions {
            arr.append(QuestionInfo(dictionary: question as! NSDictionary))
        }
        
        return arr
    }
    
    func parseQuizList(_ dict: Dictionary<NSString, AnyObject>) -> [QuizInfo] {
        let amountOfQuizes = dict["count"] as! NSNumber
        userDefaults!.set(amountOfQuizes, forKey: "amountOfQuizes")
        
        
        let items = dict["items"] as? NSArray
        var arr = [QuizInfo]()
        for item in items! {
            arr.append(QuizInfo(dictionary: item as! NSDictionary))
        }
        
        return arr
    }
    
}
