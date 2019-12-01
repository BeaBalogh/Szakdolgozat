//
//  IngredientsTableViewCell.swift
//  RecipeBook
//
//  Created by Beatrix Balogh on 2019. 11. 18..
//  Copyright © 2019. Beatrix Balogh. All rights reserved.
//

import UIKit

class IngredientsTableViewCell: UITableViewCell {

    @IBOutlet weak var measureLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
