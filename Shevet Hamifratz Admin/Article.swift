//
//  Article.swift
//  Shevet Hamifratz Admin
//
//  Created by Alon Katz on 1/30/18.
//  Copyright © 2018 Shevet Hamifratz. All rights reserved.
//

import UIKit

class Article: NSObject {
    var articleImageUrl: String?
    var content: String?
    var title: String?
    var date: Int?
        init(dictionary: [String: AnyObject]) {
            self.title = dictionary["title"] as? String
            self.content = dictionary["content"] as? String
            self.articleImageUrl = dictionary["articleImageUrl"] as? String
            self.date = dictionary["date"] as? Int
        }
}
