//
//  Donation.swift
//  Due
//
//  Created by Lucas Andrade on 9/22/17.
//  Copyright © 2017 Hera Technologies. All rights reserved.
//

import UIKit

class Donation: NSObject {
    
    var status: String?
    var amount: String?
    var created: String?
    var available: String?
    var username: String?
    
    init(json: [String: Any]) {
        super.init()
        
        if let status = json["status"] as? String {
            self.status = translateStatus(stat: status)
        }
        if let rawAmount = json["amount"] as? Int {
            let amount = "R$ " + String(describing: rawAmount) + ",00"
            self.amount = amount
        }
        if let created = json["created"] as? Double {
            let date = translateDate(timestamp: created)
            self.created = date
        }
        if let available = json["available"] as? Double {
            let date = translateDate(timestamp: available)
            self.available = date
        }
        if let name = json["username"] as? String {
            self.username = name
        }
        
    }
    
    func translateDate(timestamp: Double) -> String {
        let interval = TimeInterval(timestamp)
        let date = Date(timeIntervalSince1970: interval)
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone(abbreviation: "PST")
        formatter.locale = NSLocale.current
        formatter.dateFormat = "dd.MM.yyyy"
        let dateStr = formatter.string(from: date)
        return dateStr
    }
    
    func translateStatus(stat: String) -> String {
        var status = stat
        switch status {
        case "pending":
            status = "pendente"
        case "paid":
            status = "pago"
        default: break
        }
        return "( \(status) )"
    }
    
}
