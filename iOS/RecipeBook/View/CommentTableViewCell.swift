//
//  CommentTableViewCell.swift
//  RecipeBook
//
//  Created by Beatrix Balogh on 2019. 11. 18..
//  Copyright © 2019. Beatrix Balogh. All rights reserved.
//

import UIKit
import HCSStarRatingView

class CommentTableViewCell: UITableViewCell {
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var ratingbarView: HCSStarRatingView!
    @IBOutlet weak var commentTextView: UITextView!
    @IBOutlet weak var commentImageView: ContentSizedImageView!
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
