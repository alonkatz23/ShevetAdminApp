//
//  CustomArticleCell.swift
//  
//
//  Created by Alon Katz on 1/30/18.
//

import UIKit

class CustomArticleCell: UITableViewCell {

    @IBOutlet var articleTitle: UILabel!
    
    @IBOutlet var articleImage: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
