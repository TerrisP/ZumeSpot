//  Created by Terris Phillips on 6/4/17.
//  Copyright © 2017 Terris Phillips. All rights reserved.
//


import UIKit

class CollectionViewCellFeed1: UICollectionViewCell {
    
    @IBOutlet var image_view: UIImageView!
    @IBOutlet var date_label: UILabel!
    @IBOutlet var comment_count: UILabel!
    @IBOutlet var commenttext: UILabel!
    @IBOutlet var likecount: UILabel!
    
    
    @IBOutlet weak var postcommenttextview: UITextView!
    @IBOutlet weak var commenttextview: UITextView!
    
    @IBOutlet weak var comment_Button: UIButton!
    @IBOutlet weak var commentbutton: UIButton!
    
    @IBOutlet weak var like_Button: UIButton!
    @IBOutlet weak var likebutton: UIButton!
    @IBOutlet var view_back: UIView!
    @IBOutlet var likeimage: UIImageView!
    @IBOutlet var commentimage: UIImageView!
    @IBOutlet weak var postbutton: UIButton!
}
