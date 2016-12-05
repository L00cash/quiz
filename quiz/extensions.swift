//
//  extensions.swift
//  quiz
//
//  Created by Łukasz Bożek on 04/06/16.
//  Copyright © 2016 company. All rights reserved.
//

import UIKit

extension CATransition {
    class func transitionFromRight() -> CATransition {
        let transition = CATransition()
        transition.duration = 0.4
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromRight
        return transition
    }
}

extension Float {
    func format(_ f: String) -> String {
        return String(format: "%.\(f)f", self)
    }
}
