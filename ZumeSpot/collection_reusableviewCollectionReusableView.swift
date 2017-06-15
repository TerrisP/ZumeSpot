//
//  collection_reusableviewCollectionReusableView.swift
//  ZumeSpot
//
//  Created by Terris Phillips on 6/4/17.
//  Copyright © 2017 Terris Phillips. All rights reserved.
//

import UIKit

class collection_reusableviewCollectionReusableView: UICollectionReusableView {
    @IBOutlet var load_more_button: UIButton!
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.clear
        
        
        let imageView=UIImageView(frame: CGRect(x: 20, y: 38, width: 20, height: 15))
        imageView.image=UIImage(named: "backbutton")
        
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
