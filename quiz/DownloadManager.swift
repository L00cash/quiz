//
//  QuizData.swift
//  quiz
//
//  Created by Łukasz Bożek on 02/06/16.
//  Copyright © 2016 company. All rights reserved.
//

import Foundation

typealias ListRespose = ([QuizInfo]?, NSError?) -> Void


struct DownloadManagerConstants {
    static let quizListUrl = "http://quiz.o2.pl/api/v1/quizzes/"
    
//    static let quizDetailsUrl = ""
}

class DownloadManager: NSObject, DownloadManagerProtocol {
    
    var userDefaults: NSUserDefaults?
    
    func getQuizList(amount: Int16, offset: Int16, onCompletion: ListRespose) -> Void {
        let url = DownloadManagerConstants.quizListUrl + "\(offset)/" + "\(amount)"
        let request = NSMutableURLRequest(URL: NSURL(string: url)!)
        request.HTTPMethod = "GET"
        
        let session = NSURLSession.sharedSession()
        
        let task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
            var quizList: [QuizInfo]? = nil
            if error == nil {
                var dict: Dictionary<NSString, AnyObject>?
                var JSONerror: NSError?
                do {
                    dict = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as? Dictionary
                    
                    quizList = self.parseQuizList(dict!)

                } catch let err as NSError {
                    JSONerror = err
                    print("Error -> \(err)")
                }
                
                onCompletion(quizList, JSONerror)
            } else {
                onCompletion(nil, error)
            }
        })
        
        task.resume()
    }
    
    
    func parseQuizList(dict: Dictionary<NSString, AnyObject>) -> [QuizInfo] {
        let amountOfQuizes = dict["count"] as! NSNumber
        userDefaults!.setObject(amountOfQuizes, forKey: "amountOfQuizes")
        
        
        let items = dict["items"] as? NSArray
        var arr = [QuizInfo]()
        for item in items! {
            arr.append(QuizInfo(dictionary: item as! NSDictionary))
        }
        
        return arr
    }
    
}