//
//  TodoModel.swift
//  Todo
//
//  Created by imac on 15/12/6.
//  Copyright © 2015年 caogo.cn. All rights reserved.
//

import UIKit

// 这里采用的是定义class的方法。如果采用定义struct的方法，在数据传递时将采用数据硬拷贝，导致新View无法修改原始数据
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

