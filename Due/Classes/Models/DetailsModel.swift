//
//  DetailsModel.swift
//  Due
//
//  Created by Lucas Andrade on 9/22/17.
//  Copyright © 2017 Hera Technologies. All rights reserved.
//

import UIKit

class DetailsModel: NSObject {
    var nameSet: Bool?
    var hasDue: Bool?
    var eventID: String?
    var eventName: String?
    var dateStart: String?
    var dateEnd: String?
    var stripeAcc: String?
    
    var name: String?
    var email: String?
    var profilePhoto: String?
}

var details = DetailsModel()
