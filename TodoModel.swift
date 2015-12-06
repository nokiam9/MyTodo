//
//  TodoModel.swift
//  Todo
//
//  Created by imac on 15/12/6.
//  Copyright © 2015年 caogo.cn. All rights reserved.
//

import UIKit

class TodoModel: NSObject {
    var id: String
    var image: String
    var title: String
    var date: NSDate
   
    init(id: String, image: String, title: String, date: NSDate) {
        self.id = id
        self.image = image
        self.title = title
        self.date = date
    }
}
