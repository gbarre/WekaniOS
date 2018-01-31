//
//  Board.swift
//  wekanBoardsiOS
//
//  Created by Guillaume on 31/01/2018.
//

/*
 "_id":"T6CCAvjpR9FD6M3kr"
 "title":"test"
 "permission":"private"
 "slug":"test"
 "archived":false
 "createdAt":"2018-01-29T08:23:47.724Z"
 "stars":0
 "labels":[
    {"color":"green","_id":"8eDxwP","name":""}
    {"color":"yellow","_id":"wDtGQM","name":""}
    {"color":"orange","_id":"7gSqDZ","name":""}
    {"color":"red","_id":"b3nCqu","name":""}
    {"color":"purple","_id":"BmDa2C","name":""}
    {"color":"blue","_id":"d6wdGn","name":""}
 ]
 "members":[{
    "userId":"2hBLgnBSjfb7gZLDv"
    "isAdmin":true
    "isActive":true
    "isCommentOnly":false
 }]
 "color":"belize"
 "modifiedAt":"2018-01-29T23:47:21.456Z"
 */

import UIKit

class Board: NSObject {

    var id: String
    var title: String
    var usersId = [String]()
    
    required init(id: String, title: String) {
        self.id = id
        self.title = title
    }
}
