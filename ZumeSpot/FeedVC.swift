

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs, rhs) {
    case let (l?, r?):
        return l < r
    case (nil, _?):
        return true
    default:
        return false
    }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs, rhs) {
    case let (l?, r?):
        return l > r
    default:
        return rhs < lhs
    }
}

class compareTimestamp
{
    var posttext: String
    var likecount: String
    var commentcount: String
    var image: UIImage
    var timestamp:Int
    var postid: String
    var alreadyliked: String
    var socialmediatype: String
    var posttextviewheight: CGFloat
    var cellheight: CGFloat
    var hashtagpost: String
    var imagestatus: String
    
    init(posttext: String, likecount: String, commentcount: String, image: UIImage,timestamp: Int,postid: String,alreadyliked: String,socialmediatype: String,posttextviewheight: CGFloat,cellheight: CGFloat,hashtagpost: String,imagestatus: String){
        self.posttext = posttext
        self.likecount = likecount
        self.commentcount = commentcount
        self.image = image
        self.timestamp = timestamp
        self.postid = postid
        self.alreadyliked = alreadyliked
        self.socialmediatype = socialmediatype
        self.posttextviewheight = posttextviewheight
        self.cellheight = cellheight
        self.hashtagpost = hashtagpost
        self.imagestatus = imagestatus
    }
}

class FeedVC: UIViewController,UICollectionViewDataSource, UICollectionViewDelegate, UITextViewDelegate,CHTCollectionViewDelegateWaterfallLayout,UIScrollViewDelegate
{
    var details = [compareTimestamp]()
    var postidarray = NSMutableArray()
    var posttextarray = NSMutableArray()
    
    let HEADER_IDENTIFIER = "WaterfallHeader"
    let FOOTER_IDENTIFIER = "WaterfallFooter"
    var nextUrl = ""
    
    var heightoffooter = CGFloat()
    
    @IBOutlet weak var backbutton: UIButton!
    
    @IBOutlet var hotelnamelabel: UILabel!
    @IBOutlet weak var collection_view: UICollectionView!
    @IBOutlet weak var loadmorebutton: UIButton!
    
    @IBOutlet weak var postbutton: UIButton!
    @IBOutlet weak var posttextview: UITextView!
    @IBOutlet var systemdatelabel: UILabel!
    
    @IBOutlet var zumespoticontop: UIImageView!
    
    var placeholderstring="Write Comment"
    
    var restaurantlabelname=NSString()
    
    var extraarray:[CGFloat]=[]
    var itemsdict = NSMutableDictionary()
    var instaimgurl=NSArray()
    var instagramimgarr=NSMutableArray()
    var hotelname=NSString()
    var imagearray1=NSMutableArray()
    var instacommentsarr=NSMutableArray()
    var instalikesarr=NSMutableArray()
    var instacaptionarr=NSMutableArray()
    var instadatearray1=NSArray()
    var instadatearray2=NSMutableArray()
    
    var imagearray3=NSMutableArray()
    
    var footerhidden=0
    
    var sizearray3=NSMutableArray()
    
    let obj1 = ViewController()
    
    let label = UILabel()
    
    var backviewofactivity = UIView()
    
    var facebookidresponse = NSMutableDictionary()
    
    var facebookimageres = NSMutableDictionary()
    
    var facebookimageurlarr = NSMutableArray()
    
    var facebooklikecountdict = NSMutableDictionary()
    
    var facebooklikecountarray = NSMutableArray()
    
    var facebookcommentcountdict = NSMutableDictionary()
    
    var facebookcommentcountarray = NSMutableArray()
    
    var insfbtwittercount1 = 0
    var insfbtwittercount2 = 0
    var facebookurlcount = 0
    
    var facebookimageurlcount = 0
    
    var facebookidarray = NSMutableArray()
    var facebookdatearray = NSMutableArray()
    var facebookmessagearray = NSMutableArray()
    
    var twitterimagesarr = NSMutableArray()
    
    var twittercount = 0
    
    var instagramiddict = NSMutableDictionary()
    
    var facebookuserdict = NSMutableDictionary()
    
    var twitteruserdict = NSMutableDictionary()
    
    var facebookimageurl = NSMutableArray()
    
    var facebookandtwitter = 0
    var twitterandinstagram = 0
    
    var posttextviewcount = 0
    
    var heightofcellarray = NSMutableArray()
    
    var indexofselectedrow = 2000
    
    var idsofposts = NSMutableArray()
    
    var messagetopost = String()
    
    var instafbtwitter = NSMutableArray()
    
    var accesstokenofFB = String()
    var accesstokenInstagram = String()
    
    let appdele=AppDelegate()
    
    var facebookLikedUsers = NSMutableArray()
    var PostsLikedAlready = NSMutableArray()
    
    var instagramTokenValid = String()
    
    var dictionaryinstagramusername = NSMutableDictionary()
    
    var twitterhashtagpostornot = NSMutableArray()
    
    var keyboardvisiblebool = false
    
    var idsarray = NSMutableArray()
    var timeofpostarray = NSMutableArray()
    
