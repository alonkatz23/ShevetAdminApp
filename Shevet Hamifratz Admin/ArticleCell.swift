//
//  ArticleCell.swift
//  Shevet Hamifratz Admin
//
//  Created by Alon Katz on 1/30/18.
//  Copyright © 2018 Shevet Hamifratz. All rights reserved.
//

import UIKit

class ArticleCell: UITableViewCell {

    
    @IBOutlet weak var articleImage: UIImageView!
    
    @IBOutlet weak var articleTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    //random text
}
