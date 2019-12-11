//
//  NewIngredientTableViewCell.swift
//  RecipeBook
//
//  Created by Beatrix Balogh on 2019. 12. 11..
//  Copyright © 2019. Beatrix Balogh. All rights reserved.
//

import UIKit

class NewIngredientTableViewCell: UITableViewCell {

    @IBOutlet weak var measureTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var deleteButton: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
