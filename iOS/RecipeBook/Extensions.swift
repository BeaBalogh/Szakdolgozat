//
//  Extensions.swift
//  RecipeBook
//
//  Created by Beatrix Balogh on 2019. 12. 06..
//  Copyright © 2019. Beatrix Balogh. All rights reserved.
//

import Foundation
import UIKit

final class ContentSizedImageView: UIImageView {
    
    override var intrinsicContentSize: CGSize {
        layoutIfNeeded()
        return CGSize(width: frame.width, height: 0.0)
    }
}
final class ContentSizedTableView: UITableView {
    
    override var contentSize:CGSize {
        didSet {
            invalidateIntrinsicContentSize()
        }
    }
    
    override var intrinsicContentSize: CGSize {
        layoutIfNeeded()
        return CGSize(width: frame.width, height: contentSize.height)
    }
}
final class ContentSizedTextView: UITextView {
    
    override var contentSize:CGSize {
        didSet {
            invalidateIntrinsicContentSize()
        }
    }
    
    override var intrinsicContentSize: CGSize {
        layoutIfNeeded()
        return CGSize(width: frame.width, height: contentSize.height)
    }
}


extension Date {
    
    func toMillis() -> Int! {
        return Int(self.timeIntervalSince1970 * 1000)
    }
    func string(format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
}

extension UIImage {
    func resize(image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size
        
        let widthRatio  = targetSize.width  / image.size.width
        let heightRatio = targetSize.height / image.size.height
        
        var newSize: CGSize
        if widthRatio > heightRatio {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
        }
        
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
}