    //MARK: ViewDidLoad Method
    override func viewDidLoad()
    {
        super.viewDidLoad()
        accesstokenInstagram = UserDefaults.standard.value(forKey: "instagramtoken") as! String
        
        // Do any additional setup after loading the view.
        
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
        if (UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad)
        {
            heightoffooter = 80
        }
        else
        {
            heightoffooter = 70
        }
        
        if (UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad)
        {
            
            hotelnamelabel.font = hotelnamelabel.font.withSize(29)
            systemdatelabel.font = systemdatelabel.font.withSize(20)
            
            postbutton.titleLabel?.font = postbutton.titleLabel?.font.withSize(20)
            
            posttextview.font = posttextview.font!.withSize(21)
            
            backbutton.frame.size = CGSize(width: 60, height: 60)
            
            zumespoticontop.frame.size.width = zumespoticontop.frame.width-10
            
            zumespoticontop.frame.size.height = zumespoticontop.frame.height+6
            
            zumespoticontop.frame.origin.y = zumespoticontop.frame.origin.y-4
            zumespoticontop.frame.origin.x = zumespoticontop.frame.origin.x+7
            
        }
        
        for var i in 0 ..< 20000 {
            self.heightofcellarray.add(60.1)
        }
        
        label.frame = CGRect(x: 14, y: 15, width: ((self.view.frame.width/2)-6-20), height: 15)
        label.textAlignment = NSTextAlignment.natural
        label.layer.cornerRadius=4
        label.textColor=UIColor.blue
        if (UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad)
        {
            label.font = UIFont.systemFont(ofSize: 20)
        }
        else
        {
            label.font = UIFont.systemFont(ofSize: 12)
        }
        
        label.text = "Label"
        label.backgroundColor=UIColor(red: 255/255, green: 55/255, blue: 54/255, alpha: 0.8)
        self.view.addSubview(label)
        label.isHidden = true
        
        // LOAD MORE BUTTON
        
        self.loadmorebutton.center = CGPoint(x: self.view.frame.width/2, y: self.view.frame.height-20)
        self.loadmorebutton.isHidden = true
        
        hotelnamelabel.text=self.restaurantlabelname as String
        self.posttextview.text=self.placeholderstring
        
        backbutton.layer.cornerRadius=3
        postbutton.layer.cornerRadius=3
        posttextview.layer.cornerRadius=3
        
        ActivityIndicator.current().show()
        self.backviewofactivity.isHidden=false
        self.collection_view.backgroundView?.contentMode = UIViewContentMode.scaleAspectFit
        self.collection_view.backgroundView = UIImageView(image: UIImage(named: "gridbackonfeed")!)
        
        setupCollectionView()
        
        extraarray=[100.0,40.0,100.0,60.0,40.0,100.0]
        
        self.api()
        NotificationCenter.default.addObserver(self, selector: #selector(FeedVC.keyboardDidShow), name: NSNotification.Name.UIKeyboardDidShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(FeedVC.keyboardDidHide), name: NSNotification.Name.UIKeyboardDidHide, object: nil)
        
    }
    func api()
    {
        if((facebookuserdict.object(forKey: restaurantlabelname)) != nil)
        {
            let facebookid1 = (facebookuserdict.object(forKey: restaurantlabelname)) as! NSNumber
            let facebookid2 = String(describing: facebookid1)
            self.facebookfeeds(facebookid2)
            
            if((twitteruserdict.object(forKey: restaurantlabelname)) == nil && (instagramiddict.object(forKey: restaurantlabelname)) == nil)
            {
                self.footerhidden=0
                
                heightoffooter=0
                
            }
            else if((twitteruserdict.object(forKey: restaurantlabelname)) != nil)
            {
                self.twitterandinstagram = 0
            }
            else  if((instagramiddict.object(forKey: restaurantlabelname)) != nil)
            {
                self.twitterandinstagram = 1
            }
            else
            {
            }
        }
        else if((twitteruserdict.object(forKey: restaurantlabelname)) != nil)
        {
            let twitteruser1 = twitteruserdict.object(forKey: restaurantlabelname) as! String
            
            if(FHSTwitterEngine.shared().accessToken.key == nil) {
                self.gettwitterposts(twitteruser1)
            } else {
                self.FHSTwitterEnginePosts(twitteruser1)
            }
            
            if((instagramiddict.object(forKey: restaurantlabelname)) != nil)
            {
                self.twitterandinstagram = 1
            }
            else
            {
                self.footerhidden=0
                
                heightoffooter=0
                
            }
            
        }
        else  if((instagramiddict.object(forKey: restaurantlabelname)) != nil)
        {
            if(self.accesstokenInstagram == "") {
                ActivityIndicator.current().hide()
                self.backviewofactivity.isHidden=true
                let alert = UIAlertController(title: "Alert", message: "Please Login with Instagram to See Posts From Instagram", preferredStyle: UIAlertControllerStyle.alert)
                let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
                    
                }
                let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
                    
                    let obj = self.storyboard!.instantiateViewController(withIdentifier: "instagramvc") as! InstagramVC
                    obj.pushFromPostScreen = "Yes"
                    self.navigationController?.pushViewController(obj, animated: true)
                }
                alert.addAction(cancelAction)
                alert.addAction(okAction)
                self.present(alert, animated: true, completion: nil)
                
            } else if(self.instagramTokenValid == "Invalid") {
                ActivityIndicator.current().hide()
                self.backviewofactivity.isHidden=true
                let alert = UIAlertController(title: "Alert", message: "Please Login with Instagram to See Posts From Instagram", preferredStyle: UIAlertControllerStyle.alert)
                let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
                    
                    
                }
                let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
                    
                    let obj = self.storyboard!.instantiateViewController(withIdentifier: "instagramvc") as! InstagramVC
                    obj.pushFromPostScreen = "Yes"
                    self.navigationController?.pushViewController(obj, animated: true)
                }
                alert.addAction(cancelAction)
                alert.addAction(okAction)
                self.present(alert, animated: true, completion: nil)
                
            } else {
                ActivityIndicator.current().show()
                self.backviewofactivity.isHidden=false
                
                let instagramname1 = (instagramiddict.object(forKey: restaurantlabelname)) as! NSNumber
                let instagramname2 = String(describing: instagramname1)
                
                self.json(instagramname2 as NSString)
            }
            
        }
        else
        {
            if((self.dictionaryinstagramusername.object(forKey: self.restaurantlabelname)) != nil)
            {
                self.twitterandinstagram = 3
                
                self.footerhidden=1
            } else {
                ActivityIndicator.current().hide()
                self.backviewofactivity.isHidden=true
            }
        }
        
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
        self.collection_view.autoresizingMask = [UIViewAutoresizing.flexibleWidth, UIViewAutoresizing.flexibleHeight]
        self.collection_view.alwaysBounceVertical = true
        
        // Add the waterfall layout to your collection view
        self.collection_view.collectionViewLayout = layout
        collection_view.register(collection_reusableviewCollectionReusableView.self, forSupplementaryViewOfKind: CHTCollectionElementKindSectionFooter, withReuseIdentifier: FOOTER_IDENTIFIER)
        
        //  layout.footerHeight = 50
        
    }
    
    override func didReceiveMemoryWarning()
    {
        
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        accesstokenInstagram = UserDefaults.standard.value(forKey: "instagramtoken") as! String
    }
    
    //MARK: Collection View Data Source And Delegates
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return self.details.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        
        // get a reference to our storyboard cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CollectionViewCellFeed1
        
        cell.likebutton.tag = indexPath.row
        cell.commentbutton.tag = indexPath.row
        cell.postbutton.tag = indexPath.row
        cell.like_Button.tag = indexPath.row
        cell.comment_Button.tag = indexPath.row
        
        let alreadyliked = self.details[indexPath.row].alreadyliked
        if(alreadyliked == "liked") {
            let btnImage = UIImage(named: "likeredimage")
            cell.likebutton.setBackgroundImage(btnImage, for: UIControlState())
        } else {
            let btnImage = UIImage(named: "likeimage")
            cell.likebutton.setBackgroundImage(btnImage, for: UIControlState())
        }
        
        let posttexts = self.details[indexPath.row].posttext
        if(posttexts == "")
        {
            cell.commenttextview.text = ""
        }
        else
        {
            cell.commenttextview.text = self.details[indexPath.row].posttext
        }
        
        cell.comment_count.text=self.details[indexPath.row].commentcount
        cell.likecount.text=self.details[indexPath.row].likecount
        
        
        let timestampstr = self.details[indexPath.row].timestamp
        let timeInterval1 = Double(timestampstr)
        let myNSDate = NSDate(timeIntervalSince1970: timeInterval1)
        let dayTimePeriodFormatter = DateFormatter()
        dayTimePeriodFormatter.dateFormat = "dd MMM YYYY"
        let datestr = dayTimePeriodFormatter.string(from: myNSDate as Date)
        
        cell.date_label.text=datestr
        
        cell.postcommenttextview.text = "Write Comment"
        cell.setNeedsLayout()
        cell.layoutIfNeeded()
        cell.layoutSubviews()
        
        var num1 = CGFloat.init(0.0)
        
        num1 = (self.view.frame.width/2)-6.0
        
        var heightofImageView = CGFloat.init(0.0)
        
        let imagestring = self.details[indexPath.row].imagestatus
        
        if(imagestring == "yes") {
            print("image \(indexPath.row)")
            heightofImageView = num1
            let image = self.details[indexPath.row].image
            cell.image_view.image = image
        } else {
            heightofImageView = CGFloat.init(0.0)
            print("no image \(indexPath.row)")
        }
        
        cell.image_view.frame = CGRect(x: 0.0, y: 0.0, width: num1, height: heightofImageView)
        cell.view_back.frame.origin = CGPoint(x: 0.0, y: heightofImageView+2.0)
        cell.view_back.frame.size.height = cell.frame.size.height - cell.image_view.frame.size.height
        
        cell.commenttextview.frame.origin = CGPoint(x: 10.0, y: 0.0)
        cell.commenttextview.frame.size.width = cell.frame.width-20.0
        cell.commenttextview.frame.size.height = self.details[indexPath.row].posttextviewheight
        cell.date_label.frame.origin = CGPoint(x: 10.0, y: self.details[indexPath.row].posttextviewheight+2.0)
        
        cell.commenttextview.contentOffset.y=0.0
        
        if (UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad)
        {
            cell.date_label.frame.size.height = 22.0
            cell.date_label.font = cell.date_label.font.withSize(19.0)
            
            cell.likeimage.frame.origin.x = 10.0
            cell.likeimage.frame.origin.y = cell.date_label.frame.origin.y+23.0
            cell.likeimage.frame.size = CGSize(width: 19.0, height: 22.0)
            
            cell.likecount.frame.origin.x = 45.0
            cell.likecount.frame.origin.y = cell.date_label.frame.origin.y+23.0
            cell.likecount.frame.size.height = 22.0
            cell.likecount.font = cell.likecount.font.withSize(19.0)
            
            cell.commentimage.frame.origin.y = cell.date_label.frame.origin.y + 23.0
            cell.commentimage.frame.size = CGSize(width: 19.0, height: 23.0)
            cell.commentimage.frame.origin.x = cell.likecount.frame.origin.x + cell.likecount.frame.width + 10.0
            
            cell.comment_count.frame.origin.y = cell.date_label.frame.origin.y+23.0
            cell.comment_count.frame.size.height = 22.0
            cell.comment_count.frame.origin.x = cell.commentimage.frame.origin.x + cell.commentimage.frame.size.width + 10.0
            cell.comment_count.font = cell.comment_count.font.withSize(19.0)
        }
        else
        {
            cell.date_label.frame.size.height = 15.0
            cell.likeimage.frame.origin.y = cell.date_label.frame.origin.y+16.0
            cell.commentimage.frame.origin.y = cell.date_label.frame.origin.y+16.0
            cell.likeimage.frame.size = CGSize(width: 14.0, height: 16.0)
            
            cell.commentimage.frame.size = CGSize(width: 14.0, height: 16.0)
            cell.comment_count.frame.origin.y = cell.date_label.frame.origin.y+16.0
            cell.likecount.frame.origin.y = cell.date_label.frame.origin.y+16.0
            cell.comment_count.frame.size.height = 15.0
            cell.likecount.frame.size.height = 15.0
        }
        
        if (UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad)
        {
            cell.commenttextview.font = cell.commenttextview.font?.withSize(20.0)
            cell.postcommenttextview.font = cell.postcommenttextview.font?.withSize(20.0)
        }
        
        if(indexPath.row == indexofselectedrow)
        {
            cell.postcommenttextview.frame.origin.x = cell.likeimage.frame.origin.x
            cell.postcommenttextview.frame.origin.y = cell.likeimage.frame.origin.y + cell.likeimage.frame.height + 1.0
            cell.postcommenttextview.frame.size.height = 40.0
            cell.postbutton.frame.origin.x = cell.postcommenttextview.frame.origin.x + cell.postcommenttextview.frame.size.width + 2.0
            cell.postbutton.frame.origin.y = cell.postcommenttextview.frame.origin.y + 12.0
            cell.postbutton.frame.size.height = 20.0
        }
        else
        {
            cell.postcommenttextview.frame.origin.x = cell.likeimage.frame.origin.x
            cell.postcommenttextview.frame.origin.y = cell.likeimage.frame.origin.y + cell.likeimage.frame.height + 1.0
            cell.postcommenttextview.frame.size.height = 0.0
            cell.postbutton.frame.origin.x = cell.postcommenttextview.frame.origin.x + cell.postcommenttextview.frame.size.width + 2.0
            cell.postbutton.frame.origin.y = cell.postcommenttextview.frame.origin.y
            cell.postbutton.frame.size.height = 0.0
        }
        
        cell.likebutton.frame = cell.likeimage.frame
        cell.commentbutton.frame = cell.commentimage.frame
        
        cell.like_Button.frame.origin = cell.likebutton.frame.origin
        cell.comment_Button.frame.origin = cell.commentbutton.frame.origin
        cell.like_Button.frame.size.height = 20.0
        cell.comment_Button.frame.size.height = 20.0
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize
    {
        
        for i in 0 ..< self.details.count
        {
            var xyz = CGFloat()
            
            label.text=self.details[i].posttext
            let labeltext=self.details[i].posttext
            
            if (UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad)
            {
                if(labeltext.characters.count>100)
                {
                    xyz = 102.0
                }
                else
                {
                    xyz = self.getLabelHeight(label)+20.0
                }
                
            }
            else
            {
                if(labeltext.characters.count>100)
                {
                    xyz = 65.0
                }
                else
                {
                    xyz = self.getLabelHeight(label)+5.0
                }
            }
            
            self.details[i].posttextviewheight=CGFloat(xyz)
        }
        
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
            height1 = self.details[indexPath.row].posttextviewheight+width3+60.0
        }
        else
        {
            if(indexPath.row == indexofselectedrow)
            {
                let imgstatus = self.details[indexPath.row].imagestatus
                if(imgstatus == "yes") {
                    height1 = self.details[indexPath.row].posttextviewheight+width3+80.0
                } else {
                    height1 = self.details[indexPath.row].posttextviewheight+80.0
                }
            }
            else
            {
                let imgstatus = self.details[indexPath.row].imagestatus
                if(imgstatus == "yes") {
                    height1 = self.details[indexPath.row].posttextviewheight+width3+42.0
                } else {
                    height1 = self.details[indexPath.row].posttextviewheight+42.0
                }
            }
        }
        
        //heightofcellarray.replaceObject(at: indexPath.row, with: height1)
        self.details[indexPath.row].cellheight = height1
        
        let imagesize = CGSize(width: width3, height: height1)
        
        return imagesize
    }
    
    //MARK: Back and Post Action
    
    @IBAction func backbutton(_ sender: AnyObject)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func postaction(_ sender: UIButton)
    {
    }
    
    //MARK: Text View Delegates
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool
    {
        if(textView.text==self.placeholderstring || textView.text == "")
        {
            if ((textView.superview?.isKind(of: CollectionViewCellFeed1.self)) != nil)
            {
                let attri = self.collection_view.layoutAttributesForItem(at: IndexPath.init(item: self.indexofselectedrow, section: 0))! as UICollectionViewLayoutAttributes
                
                let cellRect = attri.frame
                let cellFrameInSuperview = self.collection_view.convert(cellRect, to: self.collection_view.superview)
                
                self.collection_view.contentOffset = CGPoint.init(x: self.collection_view.contentOffset.x, y: cellRect.origin.y+20)
            }
            
            self.posttextview.text=""
            textView.text = ""
            return true
            
        } else {
            if ((textView.superview?.isKind(of: CollectionViewCellFeed1.self)) != nil)
            {
                
                let attri = self.collection_view.layoutAttributesForItem(at: IndexPath.init(item: self.indexofselectedrow, section: 0))! as UICollectionViewLayoutAttributes
                
                let cellRect = attri.frame
                let cellFrameInSuperview = self.collection_view.convert(cellRect, to: self.collection_view.superview)
                
                self.collection_view.contentOffset = CGPoint.init(x: self.collection_view.contentOffset.x, y: cellRect.origin.y+cellFrameInSuperview.height)
            }
        }
        return true
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool
    {
        if(text==("\n"))
        {
            if(textView.text=="")
            {
                textView.text=self.placeholderstring
            }
            else
            {
                let searchStr = (textView.text as NSString).replacingCharacters(in: range, with: text)
                self.messagetopost = searchStr
            }
            let arraycount = self.imagearray3.count-1
            if(indexofselectedrow == arraycount || indexofselectedrow == arraycount-1 || indexofselectedrow == arraycount-2 || indexofselectedrow == arraycount-3) {
                self.collection_view.scrollToItem(at: (IndexPath.init(item: self.indexofselectedrow, section: 0)), at: UICollectionViewScrollPosition.bottom, animated: true)
            }
            textView.resignFirstResponder()
            return false
        }
        else
        {
            let searchStr = (textView.text as NSString).replacingCharacters(in: range, with: text)
            self.messagetopost = searchStr
        }
        
        return true
        
    }
    func textViewDidEndEditing(_ textView: UITextView)
    {
        if(textView.text=="")
        {
            textView.text=self.placeholderstring
        }
    }
    func keyboardDidShow() {
        keyboardvisiblebool = true
    }
    
    func keyboardDidHide() {
        if(keyboardvisiblebool == true){
            keyboardvisiblebool = false
            self.view.endEditing(true)
        }
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView)
    {
        if(scrollView.isKind(of: UITextView.self))
        {
            
        } else {
            
            if(keyboardvisiblebool == true) {
                self.view.endEditing(true)
            }
            
            let indexoflastrow = self.details.count-1
            let cellheight = self.details[indexoflastrow].cellheight
            
            if (self.collection_view.contentOffset.y >= self.collection_view.contentSize.height - cellheight - self.view.frame.size.height)
            {
                
                if(footerhidden != 0) {
                    if(self.collection_view.contentSize.height - cellheight - self.view.frame.size.height > 0) {
                        self.collection_view.contentOffset = CGPoint(x: self.collection_view.contentOffset.x, y: self.collection_view.contentSize.height - cellheight - self.view.frame.size.height)
                    }
                    
                    if(self.loadmorebutton.isHidden == true) {
                        self.loadmorebutton.isHidden = false
                    }
                }
                
            }
        }
    }
    
    //MARK: Colection View Flow Layout
    
    func collectionView (_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                         heightForFooterInSection section: NSInteger) -> CGFloat
    {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView
    {
        var reusableView: UICollectionReusableView? = nil
        if (kind == CHTCollectionElementKindSectionHeader) {
            reusableView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: HEADER_IDENTIFIER, for: indexPath)
        }
        else if (kind == CHTCollectionElementKindSectionFooter) {
            reusableView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: FOOTER_IDENTIFIER, for: indexPath) as! collection_reusableviewCollectionReusableView
            
            
            if (UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad)
            {
                let centreofview = self.view.frame.size.width / 2
                
                let xoflabel = centreofview - 55
                
                let label = UILabel(frame: CGRect(x: xoflabel, y: 25, width: 110, height: 30))
                label.textAlignment = NSTextAlignment.center
                label.layer.cornerRadius=3
                label.layer.masksToBounds=true
                label.text = "Load More"
                label.textColor=UIColor.white
                label.font = label.font.withSize(16)
                label.backgroundColor=UIColor(red: 255/255, green: 55/255, blue: 54/255, alpha: 0.8)
                reusableView!.addSubview(label)
                
                let tap = UITapGestureRecognizer(target: self, action: #selector(FeedVC.tapFunction(_:)))
                label.addGestureRecognizer(tap)
                
                label.isUserInteractionEnabled=true
                
            }
            else
            {
                let centreofview = self.view.frame.size.width / 2
                
                let xoflabel = centreofview - 47
                
                let label = UILabel(frame: CGRect(x: xoflabel, y: 22, width: 94, height: 25))
                label.textAlignment = NSTextAlignment.center
                label.layer.cornerRadius=3
                label.layer.masksToBounds=true
                label.text = "Load More"
                label.textColor=UIColor.white
                label.font = label.font.withSize(13)
                label.backgroundColor=UIColor(red: 255/255, green: 55/255, blue: 54/255, alpha: 0.8)
                reusableView!.addSubview(label)
                
                let tap = UITapGestureRecognizer(target: self, action: #selector(FeedVC.tapFunction(_:)))
                label.addGestureRecognizer(tap)
                
                label.isUserInteractionEnabled=true
            }
            
            if(footerhidden==0)
            {
                reusableView!.isHidden=true
            }
            else
            {
                reusableView!.isHidden=false
            }
            
        }
        
        return reusableView!
    }
    
    
    @IBAction func LoadMoreAction(_ sender: UIButton) {
        
        for y in 10 ..< self.imagearray1.count
        {
            self.imagearray3.add(self.imagearray1[y])
        }
        self.collection_view.reloadData()
        
        self.footerhidden=0
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
    
    //MARK: Load More Action
    
    @IBAction func loadMoreButton(_ sender: UIButton) {
        
        let tapgesture = UITapGestureRecognizer()
        self.tapFunction(tapgesture)
    }
    
    func tapFunction(_ sender:UITapGestureRecognizer)
    {
        self.view.endEditing(true)
        if(self.twitterandinstagram == 0)
        {
            if((twitteruserdict.object(forKey: restaurantlabelname)) != nil)
            {
                
                ActivityIndicator.current().show()
                self.backviewofactivity.isHidden=false
                
                let twittername1 = (twitteruserdict.object(forKey: restaurantlabelname)) as! String
                if(FHSTwitterEngine.shared().accessToken.key == nil) {
                    self.gettwitterposts(twittername1)
                } else {
                    self.FHSTwitterEnginePosts(twittername1)
                }
                
            }
            
        } else {
            
            if((instagramiddict.object(forKey: restaurantlabelname)) != nil)
            {
                if(self.accesstokenInstagram == "") {
                    
                    let alert = UIAlertController(title: "Alert", message: "Please Login with Instagram to See Posts From Instagram", preferredStyle: UIAlertControllerStyle.alert)
                    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
                    }
                    let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
                        let obj = self.storyboard!.instantiateViewController(withIdentifier: "instagramvc") as! InstagramVC
                        obj.pushFromPostScreen = "Yes"
                        self.navigationController?.pushViewController(obj, animated: true)
                        
                    }
                    alert.addAction(cancelAction)
                    alert.addAction(okAction)
                    self.present(alert, animated: true, completion: nil)
                    
                } else if(self.instagramTokenValid == "Invalid") {
                    
                    let alert = UIAlertController(title: "Alert", message: "Please Login with Instagram to See Posts From Instagram", preferredStyle: UIAlertControllerStyle.alert)
                    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
                        
                    }
                    let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
                        
                        let obj = self.storyboard!.instantiateViewController(withIdentifier: "instagramvc") as! InstagramVC
                        obj.pushFromPostScreen = "Yes"
                        self.navigationController?.pushViewController(obj, animated: true)
                    }
                    alert.addAction(cancelAction)
                    alert.addAction(okAction)
                    self.present(alert, animated: true, completion: nil)
                    
                } else {
                    
                    ActivityIndicator.current().show()
                    self.backviewofactivity.isHidden=false
                    
                    let instagramname1 = (instagramiddict.object(forKey: restaurantlabelname)) as! NSNumber
                    let instagramname2 = String(describing: instagramname1)
                    
                    if(self.nextUrl == "")
                    {
                        self.json(instagramname2 as NSString)
                    } else {
                        self.instagramPostsByHashtags()
                    }
                    
                }
            } else {
                
                if((dictionaryinstagramusername.object(forKey: restaurantlabelname)) != nil)
                {
                    if(self.accesstokenInstagram == "") {
                        
                        let alert = UIAlertController(title: "Alert", message: "Please Login with Instagram to See Posts From Instagram", preferredStyle: UIAlertControllerStyle.alert)
                        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
                        }
                        let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
                            let obj = self.storyboard!.instantiateViewController(withIdentifier: "instagramvc") as! InstagramVC
                            obj.pushFromPostScreen = "Yes"
                            self.navigationController?.pushViewController(obj, animated: true)
                            
                        }
                        alert.addAction(cancelAction)
                        alert.addAction(okAction)
                        self.present(alert, animated: true, completion: nil)
                        
                    } else if(self.instagramTokenValid == "Invalid") {
                        
                        let alert = UIAlertController(title: "Alert", message: "Please Login with Instagram to See Posts From Instagram", preferredStyle: UIAlertControllerStyle.alert)
                        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
                            
                        }
                        let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
                            
                            let obj = self.storyboard!.instantiateViewController(withIdentifier: "instagramvc") as! InstagramVC
                            obj.pushFromPostScreen = "Yes"
                            self.navigationController?.pushViewController(obj, animated: true)
                        }
                        alert.addAction(cancelAction)
                        alert.addAction(okAction)
                        self.present(alert, animated: true, completion: nil)
                        
                    } else if(self.twitterandinstagram == 3)
                    {
                        ActivityIndicator.current().show()
                        self.backviewofactivity.isHidden=false
                        
                        self.instagramPostsByHashtags()
                    } else if(self.twitterandinstagram == 2)
                    {
                        ActivityIndicator.current().show()
                        self.backviewofactivity.isHidden=false
                        
                        self.instagramPostsByHashtags()
                    }
                }
                
            }
        }
    }
    
    //MARK: Instagram, facebook and Twitter Action
    
    func json(_ userid:NSString)
    {
        
        let jsonUrlPath = "https://api.instagram.com/v1/users/\(userid)/media/recent/?access_token=\(self.accesstokenInstagram)"
        let url:URL = URL(string: jsonUrlPath)!
        
        let session  = URLSession.shared
        let task = session.dataTask(with: url, completionHandler: {data,response,error -> Void in
            if error != nil
            {
                //print(error!.localizedDescription)
            }
            else {
                
                var err:NSError?
                
                do
                {
                    
                    let result = try JSONSerialization.jsonObject(with: data! , options: JSONSerialization.ReadingOptions.mutableContainers) as! NSMutableDictionary
                    
                    let resultarray = (result.value(forKey: "data") as! NSArray)
                    var countresult = resultarray.count
                    
                    if(countresult>20)
                    {
                        countresult=20
                    }
                    
                    if(countresult != 0)
                    {
                        
                        for var i in 0..<countresult
                        {
                            var posttext = ""
                            var posttime = Int()
                            var postcommentcount = ""
                            var postlikecount = ""
                            var postimage = UIImage()
                            var socialmediatype = ""
                            var alreadyliked = ""
                            var postid = ""
                            
                            if (UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad)
                            {
                                let imageurl = (((resultarray[i] as AnyObject).value(forKey: "images") as AnyObject).value(forKey: "standard_resolution") as AnyObject).value(forKey: "url") as! String
                                let url = URL(string: imageurl)
                                let img=try? Data(contentsOf: url!)
                                postimage = UIImage(data: img!)!
                            }
                            else
                            {
                                
                                let imageurl = (((resultarray[i] as AnyObject).value(forKey: "images") as AnyObject).value(forKey: "low_resolution") as AnyObject).value(forKey: "url") as! String
                                
                                let url = URL(string: imageurl)
                                let img=try? Data(contentsOf: url!)
                                postimage = UIImage(data: img!)!
                            }
                            
                            let commentcount1 = ((resultarray[i] as AnyObject).value(forKey: "comments") as AnyObject).value(forKey: "count")
                            postcommentcount = String(describing: commentcount1!)
                            
                            let likecount1 = ((resultarray[i] as AnyObject).value(forKey: "likes") as AnyObject).value(forKey: "count")
                            postlikecount = String(describing: likecount1!)
                            
                            let posttext1 = ((resultarray[i] as AnyObject).value(forKey: "caption") as AnyObject).value(forKey: "text")
                            let posttext2 = String(describing: posttext1!)
                            if(posttext2 != "<null>")
                            {
                                posttext = String(describing: posttext1!)
                            } else {
                                posttext = ""
                            }
                            
                            let postid1 = (resultarray[i] as AnyObject).value(forKey: "id")
                            let postid2 = String(describing: postid1!)
                            postid = postid2
                            
                            let posttime1 = ((resultarray[i] as AnyObject).value(forKey: "caption") as AnyObject).value(forKey: "created_time")
                            if((posttime1 as AnyObject).isKind(of: NSNull.self))
                            {
                                posttime = 1496640256
                            } else {
                                let posttime2  = posttime1 as! String
                                posttime = Int(posttime2)!
                                
                            }
                            
                            let alredyliked1 = (resultarray[i] as AnyObject).value(forKey: "user_has_liked") as! Bool
                            
                            if(alredyliked1 == true)
                            {
                                alreadyliked = "liked"
                            } else {
                                alreadyliked = ""
                            }
                            
                            socialmediatype = "instagram"
                            
                            let postdetails = compareTimestamp.init(posttext: posttext, likecount: postlikecount, commentcount: postcommentcount, image: postimage, timestamp: posttime, postid: postid, alreadyliked: alreadyliked, socialmediatype: socialmediatype, posttextviewheight: 50.0, cellheight: 100.0,hashtagpost: "",imagestatus: "yes")
                            self.details.append(postdetails)
                            self.posttextarray.add(posttext)
                            self.postidarray.add(postid)
                        }
                    }
                    
                    self.instagramPostsByHashtags()
                    
                } catch _
                {
                    //print("error")
                }
                if err != nil
                {
                    //print("Json Error\(err!.localizedDescription)")
                }
            }
            DispatchQueue.main.async(execute: {
                
                
            })
        })
        
        task.resume()
        
    }
    
    func instagramPostsByHashtags() {
        
        var instausername = String()
        if((dictionaryinstagramusername.object(forKey: restaurantlabelname)) != nil)
        {
            instausername = (dictionaryinstagramusername.object(forKey: restaurantlabelname)) as! String
        }
        
        instausername = instausername.replacingOccurrences(of: "@", with: "")
        var urlString = ""
        if (nextUrl == ""){
            urlString = "https://api.instagram.com/v1/tags/\(instausername)/media/recent?access_token=\(self.accesstokenInstagram)"
        }
        else
        {
            urlString = nextUrl
        }
        
        let requestUrl = URL(string:urlString)
        var request = URLRequest(url:requestUrl!)
        request.httpMethod = "GET"
        
        let session = URLSession.shared
        
        let task = session.dataTask(with: requestUrl!, completionHandler: {data,response,error -> Void in
            
            do
            {
                let result = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSMutableDictionary
                
                
                let resultarray = (result.value(forKey: "data") as! NSArray)
                var countresult = resultarray.count
                
                if(countresult>20)
                {
                    countresult=20
                }
                
                if(countresult != 0)
                {
                    let dict = result.value(forKey: "pagination") as! NSDictionary
                    if((dict.object(forKey: "next_url")) != nil)
                    {
                        self.nextUrl = dict .value(forKey: "next_url") as! String
                    } else {
                        self.nextUrl = ""
                    }
                    
                    for var i in 0..<countresult
                    {
                        var posttext = ""
                        var posttime = Int()
                        var postcommentcount = ""
                        var postlikecount = ""
                        var postimage = UIImage()
                        var socialmediatype = ""
                        var alreadyliked = ""
                        var postid = ""
                        
                        let postid1 = (resultarray[i] as AnyObject).value(forKey: "id")
                        let postid2 = String(describing: postid1!)
                        
                        if(self.postidarray.contains(postid2)) {
                            
                        } else {
                            
                            
                            if (UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad)
                            {
                                let imageurl = (((resultarray[i] as AnyObject).value(forKey: "images") as AnyObject).value(forKey: "standard_resolution") as AnyObject).value(forKey: "url") as! String
                                let url = URL(string: imageurl)
                                let img=try? Data(contentsOf: url!)
                                postimage = UIImage(data: img!)!
                            }
                            else
                            {
                                
                                let imageurl = (((resultarray[i] as AnyObject).value(forKey: "images") as AnyObject).value(forKey: "low_resolution") as AnyObject).value(forKey: "url") as! String
                                
                                let url = URL(string: imageurl)
                                let img=try? Data(contentsOf: url!)
                                postimage = UIImage(data: img!)!
                            }
                            
                            let commentcount1 = ((resultarray[i] as AnyObject).value(forKey: "comments") as AnyObject).value(forKey: "count")
                            postcommentcount = String(describing: commentcount1!)
                            
                            let likecount1 = ((resultarray[i] as AnyObject).value(forKey: "likes") as AnyObject).value(forKey: "count")
                            postlikecount = String(describing: likecount1!)
                            
                            let posttext1 = ((resultarray[i] as AnyObject).value(forKey: "caption") as AnyObject).value(forKey: "text")
                            let posttext2 = String(describing: posttext1!)
                            if(posttext2 != "<null>")
                            {
                                posttext = String(describing: posttext1!)
                            } else {
                                posttext = ""
                            }
                            
                            let postid1 = (resultarray[i] as AnyObject).value(forKey: "id")
                            let postid2 = String(describing: postid1!)
                            postid = postid2
                            
                            let posttime1 = ((resultarray[i] as AnyObject).value(forKey: "caption") as AnyObject).value(forKey: "created_time")
                            if((posttime1 as AnyObject).isKind(of: NSNull.self))
                            {
                                posttime = 1496640256
                            } else {
                                let posttime2  = posttime1 as! String
                                posttime = Int(posttime2)!
                                
                            }
                            
                            let alredyliked1 = (resultarray[i] as AnyObject).value(forKey: "user_has_liked") as! Bool
                            
                            if(alredyliked1 == true)
                            {
                                alreadyliked = "liked"
                            } else {
                                alreadyliked = ""
                            }
                            
                            socialmediatype = "instagram"
                            
                            let postdetails = compareTimestamp.init(posttext: posttext, likecount: postlikecount, commentcount: postcommentcount, image: postimage, timestamp: posttime, postid: postid, alreadyliked: alreadyliked, socialmediatype: socialmediatype, posttextviewheight: 50.0, cellheight: 100.0,hashtagpost: "",imagestatus: "yes")
                            self.details.append(postdetails)
                            self.posttextarray.add(posttext)
                            self.postidarray.add(postid)
                        }
                    }
                }
                
                DispatchQueue.main.sync(execute: {
                    /* Do UI work here */
                    
                    self.details.sort{ $0.timestamp > $1.timestamp }
                    
                    ActivityIndicator.current().hide()
                    self.backviewofactivity.isHidden=true
                    self.heightoffooter = 0
                    self.loadmorebutton.isHidden = true
                    
                    if(self.nextUrl == "")
                    {
                        self.footerhidden=0
                    } else {
                        self.twitterandinstagram = 2
                        self.footerhidden=1
                    }
                    
                    self.collection_view.reloadData()
                });
            }
            catch let error as Error
            {
                //print(error)
            }
        })
        task.resume()
    }
    
    func gettwitterposts(_ twitterusername:String)
    {
        
        // TWITTER TOKEN BY AUTHENTICATION, BECAUSE TWITTER DO NOT GIVE ANY INFORMATION WITHOUT AUTHENTICATION
        
        let obj = TwitterBearerTokenClass()
        let fhfh = obj.bearerToken()
        let tokenstring = String(describing: fhfh!)
        UserDefaults.standard.setValue(tokenstring, forKey: "TwitterBearerTokenClass")
        
        let urlString = "https://api.twitter.com/1.1/statuses/user_timeline.json?screen_name=\(twitterusername)&count=10"
        let requestUrl = URL.init(string: urlString)
        var request = URLRequest(url:requestUrl!)
        request.httpMethod = "GET"
        request.setValue("Bearer \(tokenstring)", forHTTPHeaderField: "Authorization")
        let task = URLSession.shared.dataTask(with: request, completionHandler: {data,response,error -> Void in
            
            do
            {
                let result = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSMutableArray
                
                if(result.count != 0)
                {
                    for var i in 0..<result.count
                    {
                        var posttext = ""
                        var posttime = Int()
                        var postcommentcount = ""
                        var postlikecount = ""
                        var postimage = UIImage()
                        var socialmediatype = ""
                        var alreadyliked = ""
                        var postid = ""
                        var imagestatusstring = ""
                        
                        self.twitterhashtagpostornot.add("")
                        
                        let idofpost = (result[i] as AnyObject).value(forKey: "id")!
                        postid=String(describing: idofpost)
                        
                        let textofpost = (result[i] as AnyObject).value(forKey: "text")!
                        posttext = String(describing: textofpost)
                        
                        let likecount = (result[i] as AnyObject).value(forKey: "favorite_count")!
                        postlikecount=String(describing: likecount)
                        
                        let commentcount = (result[i] as AnyObject).value(forKey: "retweet_count")!
                        postcommentcount = String(describing: commentcount)
                        
                        if(((((result[i] as AnyObject).value(forKey: "extended_entities") as AnyObject).value(forKey: "media") as AnyObject).value(forKey: "media_url_https") as AnyObject).isKind(of: NSNull.self))
                        {
                            
                            postimage=UIImage.init(named: "NoImage")!
                            imagestatusstring = "no"
                        }
                        else
                        {
                            
                            let imageurlstr1 = (((((result[i] as AnyObject).value(forKey: "extended_entities") as AnyObject).value(forKey: "media") as AnyObject).value(forKey: "media_url_https"))! as! NSArray)[0]
                            let imageurlstr2 = String(describing: imageurlstr1)
                            
                            if(imageurlstr2 == "")
                            {
                                postimage=UIImage.init(named: "NoImage")!
                                imagestatusstring = "no"
                            } else {
                                let url = URL(string: imageurlstr2)
                                let img=try? Data(contentsOf: url!)
                                postimage = UIImage(data: img!)!
                                imagestatusstring = "yes"
                            }
                        }
                        
                        if((result[i] as AnyObject).value(forKey: "created_at") != nil)
                        {
                            let dateoffeed = (result[i] as AnyObject).value(forKey: "created_at") as! String
                            let df1 = DateFormatter()
                            df1.dateFormat = "EEE MMM dd HH:mm:ss VVVV yyyy"
                            let convertedDate1 = df1.date(from: dateoffeed)!
                            let timeInterval = convertedDate1.timeIntervalSince1970
                            
                            let myInt = Int(timeInterval)
                            posttime = myInt
                        }
                        else
                        {
                            let dateoffeed = "Tue May 02 04:00:02 +0000 2017"
                            let df1 = DateFormatter()
                            df1.dateFormat = "EEE MMM dd HH:mm:ss VVVV yyyy"
                            let convertedDate1 = df1.date(from: dateoffeed)!
                            let timeInterval = convertedDate1.timeIntervalSince1970
                            
                            let myInt = Int(timeInterval)
                            posttime = myInt
                        }
                        socialmediatype = "twitter"
                        alreadyliked = ""
                        let postdetails = compareTimestamp.init(posttext: posttext, likecount: postlikecount, commentcount: postcommentcount, image: postimage, timestamp: posttime, postid: postid, alreadyliked: alreadyliked, socialmediatype: socialmediatype, posttextviewheight: 50.0, cellheight: 100.0,hashtagpost: "",imagestatus: imagestatusstring)
                        self.details.append(postdetails)
                        self.posttextarray.add(posttext)
                        self.postidarray.add(postid)
                    }
                    
                }
                
                self.twitterPostsByHashtag(twitterusername)
                
                DispatchQueue.main.sync(execute: {
                    /* Do UI work here */
                    
                });
            }
                
            catch let error as Error
            {
                //print(error)
            }
            
            if (error != nil)
            {
                DispatchQueue.main.async(execute: {
                    
                    var alert = UIAlertView()
                    alert = UIAlertView(title:"Alert", message: "Data not found", delegate: self, cancelButtonTitle:"OK")
                    alert.show()
                })
            }
            else
            {
                
            }
            
        })
        task.resume()
    }
    func FHSEnginePostsafterLoginonLike(_ twitterusername:String)
    {
        
        FHSTwitterEngine.shared().loadAccessToken()
        let result1 = FHSTwitterEngine.shared().getTimelineForUser(twitterusername, isID: false, count: 10) as! NSArray
        
        if(result1.count != 0)
        {
            for var i in 0..<result1.count
            {
                
                let idofpost1 = (result1[i] as AnyObject).value(forKey: "id")!
                let idofpost2 = String(describing: idofpost1)
                
                if(self.postidarray.contains(idofpost2)) {
                    
                    let likedalready = (result1[i] as AnyObject).value(forKey: "favorited")! as! Bool
                    
                    if(likedalready == true) {
                        
                        for var i in 0..<self.details.count
                        {
                            if(self.details[i].postid == idofpost2)
                            {
                                self.details[i].alreadyliked = "liked"
                                break
                            }
                        }
                    } else {
                        
                    }
                } else {
                    
                }
                
                
            }
            
        }
        let array1=UserDefaults.standard.value(forKey: "twitterhashtagposts") as! NSArray
        
        for var j in 0..<array1.count
        {
            for var k in 0..<self.details.count
            {
                let postid1 = array1[j] as! String
                if(self.details[k].postid == postid1)
                {
                    self.details[k].alreadyliked = "liked"
                    break
                }
            }
        }
        
        self.perform(#selector(FeedVC.callm), on: Thread.main, with: nil, waitUntilDone: false)
        
    }
    func FHSTwitterEnginePosts(_ twitterusername:String)
    {
        DispatchQueue.global(priority: DispatchQueue.GlobalQueuePriority.default).async(execute: {() -> Void in
            
            FHSTwitterEngine.shared().loadAccessToken()
            let result = FHSTwitterEngine.shared().getTimelineForUser(twitterusername, isID: false, count: 10) as! NSArray
            
            if(result.count != 0)
            {
                for var i in 0..<result.count
                {
                    //INSTA FB AND TWITR POSTING LIKES AND COMMENTS POSTING DIFFERENCE ARRAY
                    
                    var posttext = ""
                    var posttime = Int()
                    var postcommentcount = ""
                    var postlikecount = ""
                    var postimage = UIImage()
                    var socialmediatype = ""
                    var alreadyliked = ""
                    var postid = ""
                    var imagestatusstring = ""
                    
                    self.twitterhashtagpostornot.add("")
                    
                    let likedalready = (result[i] as AnyObject).value(forKey: "favorited")! as! Bool
                    
                    if(likedalready == true) {
                        alreadyliked = "liked"
                    } else {
                        alreadyliked = ""
                    }
                    
                    let idofpost = (result[i] as AnyObject).value(forKey: "id")!
                    postid=String(describing: idofpost)
                    
                    let textofpost = (result[i] as AnyObject).value(forKey: "text")!
                    posttext = String(describing: textofpost)
                    
                    let likecount = (result[i] as AnyObject).value(forKey: "favorite_count")!
                    postlikecount=String(describing: likecount)
                    
                    let commentcount = (result[i] as AnyObject).value(forKey: "retweet_count")!
                    postcommentcount = String(describing: commentcount)
                    
                    if(((((result[i] as AnyObject).value(forKey: "extended_entities") as AnyObject).value(forKey: "media") as AnyObject).value(forKey: "media_url_https") as AnyObject).isKind(of: NSNull.self))
                    {
                        
                        postimage=UIImage.init(named: "NoImage")!
                        imagestatusstring = "no"
                    }
                    else
                    {
                        
                        let imageurlstr1 = (((((result[i] as AnyObject).value(forKey: "extended_entities") as AnyObject).value(forKey: "media") as AnyObject).value(forKey: "media_url_https"))! as! NSArray)[0]
                        let imageurlstr2 = String(describing: imageurlstr1)
                        
                        if(imageurlstr2 == "")
                        {
                            postimage=UIImage.init(named: "NoImage")!
                            imagestatusstring = "no"
                        } else {
                            let url = URL(string: imageurlstr2)
                            let img=try? Data(contentsOf: url!)
                            postimage = UIImage(data: img!)!
                            imagestatusstring = "yes"
                        }
                    }
                    
                    if((result[i] as AnyObject).value(forKey: "created_at") != nil)
                    {
                        let dateoffeed = (result[i] as AnyObject).value(forKey: "created_at") as! String
                        let df1 = DateFormatter()
                        df1.dateFormat = "EEE MMM dd HH:mm:ss VVVV yyyy"
                        let convertedDate1 = df1.date(from: dateoffeed)!
                        let timeInterval = convertedDate1.timeIntervalSince1970
                        
                        let myInt = Int(timeInterval)
                        posttime = myInt
                    }
                    else
                    {
                        let dateoffeed = "Tue May 02 04:00:08 +0000 2017"
                        let df1 = DateFormatter()
                        df1.dateFormat = "EEE MMM dd HH:mm:ss VVVV yyyy"
                        let convertedDate1 = df1.date(from: dateoffeed)!
                        let timeInterval = convertedDate1.timeIntervalSince1970
                        
                        let myInt = Int(timeInterval)
                        posttime = myInt
                    }
                    socialmediatype = "twitter"
                    let postdetails = compareTimestamp.init(posttext: posttext, likecount: postlikecount, commentcount: postcommentcount, image: postimage, timestamp: posttime, postid: postid, alreadyliked: alreadyliked, socialmediatype: socialmediatype, posttextviewheight: 50.0, cellheight: 100.0,hashtagpost: "",imagestatus: imagestatusstring)
                    self.details.append(postdetails)
                    self.posttextarray.add(posttext)
                    self.postidarray.add(postid)
                    
                    
                }
                
            }
            
            self.twitterPostsByHashtagFromFHST(twitterusername)
            
            DispatchQueue.main.async(execute: {() -> Void in
                // Add code here to update the UI/send notifications based on the
                // results of the background processing
                
            })
        })
        
    }
    func twitterPostsByHashtag(_ username: String) {
        
        let usernameofTwitter = username.replacingOccurrences(of: "@", with: "%23")
        
        let tokenvalue = UserDefaults.standard.value(forKey: "TwitterBearerTokenClass") as! String
        
        let urlString = "https://api.twitter.com/1.1/search/tweets.json?q=\(usernameofTwitter)"
        
        guard let requestUrl = Foundation.URL(string:urlString) else { return }
        var request = URLRequest(url:requestUrl)
        request.httpMethod = "GET"
        request.setValue("Bearer \(tokenvalue)", forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request, completionHandler: {data,response,error -> Void in
            
            do
            {
                
                let result = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSMutableDictionary
                
                if((result.value(forKey: "statuses")! as AnyObject).count != 0)
                {
                    var countofresult = (result.value(forKey: "statuses")! as AnyObject).count as Int
                    
                    if(countofresult > 10) {
                        countofresult=10
                    } else {
                        
                    }
                    
                    for var i in 0..<countofresult
                    {
                        var posttext = ""
                        var posttime = Int()
                        var postcommentcount = ""
                        var postlikecount = ""
                        var postimage = UIImage()
                        var socialmediatype = ""
                        var alreadyliked = ""
                        var postid = ""
                        var imagestatusstring = ""
                        
                        let idofpost1 = ((result.value(forKey: "statuses")! as! NSArray)[i] as AnyObject).value(forKey: "id")!
                        let idofpost2 = String(describing: idofpost1)
                        
                        if(self.postidarray.contains(idofpost2)) {
                            
                        } else {
                            
                            self.twitterhashtagpostornot.add("Yes")
                            
                            let idofpost1 = ((result.value(forKey: "statuses")! as! NSArray)[i] as AnyObject).value(forKey: "id")!
                            postid=String(describing: idofpost1)
                            
                            let textofpost1 = ((result.value(forKey: "statuses")! as! NSArray)[i] as AnyObject).value(forKey: "text")!
                            posttext=String(describing: textofpost1)
                            
                            let commentcount = ((result.value(forKey: "statuses")! as! NSArray)[i] as AnyObject).value(forKey: "retweet_count")!
                            postcommentcount=String(describing: commentcount)
                            
                            let likecount = ((result.value(forKey: "statuses")! as! NSArray)[i] as AnyObject).value(forKey: "favorite_count")!
                            postlikecount=String(describing: likecount)
                            
                            if((((((result.value(forKey: "statuses")! as! NSArray)[i] as AnyObject).value(forKey: "extended_entities") as AnyObject).value(forKey: "media") as AnyObject).value(forKey: "media_url_https") as AnyObject).isKind(of: NSNull.self))
                            {
                                postimage=UIImage.init(named: "NoImage")!
                                imagestatusstring = "no"
                            }
                            else
                            {
                                let imageurl = ((((((result.value(forKey: "statuses")! as! NSArray)[i] as AnyObject).value(forKey: "extended_entities") as AnyObject).value(forKey: "media") as AnyObject).value(forKey: "media_url_https"))! as! NSArray)[0]
                                
                                let imageurlstr = String(describing: imageurl)
                                
                                if(imageurlstr == "")
                                {
                                    postimage=UIImage.init(named: "NoImage")!
                                    imagestatusstring = "no"
                                } else {
                                    let url = URL(string: imageurlstr)
                                    let img=try? Data(contentsOf: url!)
                                    postimage = UIImage(data: img!)!
                                    imagestatusstring = "yes"
                                }
                            }
                            
                            if(((result.value(forKey: "statuses")! as! NSArray)[i] as AnyObject).value(forKey: "created_at") != nil)
                            {
                                
                                if((((result.value(forKey: "statuses")! as! NSArray)[i] as AnyObject).value(forKey: "created_at")! as AnyObject).isKind(of: NSArray.self)){
                                    let dateoffeed1 = ((result.value(forKey: "statuses")! as! NSArray)[i] as AnyObject).value(forKey: "created_at") as! NSArray
                                    let dateoffeed2 = dateoffeed1[0] as! String
                                    
                                    let df1 = DateFormatter()
                                    df1.dateFormat = "EEE MMM dd HH:mm:ss VVVV yyyy"
                                    let convertedDate1 = df1.date(from: dateoffeed2)!
                                    let timeInterval = convertedDate1.timeIntervalSince1970
                                    
                                    let myInt = Int(timeInterval)
                                    posttime = myInt
                                } else {
                                    let dateoffeed = ((result.value(forKey: "statuses")! as! NSArray)[i] as AnyObject).value(forKey: "created_at") as! String
                                    let df1 = DateFormatter()
                                    df1.dateFormat = "EEE MMM dd HH:mm:ss VVVV yyyy"
                                    let convertedDate1 = df1.date(from: dateoffeed)!
                                    let timeInterval = convertedDate1.timeIntervalSince1970
                                    
                                    let myInt = Int(timeInterval)
                                    posttime = myInt
                                }
                                
                            }
                            else
                            {
                                let dateoffeed = "Tue May 02 04:00:04 +0000 2017"
                                let df1 = DateFormatter()
                                df1.dateFormat = "EEE MMM dd HH:mm:ss VVVV yyyy"
                                let convertedDate1 = df1.date(from: dateoffeed)!
                                let timeInterval = convertedDate1.timeIntervalSince1970
                                
                                let myInt = Int(timeInterval)
                                posttime = myInt
                            }
                            socialmediatype = "twitter"
                            alreadyliked = ""
                            let postdetails = compareTimestamp.init(posttext: posttext, likecount: postlikecount, commentcount: postcommentcount, image: postimage, timestamp: posttime, postid: postid, alreadyliked: alreadyliked, socialmediatype: socialmediatype, posttextviewheight: 50.0, cellheight: 100.0,hashtagpost: "yes",imagestatus: imagestatusstring)
                            self.details.append(postdetails)
                            self.posttextarray.add(posttext)
                            self.postidarray.add(postid)
                        }
                        
                        
                    }
                    
                }
                
                self.twitterpostswithtag(username)
                
                DispatchQueue.main.sync(execute: {
                    /* Do UI work here */
                    
                });
            }
                
            catch let error as Error
            {
                //print(error)
            }
            
            
        })
        task.resume()
    }
    
    func twitterPostsByHashtagFromFHST(_ username: String) {
        let usernameofTwitter = username.replacingOccurrences(of: "@", with: "%23")
        DispatchQueue.global(priority: DispatchQueue.GlobalQueuePriority.default).async(execute: {() -> Void in
            
            FHSTwitterEngine.shared().loadAccessToken()
            let result1 = FHSTwitterEngine.shared().searchTweets(withQuery: usernameofTwitter, count: 10, resultType: FHSTwitterEngineResultTypeRecent, unil: nil, sinceID: nil, maxID: nil) as! NSDictionary
            
            let array1=UserDefaults.standard.value(forKey: "twitterhashtagposts") as! NSArray
            
            if((result1.value(forKey: "statuses")! as AnyObject).count != 0)
            {
                var countofresult = (result1.value(forKey: "statuses")! as AnyObject).count as Int
                if(countofresult > 10) {
                    countofresult=10
                } else {
                    
                }
                
                for i in 0 ..< countofresult
                {
                    
                    let idofpost1 = ((result1.value(forKey: "statuses")! as! NSArray)[i] as! NSDictionary).value(forKey: "id")!
                    let idofpost2 = String(describing: idofpost1)
                    
                    if(self.postidarray.contains(idofpost2)) {
                        
                    } else {
                        var posttext = ""
                        var posttime = Int()
                        var postcommentcount = ""
                        var postlikecount = ""
                        var postimage = UIImage()
                        var socialmediatype = ""
                        var alreadyliked = ""
                        var postid = ""
                        var imagestatusstring = ""
                        
                        self.twitterhashtagpostornot.add("")
                        
                        if(array1.contains(idofpost2)){
                            alreadyliked = "liked"
                        } else {
                            alreadyliked = ""
                        }
                        
                        postid=idofpost2
                        
                        let textofpost = ((result1.value(forKey: "statuses")! as! NSArray)[i] as! NSDictionary).value(forKey: "text")!
                        posttext = String(describing: textofpost)
                        
                        let likecount = ((result1.value(forKey: "statuses")! as! NSArray)[i] as! NSDictionary).value(forKey: "favorite_count")!
                        postlikecount=String(describing: likecount)
                        
                        let commentcount = ((result1.value(forKey: "statuses")! as! NSArray)[i] as! NSDictionary).value(forKey: "retweet_count")!
                        postcommentcount = String(describing: commentcount)
                        
                        if((((((result1.value(forKey: "statuses")! as! NSArray)[i] as! NSDictionary).value(forKey: "extended_entities") as AnyObject).value(forKey: "media") as AnyObject).value(forKey: "media_url_https") as AnyObject).isKind(of: NSNull.self))
                        {
                            postimage=UIImage.init(named: "NoImage")!
                            imagestatusstring = "no"
                        }
                        else
                        {
                            
                            let imageurlstr1 = ((((((result1.value(forKey: "statuses")! as! NSArray)[i] as! NSDictionary).value(forKey: "extended_entities") as AnyObject).value(forKey: "media") as AnyObject).value(forKey: "media_url_https"))! as! NSArray)[0]
                            let imageurlstr2 = String(describing: imageurlstr1)
                            
                            if(imageurlstr2 == "")
                            {
                                postimage=UIImage.init(named: "NoImage")!
                                imagestatusstring = "no"
                            } else {
                                let url = URL(string: imageurlstr2)
                                let img=try? Data(contentsOf: url!)
                                postimage = UIImage(data: img!)!
                                imagestatusstring = "yes"
                            }
                        }
                        
                        if(((result1.value(forKey: "statuses")! as! NSArray)[i] as! NSDictionary).value(forKey: "created_at") != nil)
                        {
                            if((((result1.value(forKey: "statuses")! as! NSArray)[i] as! NSDictionary).value(forKey: "created_at")! as AnyObject).isKind(of: NSArray.self)){
                                let dateoffeed1 = ((result1.value(forKey: "statuses")! as! NSArray)[i] as! NSDictionary).value(forKey: "created_at") as! NSArray
                                let dateoffeed2 = dateoffeed1[0] as! String
                                
                                let df1 = DateFormatter()
                                df1.dateFormat = "EEE MMM dd HH:mm:ss VVVV yyyy"
                                let convertedDate1 = df1.date(from: dateoffeed2)!
                                let timeInterval = convertedDate1.timeIntervalSince1970
                                let myInt = Int(timeInterval)
                                posttime = myInt
                                
                            } else {
                                let dateoffeed = ((result1.value(forKey: "statuses")! as! NSArray)[i] as! NSDictionary).value(forKey: "created_at") as! String
                                let df1 = DateFormatter()
                                df1.dateFormat = "EEE MMM dd HH:mm:ss VVVV yyyy"
                                let convertedDate1 = df1.date(from: dateoffeed)!
                                let timeInterval = convertedDate1.timeIntervalSince1970
                                let myInt = Int(timeInterval)
                                posttime = myInt
                            }
                        }
                        else
                        {
                            let dateoffeed = "Tue May 02 04:00:10 +0000 2017"
                            let df1 = DateFormatter()
                            df1.dateFormat = "EEE MMM dd HH:mm:ss VVVV yyyy"
                            let convertedDate1 = df1.date(from: dateoffeed)!
                            let timeInterval = convertedDate1.timeIntervalSince1970
                            
                            let myInt = Int(timeInterval)
                            posttime = myInt
                        }
                        socialmediatype = "twitter"
                        let postdetails = compareTimestamp.init(posttext: posttext, likecount: postlikecount, commentcount: postcommentcount, image: postimage, timestamp: posttime, postid: postid, alreadyliked: alreadyliked, socialmediatype: socialmediatype, posttextviewheight: 50.0, cellheight: 100.0,hashtagpost: "yes",imagestatus: imagestatusstring)
                        self.details.append(postdetails)
                        self.posttextarray.add(posttext)
                        self.postidarray.add(postid)
                        
                    }
                }
                
            }
            
            self.twitterpostswithtagFHSEngine(username)
            
            DispatchQueue.main.async(execute: {() -> Void in
                // Add code here to update the UI/send notifications based on the
                // results of the background processing
            })
        })
    }
    
    func twitterpostswithtag(_ username: String) {
        
        let tokenvalue = UserDefaults.standard.value(forKey: "TwitterBearerTokenClass") as! String
        
        let urlString = "https://api.twitter.com/1.1/search/tweets.json?q=\(username)"
        
        guard let requestUrl = Foundation.URL(string:urlString) else { return }
        var request = URLRequest(url:requestUrl)
        request.httpMethod = "GET"
        request.setValue("Bearer \(tokenvalue)", forHTTPHeaderField: "Authorization")
        
        let session = URLSession.shared
        
        let task = session.dataTask(with: request, completionHandler: {data,response,error -> Void in
            
            do
            {
                
                let result = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSMutableDictionary
                
                if((result.value(forKey: "statuses")! as AnyObject).count != 0)
                {
                    var countofresult = (result.value(forKey: "statuses")! as AnyObject).count as Int
                    if(countofresult > 10) {
                        countofresult=10
                    } else {
                        
                    }
                    
                    for var i in 0..<countofresult
                    {
                        var posttext = ""
                        var posttime = Int()
                        var postcommentcount = ""
                        var postlikecount = ""
                        var postimage = UIImage()
                        var socialmediatype = ""
                        var alreadyliked = ""
                        var postid = ""
                        var imagestatusstring = ""
                        
                        let idofpost1 = ((result.value(forKey: "statuses")! as! NSArray)[i] as! NSDictionary).value(forKey: "id")!
                        let idofpost2 = String(describing: idofpost1)
                        
                        if(self.postidarray.contains(idofpost2)) {
                            
                        } else {
                            self.twitterhashtagpostornot.add("Yes")
                            
                            let idpost1 = ((result.value(forKey: "statuses")! as! NSArray)[i] as! NSDictionary).value(forKey: "id")!
                            postid = String(describing: idpost1)
                            
                            let posttext1 = ((result.value(forKey: "statuses")! as! NSArray)[i] as! NSDictionary).value(forKey: "text")!
                            posttext = String(describing: posttext1)
                            print(posttext)
                            
                            let postcommentcount1 = ((result.value(forKey: "statuses")! as! NSArray)[i] as! NSDictionary).value(forKey: "retweet_count")!
                            postcommentcount = String(describing: postcommentcount1)
                            
                            let postlikecount1 = ((result.value(forKey: "statuses")! as! NSArray)[i] as! NSDictionary).value(forKey: "favorite_count")!
                            postlikecount = String(describing: postlikecount1)
                            print(postlikecount)
                            
                            if((((((result.value(forKey: "statuses")! as! NSArray)[i] as! NSDictionary).value(forKey: "extended_entities") as AnyObject).value(forKey: "media") as AnyObject).value(forKey: "media_url_https") as AnyObject).isKind(of: NSNull.self))
                            {
                                postimage=UIImage.init(named: "NoImage")!
                                imagestatusstring = "no"
                            }
                            else
                            {
                                let imageurl = ((((((result.value(forKey: "statuses")! as! NSArray)[i] as! NSDictionary).value(forKey: "extended_entities") as AnyObject).value(forKey: "media") as AnyObject).value(forKey: "media_url_https"))! as! NSArray)[0]
                                let imageurlstr = String(describing: imageurl)
                                if(imageurlstr == "")
                                {
                                    postimage=UIImage.init(named: "NoImage")!
                                    imagestatusstring = "no"
                                } else {
                                    let url = URL(string: imageurlstr)
                                    let img=try? Data(contentsOf: url!)
                                    postimage = UIImage(data: img!)!
                                    imagestatusstring = "yes"
                                }
                            }
                            if(((result.value(forKey: "statuses")! as! NSArray)[i] as! NSDictionary).value(forKey: "created_at") != nil)
                            {
                                
                                if((((result.value(forKey: "statuses")! as! NSArray)[i] as! NSDictionary).value(forKey: "created_at")! as AnyObject).isKind(of: NSArray.self)){
                                    let dateoffeed1 = ((result.value(forKey: "statuses")! as! NSArray)[i] as! NSDictionary).value(forKey: "created_at") as! NSArray
                                    let dateoffeed2 = dateoffeed1[0] as! String
                                    
                                    let df1 = DateFormatter()
                                    df1.dateFormat = "EEE MMM dd HH:mm:ss VVVV yyyy"
                                    let convertedDate1 = df1.date(from: dateoffeed2)!
                                    let timeInterval = convertedDate1.timeIntervalSince1970
                                    let myInt = Int(timeInterval)
                                    posttime = myInt
                                    
                                } else {
                                    let dateoffeed = ((result.value(forKey: "statuses")! as! NSArray)[i] as! NSDictionary).value(forKey: "created_at") as! String
                                    let df1 = DateFormatter()
                                    df1.dateFormat = "EEE MMM dd HH:mm:ss VVVV yyyy"
                                    let convertedDate1 = df1.date(from: dateoffeed)!
                                    let timeInterval = convertedDate1.timeIntervalSince1970
                                    let myInt = Int(timeInterval)
                                    posttime = myInt
                                }
                                
                            }
                            else
                            {
                                let dateoffeed = "Tue May 02 04:00:06 +0000 2017"
                                let df1 = DateFormatter()
                                df1.dateFormat = "EEE MMM dd HH:mm:ss VVVV yyyy"
                                let convertedDate1 = df1.date(from: dateoffeed)!
                                let timeInterval = convertedDate1.timeIntervalSince1970
                                
                                let myInt = Int(timeInterval)
                                posttime = myInt
                            }
                            socialmediatype = "twitter"
                            alreadyliked = ""
                            let postdetails = compareTimestamp.init(posttext: posttext, likecount: postlikecount, commentcount: postcommentcount, image: postimage, timestamp: posttime, postid: postid, alreadyliked: alreadyliked, socialmediatype: socialmediatype, posttextviewheight: 50.0, cellheight: 100.0,hashtagpost: "yes",imagestatus: imagestatusstring)
                            self.details.append(postdetails)
                            self.posttextarray.add(posttext)
                            self.postidarray.add(postid)
                        }
                        
                    }
                    
                }
                
                if((self.instagramiddict.object(forKey: self.restaurantlabelname)) != nil)
                {
                    self.twitterandinstagram = 1
                    self.footerhidden=1
                    
                } else {
                    
                    if((self.dictionaryinstagramusername.object(forKey: self.restaurantlabelname)) != nil)
                    {
                        self.twitterandinstagram = 3
                        
                        self.footerhidden=1
                    } else {
                        self.twitterandinstagram = -2
                        
                        self.footerhidden=0
                        self.heightoffooter=0
                    }
                    
                }
                
                DispatchQueue.main.sync(execute: {
                    /* Do UI work here */
                    
                    self.details.sort{ $0.timestamp > $1.timestamp }
                    
                    ActivityIndicator.current().hide()
                    self.backviewofactivity.isHidden=true
                    self.loadmorebutton.isHidden = true
                    
                    
                    self.collection_view.reloadData()
                });
            }
                
            catch let error as Error
            {
                //print(error)
            }
            
            if (error != nil)
            {
                DispatchQueue.main.async(execute: {
                    
                    var alert = UIAlertView()
                    alert = UIAlertView(title:"Alert", message: "Data not found", delegate: self, cancelButtonTitle:"OK")
                    alert.show()
                })
            }
            else
            {
                
            }
            
        })
        task.resume()
    }
    
    func twitterpostswithtagFHSEngine(_ username: String) {
        DispatchQueue.global(priority: DispatchQueue.GlobalQueuePriority.default).async(execute: {() -> Void in
            
            FHSTwitterEngine.shared().loadAccessToken()
            let result1 = FHSTwitterEngine.shared().searchTweets(withQuery: username, count: 10, resultType: FHSTwitterEngineResultTypeRecent, unil: nil, sinceID: nil, maxID: nil) as! NSDictionary
            print(result1)
            let array1=UserDefaults.standard.value(forKey: "twitterhashtagposts") as! NSArray
            
            if((result1.value(forKey: "statuses")! as AnyObject).count != 0)
            {
                var countofresult = (result1.value(forKey: "statuses")! as AnyObject).count as Int
                if(countofresult > 10) {
                    countofresult=10
                } else {
                    
                }
                
                for var i in 0..<countofresult
                {
                    let idofpost1 = ((result1.value(forKey: "statuses")! as! NSArray)[i] as! NSDictionary).value(forKey: "id")!
                    let idofpost2 = String(describing: idofpost1)
                    
                    if(self.postidarray.contains(idofpost2)) {
                        
                    } else {
                        var posttext = ""
                        var posttime = Int()
                        var postcommentcount = ""
                        var postlikecount = ""
                        var postimage = UIImage()
                        var socialmediatype = ""
                        var alreadyliked = ""
                        var postid = ""
                        var imagestatusstring = ""
                        
                        self.twitterhashtagpostornot.add("")
                        
                        if(array1.contains(idofpost2)){
                            alreadyliked = "liked"
                        } else {
                            alreadyliked = ""
                        }
                        
                        postid=idofpost2
                        
                        let textofpost = ((result1.value(forKey: "statuses")! as! NSArray)[i] as! NSDictionary).value(forKey: "text")!
                        posttext = String(describing: textofpost)
                        
                        let likecount = ((result1.value(forKey: "statuses")! as! NSArray)[i] as! NSDictionary).value(forKey: "favorite_count")!
                        postlikecount=String(describing: likecount)
                        
                        let commentcount = ((result1.value(forKey: "statuses")! as! NSArray)[i] as! NSDictionary).value(forKey: "retweet_count")!
                        postcommentcount = String(describing: commentcount)
                        
                        if((((((result1.value(forKey: "statuses")! as! NSArray)[i] as! NSDictionary).value(forKey: "extended_entities") as AnyObject).value(forKey: "media") as AnyObject).value(forKey: "media_url_https") as AnyObject).isKind(of: NSNull.self))
                        {
                            postimage=UIImage.init(named: "NoImage")!
                            imagestatusstring = "no"
                        }
                        else
                        {
                            
                            let imageurlstr1 = ((((((result1.value(forKey: "statuses")! as! NSArray)[i] as! NSDictionary).value(forKey: "extended_entities") as AnyObject).value(forKey: "media") as AnyObject).value(forKey: "media_url_https"))! as! NSArray)[0]
                            let imageurlstr2 = String(describing: imageurlstr1)
                            
                            if(imageurlstr2 == "")
                            {
                                postimage=UIImage.init(named: "NoImage")!
                                imagestatusstring = "no"
                            } else {
                                let url = URL(string: imageurlstr2)
                                let img=try? Data(contentsOf: url!)
                                postimage = UIImage(data: img!)!
                                imagestatusstring = "yes"
                            }
                        }
                        
                        if(((result1.value(forKey: "statuses")! as! NSArray)[i] as! NSDictionary).value(forKey: "created_at") != nil)
                        {
                            if((((result1.value(forKey: "statuses")! as! NSArray)[i] as! NSDictionary).value(forKey: "created_at")! as AnyObject).isKind(of: NSArray.self)){
                                let dateoffeed1 = ((result1.value(forKey: "statuses")! as! NSArray)[i] as! NSDictionary).value(forKey: "created_at") as! NSArray
                                let dateoffeed2 = dateoffeed1[0] as! String
                                
                                let df1 = DateFormatter()
                                df1.dateFormat = "EEE MMM dd HH:mm:ss VVVV yyyy"
                                let convertedDate1 = df1.date(from: dateoffeed2)!
                                let timeInterval = convertedDate1.timeIntervalSince1970
                                let myInt = Int(timeInterval)
                                posttime = myInt
                                
                            } else {
                                let dateoffeed = ((result1.value(forKey: "statuses")! as! NSArray)[i] as! NSDictionary).value(forKey: "created_at") as! String
                                let df1 = DateFormatter()
                                df1.dateFormat = "EEE MMM dd HH:mm:ss VVVV yyyy"
                                let convertedDate1 = df1.date(from: dateoffeed)!
                                let timeInterval = convertedDate1.timeIntervalSince1970
                                let myInt = Int(timeInterval)
                                posttime = myInt
                            }
                        }
                        else
                        {
                            let dateoffeed = "Tue May 02 04:00:10 +0000 2017"
                            let df1 = DateFormatter()
                            df1.dateFormat = "EEE MMM dd HH:mm:ss VVVV yyyy"
                            let convertedDate1 = df1.date(from: dateoffeed)!
                            let timeInterval = convertedDate1.timeIntervalSince1970
                            
                            let myInt = Int(timeInterval)
                            posttime = myInt
                        }
                        socialmediatype = "twitter"
                        let postdetails = compareTimestamp.init(posttext: posttext, likecount: postlikecount, commentcount: postcommentcount, image: postimage, timestamp: posttime, postid: postid, alreadyliked: alreadyliked, socialmediatype: socialmediatype, posttextviewheight: 50.0, cellheight: 100.0,hashtagpost: "yes",imagestatus: imagestatusstring)
                        self.details.append(postdetails)
                        self.posttextarray.add(posttext)
                        self.postidarray.add(postid)
                        
                    }
                    
                }
                
            }
            if((self.instagramiddict.object(forKey: self.restaurantlabelname)) != nil)
            {
                self.twitterandinstagram = 1
                self.footerhidden=1
                
            } else {
                
                if((self.dictionaryinstagramusername.object(forKey: self.restaurantlabelname)) != nil)
                {
                    self.twitterandinstagram = 3
                    
                    self.footerhidden=1
                } else {
                    self.twitterandinstagram = -2
                    
                    self.footerhidden=0
                    self.heightoffooter=0
                }
                
            }
            DispatchQueue.main.async(execute: {() -> Void in
                // Add code here to update the UI/send notifications based on the
                // results of the background processing
                
                self.details.sort{ $0.timestamp > $1.timestamp }
                
                ActivityIndicator.current().hide()
                self.backviewofactivity.isHidden=true
                
                self.loadmorebutton.isHidden = true
                
                self.collection_view.reloadData()
            })
        })
    }
    
    func callm ()
    {
        ActivityIndicator.current().hide()
        self.backviewofactivity.isHidden=true
        
        self.collection_view.reloadData()
    }
    
    func facebookfeeds(_ fbuserid:String)
    {
        let accsstoken = self.accesstokenofFB
        let jsonUrlPath = "https://graph.facebook.com/\(fbuserid)/posts?fields=description,likes.summary(true),full_picture,picture,message,comments.summary(true),created_time&access_token=\(self.accesstokenofFB)"
        let urlStr = jsonUrlPath.addingPercentEscapes(using: String.Encoding.utf8)
        
        let url:URL = URL(string: urlStr!)!
        
        let session  = URLSession.shared
        let task = session.dataTask(with: url, completionHandler: {data,response,error -> Void in
            if error != nil
            {
                //print(error!.localizedDescription)
            }
            
            do
            {
                let resultdict = try JSONSerialization.jsonObject(with: data! , options: JSONSerialization.ReadingOptions.mutableContainers) as! NSMutableDictionary
                
                let arrayCount = (resultdict.value(forKey: "data")! as AnyObject).count as Int
                
                for var i in 0..<arrayCount
                {
                    //TEXT OF POST
                    
                    var posttext = ""
                    var posttime = Int()
                    var postcommentcount = ""
                    var postlikecount = ""
                    var postimage = UIImage()
                    var socialmediatype = ""
                    var alreadyliked = ""
                    var postid = ""
                    var imagestatusstring = ""
                    
                    self.twitterhashtagpostornot.add("")
                    
                    let postid1 = ((resultdict.value(forKey: "data")! as! NSArray)[i] as! NSDictionary).value(forKey: "id")!
                    postid = String(describing: postid1)
                    if((((resultdict.value(forKey: "data")! as! NSArray)[i] as! NSDictionary).object(forKey: "message")) != nil)
                    {
                        let postmessage1 = ((resultdict.value(forKey: "data")! as! NSArray)[i] as! NSDictionary).value(forKey: "message")! as! String
                        posttext = postmessage1
                    }
                    else
                    {
                        posttext = ""
                    }
                    
                    //DATE OF POST
                    
                    var datestring = ((resultdict.value(forKey: "data")! as! NSArray)[i] as! NSDictionary).value(forKey: "created_time")! as! String
                    datestring = datestring.replacingOccurrences(of: "T", with: " ")
                    let df1 = DateFormatter()
                    df1.dateFormat = "yyyy-MM-dd HH:mm:ssVVVV"
                    let convertedDate1 = df1.date(from: datestring)!
                    
                    let timeInterval = convertedDate1.timeIntervalSince1970
                    
                    let myInt = Int(timeInterval)
                    posttime = myInt
                    
                    //COMMENTCOUNT OF POST
                    
                    if((((resultdict.value(forKey: "data")! as! NSArray)[i] as! NSDictionary).object(forKey: "comments")) != nil)
                    {
                        let commentcout1 = (((resultdict.value(forKey: "data")! as! NSArray)[i] as! NSDictionary).value(forKey: "comments") as AnyObject).value(forKey: "summary") as! NSDictionary
                        let commentcount2 = commentcout1.value(forKey: "total_count") as! NSNumber
                        postcommentcount=String(describing: commentcount2)
                    }
                    else
                    {
                        postcommentcount="0"
                    }
                    
                    //LIKECOUNT OF POST
                    
                    
                    if((((resultdict.value(forKey: "data")! as! NSArray)[i] as! NSDictionary).object(forKey: "likes")) != nil)
                    {
                        let likecount1 = ((((resultdict.value(forKey: "data")! as! NSArray)[i] as! NSDictionary).value(forKey: "likes") as AnyObject).value(forKey: "summary") as AnyObject).value(forKey: "total_count") as! NSNumber
                        let likecount2 = likecount1
                        
                        postlikecount = String(describing: likecount1)
                        
                        let userslistarray = (((resultdict.value(forKey: "data")!  as! NSArray)[i] as! NSDictionary).value(forKey: "likes") as AnyObject).value(forKey: "data") as! NSArray
                        self.facebookLikedUsers.add(userslistarray)
                        
                    }
                    else
                    {
                        postlikecount = "0"
                        
                        self.facebookLikedUsers.add([])
                    }
                    
                    //POST IMAGE URL
                    if((((resultdict.value(forKey: "data")!  as! NSArray)[i] as! NSDictionary).object(forKey: "full_picture")) != nil)
                    {
                        let imagurl = ((resultdict.value(forKey: "data")! as! NSArray)[i] as! NSDictionary).object(forKey: "full_picture")
                        let url1 = URL.init(string: imagurl as! String)
                        let cfAnswer = NSData.init(contentsOf: url1!)
                        if(cfAnswer == nil)
                        {
                            postimage=UIImage.init(named: "NoImage")!
                            imagestatusstring = "no"
                        }else {
                            postimage = UIImage(data: cfAnswer! as Data)!
                            imagestatusstring = "yes"
                        }
                    }
                    else
                    {
                        postimage=UIImage.init(named: "NoImage")!
                        imagestatusstring = "no"
                    }
                    
                    //INSTAFBTWITR ARRAY FOR POSTING LIKES AND COMMENTS
                    
                    socialmediatype = "facebook"
                    alreadyliked = ""
                    
                    let postdetails = compareTimestamp.init(posttext: posttext, likecount: postlikecount, commentcount: postcommentcount, image: postimage, timestamp: posttime, postid: postid, alreadyliked: alreadyliked, socialmediatype: socialmediatype, posttextviewheight: 50.0, cellheight: 100.0,hashtagpost: "",imagestatus: imagestatusstring)
                    self.details.append(postdetails)
                    self.posttextarray.add(posttext)
                    self.postidarray.add(postid)
                }
                
            } catch _
            {
                //print("error ")
            }
            
            DispatchQueue.main.async(execute: {
                
                if((self.twitteruserdict.object(forKey: self.restaurantlabelname)) != nil)
                {
                    self.twitterandinstagram=0
                    
                    self.footerhidden=1
                }
                else if((self.instagramiddict.object(forKey: self.restaurantlabelname)) != nil)
                {
                    self.twitterandinstagram=1
                    
                    self.footerhidden=1
                } else if((self.dictionaryinstagramusername.object(forKey: self.restaurantlabelname)) != nil)
                {
                    self.twitterandinstagram=3
                    self.footerhidden=1
                }
                
                self.details.sort{ $0.timestamp > $1.timestamp }
                
                ActivityIndicator.current().hide()
                self.backviewofactivity.isHidden=true
                
                self.collection_view.reloadData()
                
                
            })
        })
        
        task.resume()
        
    }
    
    
    //MARK: Like, Comment And Post Action
    
    @IBAction func likebuttonaction(_ sender: AnyObject)
    {
        
    }
    
    @IBAction func commentbuttonaction(_ sender: AnyObject)
    {
        self.indexofselectedrow=sender.tag
        self.collection_view.reloadData()
    }
    
    @IBAction func postbutton(_ sender: AnyObject) {
        
        if(self.details[sender.tag].socialmediatype == "instagram")
        {
            if(self.messagetopost.uppercased(with: Locale.current) == self.messagetopost) {
                let alert = UIAlertController(title: "Alert", message: "The comment cannot consist of all capital letters", preferredStyle: UIAlertControllerStyle.alert)
                
                let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
                    
                }
                alert.addAction(okAction)
                self.present(alert, animated: true, completion: nil)
                
            } else if(self.messagetopost.characters.count > 300) {
                //The total length of the comment cannot exceed 300 characters
                let alert = UIAlertController(title: "Alert", message: "The total length of the comment cannot exceed 300 characters", preferredStyle: UIAlertControllerStyle.alert)
                let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
                }
                alert.addAction(okAction)
                self.present(alert, animated: true, completion: nil)
            } else {
                ActivityIndicator.current().show()
                self.backviewofactivity.isHidden=false
                
                let idofpost2 = self.details[sender.tag].postid
                self.commentInstagramPost(idofpost2, tagofsender: sender.tag)
            }
        }
        else if(self.details[sender.tag].socialmediatype == "facebook")
        {
            
            var publishexist=""
            let permissionarray = FBSDKAccessToken.current().permissions
            for i in permissionarray!
            {
                let str = i as! String
                if(str=="publish_actions")
                {
                    publishexist = i as! String
                }
            }
            
            if(FBSDKAccessToken.current() == nil)
            {
                let alert = UIAlertController(title: "Alert", message: "Please Login with Facebook to Perform actions on Feeds", preferredStyle: UIAlertControllerStyle.alert)
                let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
                    
                }
                let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
                    
                    let loginManager : FBSDKLoginManager = FBSDKLoginManager()
                    
                    loginManager.logIn(withReadPermissions: ["email","user_posts"]) { (result, error) -> Void in
                        
                        if (error != nil)
                        {
                            //print("error")
                        }
                        else if (result?.isCancelled)!
                        {
                            NSLog("Cancelled");
                        }
                        else
                        {
                            if ((FBSDKAccessToken.current()) != nil)
                            {
                                FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, picture.type(large), email"]).start(completionHandler: { (connection, result, error) -> Void in
                                    
                                    
                                    
                                    if (error == nil)
                                    {
                                        
                                    }
                                })
                            }
                        }
                    }
                }
                alert.addAction(cancelAction)
                alert.addAction(okAction)
                self.present(alert, animated: true, completion: nil)
                
            }
            else if(publishexist == "")
            {
                let idofpost = self.details[sender.tag].postid
                
                let loginManager : FBSDKLoginManager = FBSDKLoginManager()
                
                loginManager.logIn(withPublishPermissions: ["publish_actions"]) { (result, error) -> Void in
                    
                    let params = ["message": self.messagetopost]
                    
                    FBSDKGraphRequest(graphPath: "/\(idofpost)/comments", parameters: params, httpMethod: "POST").start(completionHandler: { (connection, result, error) -> Void in
                        if (error == nil){
                        }
                        else
                        {
                        }
                    })
                }
            }
            else
            {
                ActivityIndicator.current().show()
                self.backviewofactivity.isHidden=false
                
                let idofpost = self.details[sender.tag].postid
                
                let params = ["message": self.messagetopost]
                FBSDKGraphRequest(graphPath: "/\(idofpost)/comments", parameters: params, httpMethod: "POST").start(completionHandler: { (connection, result, error) -> Void in
                    
                    if (error == nil) {
                        let commentcount1 = self.details[sender.tag].commentcount
                        var commentcount2:Int? = Int(commentcount1)
                        commentcount2 = commentcount2!+1
                        self.details[sender.tag].commentcount = String(describing: commentcount2!)
                        
                        self.collection_view.reloadData()
                        ActivityIndicator.current().hide()
                        self.backviewofactivity.isHidden=true
                        
                        let alert = UIAlertController(title: "Alert", message: "Comment Successfully Post", preferredStyle: UIAlertControllerStyle.alert)
                        
                        let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
                            
                        }
                        alert.addAction(okAction)
                        self.present(alert, animated: true, completion: nil)
                        
                    }
                    else
                    {
                        self.collection_view.reloadData()
                        ActivityIndicator.current().hide()
                        self.backviewofactivity.isHidden=true
                    }
                    
                })
            }
        }
        else
        {
            //            if(FHSTwitterEngine.shared().accessToken.key == nil) {
            //
            //                let alert = UIAlertController(title: "Alert", message: "If you want to Retweet on Twitter post,then authorize the app through login with Twitter", preferredStyle: UIAlertControllerStyle.alert)
            //
            //                let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            //
            //                }
            //                let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
            //
            //                    let loginController = FHSTwitterEngine .shared() .loginController { (success) -> Void in
            //
            //                        let twitterid1 = (self.twitteruserdict.object(forKey: self.restaurantlabelname)) as! String
            //
            //                        self.FHSEnginePostsafterLoginonLike(twitterid1)
            //
            //                        } as UIViewController
            //                    self .present(loginController, animated: true, completion: nil)
            //
            //                }
            //                alert.addAction(cancelAction)
            //                alert.addAction(okAction)
            //                self.present(alert, animated: true, completion: nil)
            //            } else {
            //                let idofpost1 = self.idsofposts[sender.tag]
            //                let idofpost2 = String(describing: idofpost1)
            //
            //                UserDefaults.standard.setValue(idofpost2, forKey: "idoftwitterpost")
            //                UserDefaults.standard.set(sender.tag, forKey: "tagoftwitterpost")
            //                UserDefaults.standard.synchronize()
            //                self.retweettwitterpost(idofpost2, sendertag: sender.tag)
            //
            //
            //            }
        }
        
    }
    func likeInstagramPost(_ idofpost: String,action: String,tagofsender: Int)
    {
        
        let jsonUrlPath = "https://api.instagram.com/v1/media/\(idofpost)/likes?access_token=\(self.accesstokenInstagram)"
        
        let URL = Foundation.URL(string: jsonUrlPath)!
        
        guard let requestUrl = Foundation.URL(string:jsonUrlPath) else { return }
        var request = URLRequest(url:requestUrl)
        if(action == "delete") {
            request.httpMethod = "DELETE"
        } else {
            request.httpMethod = "POST"
        }
        let task = URLSession.shared.dataTask(with: request, completionHandler: {data,response,error -> Void in
            
            do
            {
                let responsedict = try JSONSerialization.jsonObject(with: data! , options: JSONSerialization.ReadingOptions.mutableContainers) as! NSMutableDictionary
                
                
                if(action == "delete") {
                    self.details[tagofsender].alreadyliked = ""
                    let likecount1 = self.details[tagofsender].likecount
                    var likecount2:Int? = Int(likecount1)
                    likecount2 = likecount2!-1
                    self.details[tagofsender].likecount = String(describing: likecount2!)
                    
                } else {
                    self.details[tagofsender].alreadyliked = "liked"
                    let likecount1 = self.details[tagofsender].likecount
                    var likecount2:Int? = Int(likecount1)
                    likecount2 = likecount2!+1
                    self.details[tagofsender].likecount = String(describing: likecount2!)
                    
                }
                
            } catch _
            {
                //print("error")
            }
            
            if error != nil
            {
                //print(error!.localizedDescription)
            }
            
            var err:NSError?
            
            if err != nil
            {
                //print("Json Error\(err!.localizedDescription)")
            }
            
            DispatchQueue.main.async(execute: {
                ActivityIndicator.current().hide()
                self.backviewofactivity.isHidden=true
                
                self.collection_view.reloadData()
            })
        })
        
        task.resume()
    }
    
    func commentInstagramPost(_ idofpost: String,tagofsender: Int)
    {
        let post = NSString(format:"access_token=%@&text=%@",self.accesstokenInstagram,self.messagetopost)
        let post1 = post.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        
        let datamodel1 = post1!.data(using: String.Encoding.ascii)!
        
        let postLength = String(datamodel1.count)
        
        let requestUrl = URL(string:"https://api.instagram.com/v1/media/\(idofpost)/comments")
        var request = URLRequest(url:requestUrl!)
        request.httpMethod = "POST"
        request.httpBody = datamodel1
        request.setValue(postLength, forHTTPHeaderField: "Content-Length")
        let task = URLSession.shared.dataTask(with: request, completionHandler: {data,response,error -> Void in
            
            
            do
            {
                
                let dicObj = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSMutableDictionary
                
                let errorvalue = (dicObj.value(forKey: "meta") as AnyObject).value(forKey: "code") as! Int
                
                if(errorvalue == 200) {
                    let commentcount1 = self.details[tagofsender].commentcount
                    var commentcount2:Int? = Int(commentcount1)
                    commentcount2 = commentcount2!+1
                    self.details[tagofsender].commentcount = String(describing: commentcount2!)
                    
                } else {
                    
                    
                }
                DispatchQueue.main.async(execute: {
                    
                    ActivityIndicator.current().hide()
                    self.backviewofactivity.isHidden=true
                    
                    self.collection_view.reloadData()
                    
                    if(errorvalue == 200) {
                        let alert = UIAlertController(title: "Alert", message: "Comment Successfully Post", preferredStyle: UIAlertControllerStyle.alert)
                        
                        let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
                            
                        }
                        alert.addAction(okAction)
                        self.present(alert, animated: true, completion: nil)
                    } else {
                        
                    }
                    
                    
                })
            }
                
            catch let error as NSError
            {
                
            }
        })
        
        task.resume()
    }
    func UnlikeTwitterPost()
    {
        ActivityIndicator.current().show()
        self.backviewofactivity.isHidden=false
        
        DispatchQueue.global(priority: DispatchQueue.GlobalQueuePriority.default).async(execute: {() -> Void in
            
            let idofpost1 = UserDefaults.standard.value(forKey: "idoftwitterpost") as! String
            let tagofpost1 = UserDefaults.standard.integer(forKey: "tagoftwitterpost")
            FHSTwitterEngine.shared().loadAccessToken()
            let responsevalue = FHSTwitterEngine.shared().markTweet(idofpost1, asFavorite: false)
            
            
            DispatchQueue.main.async(execute: {() -> Void in
                
                if(responsevalue == nil) {
                    self.details[tagofpost1].alreadyliked = ""
                    let likecount1 = self.details[tagofpost1].likecount
                    var likecount2:Int? = Int(likecount1)
                    likecount2 = likecount2!-1
                    self.details[tagofpost1].likecount = String(describing: likecount2!)
                    
                    if(self.details[tagofpost1].hashtagpost == "yes") {
                        let array1=UserDefaults.standard.value(forKey: "twitterhashtagposts") as! NSArray
                        
                        if(array1.contains(idofpost1)){
                            let array2 = NSMutableArray(array: array1)
                            array2.remove(idofpost1)
                            
                            let array3 = NSArray(array: array2)
                            
                            UserDefaults.standard.setValue(array3, forKey:"twitterhashtagposts")
                        }
                        
                    }
                    self.collection_view.reloadData()
                    ActivityIndicator.current().hide()
                    self.backviewofactivity.isHidden=true
                } else {
                    self.UnlikeTwitterPost()
                }
            })
        })
        
    }
    func likeTwitterPost()
    {
        ActivityIndicator.current().show()
        self.backviewofactivity.isHidden=false
        
        DispatchQueue.global(priority: DispatchQueue.GlobalQueuePriority.default).async(execute: {() -> Void in
            
            let idofpost1 = UserDefaults.standard.value(forKey: "idoftwitterpost") as! String
            let tagofpost1 = UserDefaults.standard.integer(forKey: "tagoftwitterpost")
            
            FHSTwitterEngine.shared().loadAccessToken()
            let responsevalue = FHSTwitterEngine.shared().markTweet(idofpost1, asFavorite: true)
            DispatchQueue.main.async(execute: {() -> Void in
                
                if(responsevalue == nil) {
                    self.details[tagofpost1].alreadyliked = "liked"
                    let likecount1 = self.details[tagofpost1].likecount
                    var likecount2:Int? = Int(likecount1)
                    likecount2 = likecount2!+1
                    self.details[tagofpost1].likecount = String(describing: likecount2!)
                    
                    if(self.details[tagofpost1].hashtagpost == "yes") {
                        let array1=UserDefaults.standard.value(forKey: "twitterhashtagposts") as! NSArray
                        
                        let array2 = NSMutableArray(array: array1)
                        array2.add(idofpost1)
                        
                        let array3 = NSArray(array: array2)
                        
                        UserDefaults.standard.setValue(array3, forKey:"twitterhashtagposts")
                        
                    }
                    
                    self.collection_view.reloadData()
                    
                    ActivityIndicator.current().hide()
                    self.backviewofactivity.isHidden=true
                    
                } else {
                    self.likeTwitterPost()
                }
                
            })
        })
    }
    func retweettwitterpost(_ idof:String,sendertag:Int) {
        
        ActivityIndicator.current().show()
        self.backviewofactivity.isHidden=false
        
        DispatchQueue.global(priority: DispatchQueue.GlobalQueuePriority.default).async(execute: {() -> Void in
            
            
            let idofpost1 = UserDefaults.standard.value(forKey: "idoftwitterpost") as! String
            let tagofpost1 = UserDefaults.standard.integer(forKey: "tagoftwitterpost")
            
            FHSTwitterEngine.shared().loadAccessToken()
            let responsevalue = FHSTwitterEngine.shared().postTweet(self.messagetopost, inReplyTo: idof)
            
            DispatchQueue.main.async(execute: {() -> Void in
                
                if(responsevalue == nil) {
                    
                    var likecount1 = self.instacommentsarr[sendertag] as! Int
                    likecount1 = likecount1+1
                    self.instacommentsarr.replaceObject(at: sendertag, with: likecount1)
                    
                    self.collection_view.reloadData()
                    ActivityIndicator.current().hide()
                    self.backviewofactivity.isHidden=true
                    
                    let alert = UIAlertController(title: "Alert", message: "Re-tweet in reply to this tweet Successfully Done", preferredStyle: UIAlertControllerStyle.alert)
                    
                    let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
                        
                    }
                    alert.addAction(okAction)
                    self.present(alert, animated: true, completion: nil)
                    
                } else {
                    ActivityIndicator.current().hide()
                    self.backviewofactivity.isHidden=true
                    //self.retweettwitterpost()
                }
            })
        })
    }
    @IBAction func LikeButton(_ sender: UIButton) {
        
        if(self.details[sender.tag].socialmediatype == "instagram")
        {
            //https://api.instagram.com/v1/media/{media-id}/likes/access_token=
            let valuefromalready = self.details[sender.tag].alreadyliked
            
            if(valuefromalready == "liked") {
                ActivityIndicator.current().show()
                self.backviewofactivity.isHidden=false
                
                let idofpost2 = self.details[sender.tag].postid
                
                self.likeInstagramPost(idofpost2,action: "delete",tagofsender: sender.tag)
                
            } else {
                ActivityIndicator.current().show()
                self.backviewofactivity.isHidden=false
                
                let idofpost2 = self.details[sender.tag].postid
                
                self.likeInstagramPost(idofpost2,action: "post",tagofsender: sender.tag)
                
            }
            
        }
        else if(self.details[sender.tag].socialmediatype == "facebook")
        {
            /*
             if(FBSDKAccessToken.currentAccessToken() == nil)
             {
             let alert = UIAlertController(title: "Alert", message: "Please Login with Facebook to Perform actions on Feeds", preferredStyle: UIAlertControllerStyle.Alert)
             let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (action) in
             
             }
             let okAction = UIAlertAction(title: "OK", style: .Default) { (action) in
             
             let loginManager : FBSDKLoginManager = FBSDKLoginManager()
             
             loginManager.logInWithReadPermissions(["email","user_posts"]) { (result, error) -> Void in
             
             if (error != nil)
             {
             //print("error")
             }
             else if (result.isCancelled)
             {
             NSLog("Cancelled");
             }
             else
             {
             if ((FBSDKAccessToken.currentAccessToken()) != nil)
             {
             FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, picture.type(large), email"]).startWithCompletionHandler({ (connection, result, error) -> Void in
             //print(FBSDKAccessToken.currentAccessToken().permissions)
             
             if (error == nil)
             {
             
             }
             
             })
             }
             }
             }
             
             }
             alert.addAction(cancelAction)
             alert.addAction(okAction)
             self.presentViewController(alert, animated: true, completion: nil)
             
             }
             else
             {
             
             var publishexist=""
             let permissionarray = FBSDKAccessToken.currentAccessToken().permissions
             // //print(permissionarray)
             for i in permissionarray
             {
             //print(i)
             if(i=="publish_actions")
             {
             publishexist = i as! String
             }
             }
             
             
             if(publishexist == "")
             {
             let idofpost = self.idsofposts[sender.tag]
             
             let loginManager : FBSDKLoginManager = FBSDKLoginManager()
             
             loginManager.logInWithPublishPermissions(["publish_actions"]) { (result, error) -> Void in
             
             //                FBSDKGraphRequest(graphPath: "/\(idofpost)/likes", parameters: nil, HTTPMethod: "POST").startWithCompletionHandler({ (connection, result, error) -> Void in
             //                    if (error == nil){
             //
             //                        //print(result)
             //                        //print(FBSDKAccessToken.currentAccessToken().permissions)
             //
             //                    }
             //                    else
             //                    {
             //                        //print(FBSDKAccessToken.currentAccessToken().permissions)
             //                        //print(error)
             //                    }
             //
             //                })
             
             }
             }
             else
             {
             if FBSDKAccessToken.currentAccessToken().hasGranted("publish_actions")
             {
             let idofpost = self.idsofposts[sender.tag] as! String
             var params = ["object": "http://samples.ogp.me/226075010839791"]
             
             FBSDKGraphRequest(graphPath: "/\(idofpost)/og.likes", parameters: params, HTTPMethod: "POST").startWithCompletionHandler({ (connection, result, error) -> Void in
             if (error == nil){
             
             self.PostsLikedAlready.replaceObjectAtIndex(sender.tag, withObject: "Liked")
             
             self.collection_view.reloadData()
             
             //                            let alert = UIAlertController(title: "Alert", message: "Liked Successfully", preferredStyle: UIAlertControllerStyle.Alert)
             //
             //                            let okAction = UIAlertAction(title: "OK", style: .Default) { (action) in
             //
             //
             //                            }
             //                            alert.addAction(okAction)
             //                            self.presentViewController(alert, animated: true, completion: nil)
             
             //print(result)
             //print(FBSDKAccessToken.currentAccessToken().permissions)
             
             }
             else
             {
             //print(FBSDKAccessToken.currentAccessToken().permissions)
             //print(error)
             }
             
             })
             
             }
             }
             }
             //print(self.instacaptionarr)*/
        }
        else
        {
            
            if(FHSTwitterEngine.shared().accessToken.key == nil) {
                
                let alert = UIAlertController(title: "Alert", message: "If you want to like posts of Twitter,then authorize the app through login with Twitter", preferredStyle: UIAlertControllerStyle.alert)
                
                let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
                    
                }
                let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
                    
                    let loginController = FHSTwitterEngine .shared() .loginController { (success) -> Void in
                        
                        
                        let twitterid1 = (self.twitteruserdict.object(forKey: self.restaurantlabelname)) as! String
                        
                        self.FHSEnginePostsafterLoginonLike(twitterid1)
                        } as UIViewController
                    self .present(loginController, animated: true, completion: nil)
                    
                }
                alert.addAction(cancelAction)
                alert.addAction(okAction)
                self.present(alert, animated: true, completion: nil)
            } else {
                
                let valuefromalready = self.details[sender.tag].alreadyliked
                
                if(valuefromalready == "liked") {
                    
                    let idofpost2 = self.details[sender.tag].postid
                    
                    UserDefaults.standard.setValue(idofpost2, forKey: "idoftwitterpost")
                    UserDefaults.standard.set(sender.tag, forKey: "tagoftwitterpost")
                    self.UnlikeTwitterPost()
                    
                } else {
                    
                    let idofpost2 = self.details[sender.tag].postid
                    
                    UserDefaults.standard.setValue(idofpost2, forKey: "idoftwitterpost")
                    UserDefaults.standard.set(sender.tag, forKey: "tagoftwitterpost")
                    self.likeTwitterPost()
                    
                }
                
            }
            
        }
    }
    @IBAction func commentButton(_ sender: UIButton) {
        
        self.indexofselectedrow=sender.tag
        self.collection_view.reloadData()
        
    }
}
