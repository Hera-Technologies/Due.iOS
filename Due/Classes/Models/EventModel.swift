//
//  EventModel.swift
//  Due
//
//  Created by Lucas Andrade on 9/22/17.
//  Copyright © 2017 Hera Technologies. All rights reserved.
//

class EventModel: NSObject {
    
    var eventCode: String?
    var stripeAcc: String?
    
    // 1st Screen
    var songUrl: NSURL?
    var videoUrl: URL?
    var date: String?
    // CasalVC
    var hubPhoto: String?
    var hubName: String?
    var bridePhoto: String?
    var brideName: String?
    var story: String?
    // AlbumVC
    var photos = [Foto]()
    
    // 2nd Screen
    var padrinhos = [Foto]()
    var messages: NSMutableArray = NSMutableArray()
    
}

var eventModel = EventModel()
var evento = EventModel()
