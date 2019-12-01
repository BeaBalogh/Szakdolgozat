//
//  CommentsViewController.swift
//  RecipeBook
//
//  Created by Beatrix Balogh on 2019. 11. 19..
//  Copyright © 2019. Beatrix Balogh. All rights reserved.
//

import UIKit
import HCSStarRatingView
import GrowingTextView

let data = Comment(id: "asd", userName: "Kovacs Andras" , text: "finom", imgURL: "", date: "nov. 06, 2019 14:03", rating: 4.5)
private var comments = [data, data, data]


class CommentsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
 
    @IBOutlet weak var commentsTable: ContentSizedTableView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var ratingbarView: HCSStarRatingView!
    @IBOutlet weak var commentTextView: GrowingTextView!
    @IBOutlet weak var mealImageView: UIImageView!
   
    override func viewDidLoad() {
        super.viewDidLoad()
            //(tabBarController as! DetailsTabViewController).recipe.comments
        commentsTable.delegate = self
        commentsTable.dataSource = self
        commentTextView.layer.cornerRadius = 4
        commentTextView.layer.borderWidth = 1
        commentTextView.layer.borderColor =  UIColor.lightGray.cgColor
        commentTextView.layer.masksToBounds = false
        mealImageView.layer.cornerRadius = 4
        mealImageView.layer.borderWidth = 1
        mealImageView.layer.borderColor =  UIColor.lightGray.cgColor
        mealImageView.layer.masksToBounds = false
    }
    

    func textViewDidChangeHeight(_ textView: GrowingTextView, height: CGFloat) {
        UIView.animate(withDuration: 0.2) {
            self.view.layoutIfNeeded()
        }
    }

    
    // MARK: - tableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = commentsTable.dequeueReusableCell(withIdentifier: "commentCell", for: indexPath) as! CommentTableViewCell
        
        let comment = comments[indexPath.row]
        print(comment)
        cell.usernameLabel.text = comment.userName
        cell.dateLabel.text = comment.date
        cell.ratingbarView.value = CGFloat(comment.rating)
        if (comment.imgURL == "") {
            cell.mealImageView.isHidden = true
        }
        cell.commentTextView.text = comment.text
    
        return cell
    }

}


final class ContentSizedImageView: UIImageView {

    override var intrinsicContentSize: CGSize {
        layoutIfNeeded()
        return CGSize(width: frame.width, height: 0.0)
    }
}
