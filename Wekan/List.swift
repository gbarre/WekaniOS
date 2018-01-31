//
//  List
//  wekanBoardsiOS
//
//  Created by Guillaume on 31/01/2018.
//

/*
 "_id":"9yQ4crh3DQ85J5omC"
 "title":"test1"
 "boardId":"T6CCAvjpR9FD6M3kr"
 "sort":1
 "archived":false
 "createdAt":"2018-01-29T23:47:26.707Z"
 "wipLimit":{"value":1,"enabled":false,"soft":false}
 */

import UIKit

class List: NSObject {

    var id: String
    var title: String
    
    required init(id: String, title: String) {
        self.id = id
        self.title = title
    }
}
