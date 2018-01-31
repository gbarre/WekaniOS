//
//  Card.swift
//  Wekan
//
//  Created by Guillaume on 31/01/2018.
//


/*
 "_id":"zRgbeFGj5iKsENrXz"
 "title":"Carte 1"
 "members":["2hBLgnBSjfb7gZLDv"]
 "labelIds":[]
 "listId":"9yQ4crh3DQ85J5omC"
 "boardId":"T6CCAvjpR9FD6M3kr"
 "sort":0,
 "archived":false
 "createdAt":"2018-01-29T23:47:30.655Z",
 "dateLastActivity":"2018-01-29T23:47:42.826Z",
 "isOvertime":false,
 "userId":"2hBLgnBSjfb7gZLDv"
 "description":"une description
 */

import UIKit

class Card: NSObject {
    
    var id: String
    var title: String
    var desc: String
    var members = [String]()
    
    
    required init(id: String, title: String, desc: String = "") {
        self.id = id
        self.title = title
        self.desc = desc
    }
}
