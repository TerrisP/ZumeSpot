//
//  ProfileVC.swift
//  ZumeSpot
//
//  Created by Sagar on 20/06/17.
//  Copyright © 2017 mrinal khullar. All rights reserved.
//

import UIKit
import FirebaseDatabase


class ProfileVC: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, CHTCollectionViewDelegateWaterfallLayout {

    @IBOutlet var hotelnamelabel: UILabel!
    @IBOutlet weak var collection_view: UICollectionView!
    @IBOutlet weak var loadmorebutton: UIButton!
    
    @IBOutlet weak var postbutton: UIButton!
    @IBOutlet weak var posttextview: UITextView!
    @IBOutlet var systemdatelabel: UILabel!
    @IBOutlet var lblUserName: UILabel!
    @IBOutlet var zumespoticontop: UIImageView!
    @IBOutlet var imgProfile: UIImageView!
    @IBOutlet weak var backbutton: UIButton!
    @IBOutlet weak var lblCount: UILabel!
    var details = [compareTimestamp]()
    var postidarray = NSMutableArray()
    var posttextarray = NSMutableArray()
    
    let label = UILabel()
    var backviewofactivity = UIView()
    var imageArray = [UIImage]()
    var indexofselectedrow = 2000
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //BACK VIEW OF ACTIVITY INDICATOR
        let widthofview = self.view.frame.size.width
        let heightofview = self.view.frame.size.height
        
        backviewofactivity.frame = CGRect(x: 0, y: 0, width: widthofview, height: heightofview)
        backviewofactivity.backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 254/255, alpha: 0.5)
        self.view.addSubview(backviewofactivity)
        
        //DATE OF LABEL
        let todaysDate:Date = Date()
        let dateFormatter:DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMMM yyyy"
        let DateInFormat:String = dateFormatter.string(from: todaysDate)
        self.systemdatelabel.text = DateInFormat
        ActivityIndicator.current().show()
        self.backviewofactivity.isHidden=false
        self.collection_view.backgroundView = UIImageView(image: UIImage(named: "gridbackonfeed")!)
        setupCollectionView()
        
        self.getProfileInfo()
        self.getLikeFeedDetail()
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func setupCollectionView()
    {
        // Create a waterfall layout
        let layout = CHTCollectionViewWaterfallLayout()
        
        // Change individual layout attributes for the spacing between cells
        
        if (UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad)
        {
            layout.minimumColumnSpacing = 4.0
            layout.minimumInteritemSpacing = 4.0
            layout.sectionInset.left=4.0
            layout.sectionInset.right=4.0
        }
        else
        {
            layout.minimumColumnSpacing = 4.0
            layout.minimumInteritemSpacing = 4.0
            layout.sectionInset.left=4.0
            layout.sectionInset.right=4.0
        }
        
        // Collection view attributes
      //  self.collection_view.autoresizingMask = [UIViewAutoresizing.flexibleWidth, UIViewAutoresizing.flexibleHeight]
        self.collection_view.alwaysBounceVertical = true
        
        // Add the waterfall layout to your collection view
        self.collection_view.collectionViewLayout = layout
       // collection_view.register(collection_reusableviewCollectionReusableView.self, forSupplementaryViewOfKind: CHTCollectionElementKindSectionFooter, withReuseIdentifier: FOOTER_IDENTIFIER)
        
        //  layout.footerHeight = 50
        
    }
    
    func getProfileInfo() {
        //Get UserId
//        let
        if let userUrl = UserDefaults.standard.object(forKey: "userUrl") as? String {
            
            let ref = Database.database().reference()
            ref.child(userUrl).observeSingleEvent(of: .value, with: { (snap) in
                print("ProfileDic", snap)
                
                //print(snap.value)
                if let dict = snap.value as? NSDictionary {
                    self.lblUserName.text = dict.value(forKey: "fullName") as? String
                    if let url = dict.value(forKey: "picture") as? String {
                        let data = try?  Data(contentsOf: URL(string: url)!)
                        if data != nil {
                            self.imgProfile.image = UIImage(data: data!)
                        }
                    }
                }
            })
        }
    }
    
    
    func getLikeFeedDetail() {

        self.lblCount.isHidden = true
        //Firebase to delete post
        let ref = Database.database().reference()
        if let userUrl = UserDefaults.standard.object(forKey: "userUrl") as? String {
            let uId = userUrl.components(separatedBy: "/")[2]
            ref.child("PostLike/" + uId).observeSingleEvent(of: .value, with: { (snap) in
                
                print(snap.value)
                if let allLikePosts = snap.value, !(allLikePosts is NSNull) {
                    for dict in allLikePosts as! NSDictionary{
                    let imgData = Data(base64Encoded: dict.value as! String, options: NSData.Base64DecodingOptions.ignoreUnknownCharacters)
                    let img = UIImage(data:imgData!)
                        self.imageArray.append(img!)
                    }
                }
                 self.collection_view.reloadData()
                if self.imageArray.count == 0 {
                    self.lblCount.isHidden = false
                }
                
                ActivityIndicator.current().hide()
                self.backviewofactivity.isHidden=true
                
                
              /*
                     if let allLikePosts = snap.value, !(allLikePosts is NSNull) {
                    let allLikePostsDict = allLikePosts as! NSDictionary
                for obj in allLikePostsDict {
                    let dictObj = obj.value as! NSDictionary
                    let posttext = dictObj.value(forKey: "posttext") as! String
                    let likecount = dictObj.value(forKey: "likecount") as! String
                    let commentcount = dictObj.value(forKey: "commentcount") as! String
                    let image = dictObj.value(forKey: "image") as? String
                    let timestamp = (dictObj.value(forKey: "timestamp") as! Int)
                    let postid = dictObj.value(forKey: "postid") as! String
                    let alreadyliked = dictObj.value(forKey: "alreadyliked") as! String
                    let socialmediatype = dictObj.value(forKey: "socialmediatype") as! String
                    let posttextviewheight = dictObj.value(forKey: "posttextviewheight") as? CGFloat
                    let cellheight = dictObj.value(forKey: "cellheight") as? CGFloat
                    let hashtagpost = dictObj.value(forKey: "hashtagpost") as! String
                    let imagestatus = dictObj.value(forKey: "imagestatus") as! String
                    
                    let imgData = Data(base64Encoded: image!, options: NSData.Base64DecodingOptions.ignoreUnknownCharacters)
                    let img = UIImage(data:imgData!)
                    let compareTime = compareTimestamp.init(posttext: posttext, likecount: likecount, commentcount: commentcount, image: img!, timestamp: timestamp, postid: postid, alreadyliked: alreadyliked, socialmediatype: socialmediatype, posttextviewheight: posttextviewheight!, cellheight: cellheight!, hashtagpost: hashtagpost, imagestatus: imagestatus)
                    self.details.append(compareTime)
                    self.posttextarray.add(posttext)
                    self.postidarray.add(postid)*/
                //}
                
            })
        }
    }
    
    
    /// To go back home page
    ///
    /// - Parameter sender: is button type object
    @IBAction func btnBackTap(sender:UIButton) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    //MARK: Collection View Data Source And Delegates
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return self.imageArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        
        // get a reference to our storyboard cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CollectionViewCellFeed1
        
        cell.image_view.image = self.imageArray[indexPath.item]
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize
    {
        
//        for i in 0 ..< self.details.count
//        {
//            var xyz = CGFloat()
//            
//            label.text=self.details[i].posttext
//            let labeltext=self.details[i].posttext
//            
//            if (UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad)
//            {
//                if(labeltext.characters.count>100)
//                {
//                    xyz = 102.0
//                }
//                else
//                {
//                    xyz = self.getLabelHeight(label)+20.0
//                }
//                
//            }
//            else
//            {
//                if(labeltext.characters.count>100)
//                {
//                    xyz = 65.0
//                }
//                else
//                {
//                    xyz = self.getLabelHeight(label)+5.0
//                }
//            }
//            
//            self.details[i].posttextviewheight=CGFloat(xyz)
//        }
        
        var width3 = CGFloat()
        
        if (UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad)
        {
            width3 = (self.view.frame.width/2)-6.0
        }
        else
        {
            width3 = (self.view.frame.width/2)-6.0
        }
        
        var height1=CGFloat()
        
        if (UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad)
        {
            height1 = width3+60.0
        }
        else
        {
            if(indexPath.row == indexofselectedrow)
            {
                height1 = width3+80.0
            }
            else
            {
                height1 = width3+42.0
            }
        }
        
        //heightofcellarray.replaceObject(at: indexPath.row, with: height1)
        
        
        let imagesize = CGSize(width: width3, height: width3)
        return imagesize
    }

    //MARK: Get Text View Height From Label
    
    func getLabelHeight(_ label: UILabel) -> CGFloat
    {
        let constraint = CGSize(width: label.frame.size.width, height: CGFloat.greatestFiniteMagnitude)
        var size: CGSize
        let context = NSStringDrawingContext()
        let boundingBox = label.text!.boundingRect(with: constraint, options: .usesLineFragmentOrigin, attributes: [NSFontAttributeName: label.font], context: context).size
        size = CGSize(width: ceil(boundingBox.width), height: ceil(boundingBox.height))
        return size.height
        
    }
}
