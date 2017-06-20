//
//  GridVC.swift
//  ZumeSpot
//
//  Created by Terris Phillips on 6/4/17.
//  Copyright © 2017 Terris Phillips. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit
import FBSDKCoreKit
import FBSDKLoginKit
import Foundation
import FirebaseDatabase
class compareTimestamp1
{
    var name: String
    var location: String
    var age: String
    var profilePic: String
    var timestamp:Int
    var userIDStr: String
    
    init(name: String, location: String, age: String, pic: String,timestamp: Int,u_id: String){
        self.name = name
        self.location = location
        self.age = age
        self.profilePic = pic
        self.timestamp = timestamp
        self.userIDStr = u_id
    }
}

class GridVC: UIViewController ,UICollectionViewDataSource,UICollectionViewDelegate, UICollectionViewDelegateFlowLayout
{
    var details = [compareTimestamp1]()
    
    @IBOutlet weak var collection_view: UICollectionView!
    @IBOutlet var loadmorebutton: UIButton!
    var imagearray:[UIImage]=[]
    var instaimgurl=NSString()
    var hotelname=NSString()
    var itemsdict = NSMutableDictionary()
    var namearray=NSMutableArray()
    var hotelnamearr=NSMutableArray()
    
    var instagramid=NSMutableArray()
    
    var imagearray1=NSMutableArray()
    
    var sorteddistance1=[AnyObject]()
    var sorteddistance2=NSMutableArray()
    var position=0
    var footerhidden1=0
    var footerhidden2=0
    var lastindex1=15
    var lastindex2=15
    
    var nameofhotels = NSMutableArray()
    var latitudeofhotels = NSMutableArray()
    var longitudeofhotels = NSMutableArray()
    var distanceofhotels = NSMutableArray()
    
    var sorteddistance=[AnyObject]()
    
    var dictionaryofinstagramid = NSMutableDictionary()
    var dictionaryoftwitterusername = NSMutableDictionary()
    var dictionaryoffacebookid = NSMutableDictionary()
    
    var dictionaryforinstagramusername = NSMutableDictionary()
    
    var nameofhotelssorted = NSMutableArray()
    var backviewofactivity = UIView()
    
    var instagramnum = 1
    var twitternum   = 1
    var facebooknum  = 1
    
    var position1 = 0
    
    var countofhotel = 30
    
    var countoffooter = 0
    
    var sorteddictarray = Dictionary<String, Double>()
    
    var distancetoshowongrid = NSMutableArray()
    
    var accesstokenInstagram = String()
    
    var accesstokenFB = String()
    
    let engine = FHSTwitterEngine()
    
    var instagramAccessTokenValid = String()
    
    var cell_height = CGFloat()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        
        // Do any additional setup after loading the view.
        
        self.navigationController?.isNavigationBarHidden=true
        
        let layout = UICollectionViewFlowLayout()
        
        if (UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad)
        {
            
            layout.minimumInteritemSpacing=4
            layout.minimumLineSpacing=4
            layout.sectionInset.left=4
            layout.sectionInset.right=4
            
            countofhotel = 35
        }
        else
        {
            layout.minimumInteritemSpacing=2
            layout.minimumLineSpacing=2
            layout.sectionInset.left=2
            layout.sectionInset.right=2
        }
        
        collection_view.collectionViewLayout=layout
        
        //BACK VIEW OF ACTIVITY INDICATOR
        
        let widthofview = self.view.frame.size.width
        let heightofview = self.view.frame.size.height
        backviewofactivity.frame = CGRect(x: 0, y: 0, width: widthofview, height: heightofview)
        backviewofactivity.backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 254/255, alpha: 0.5)
        self.view.addSubview(backviewofactivity)
        self.backviewofactivity.isHidden = true
        
        for j in 0 ..< sorteddistance1.count
        {
            let meters=sorteddistance1[j] as! Double
            
            let kilometers = meters / 1000.0
            
            let miles = kilometers * 0.62137
            
            var string1=String(miles)
            
            string1 = string1.substring(to: string1.characters.index(string1.startIndex, offsetBy: 3))
            
            sorteddistance2.add(string1)
            
        }
        
        //BUTTON OF FIRST VIEW DATA
        
       // let path: NSString = Bundle.main.path(forResource: "new doc withFaceBookID", ofType: "json")! as NSString
       // let data : Data = try! Data(contentsOf: URL(fileURLWithPath: path as String), options: NSData.ReadingOptions.dataReadingMapped)
        
       // let array: NSArray!=(try! JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)) as! NSArray
        
        //FUNCTIONS TO CALL API'S
        
        accesstokenInstagram = UserDefaults.standard.value(forKey: "instagramtoken") as! String
        
        if(self.accesstokenInstagram == "") {
            
        } else {
            self.instagramAccessTokenValidity()
        }
        self.loadmorebutton.isHidden = true

        facebookaccess()
        fetchFireBaseData()
    }
    
    func fetchFireBaseData()
    {
        self.backviewofactivity.isHidden = false
        
        ActivityIndicator.current().show()
        let ref = Database.database().reference()
        ref.child("new doc withFaceBookID").observeSingleEvent(of: DataEventType.value, with: { (snapshot) in
            self.backviewofactivity.isHidden = true
            
            ActivityIndicator.current().hide()
           //print(snapshot.value)
            if let jsonArray = snapshot.value as? NSArray {
                self.setUpData(array: jsonArray)
            }
        })
    }
    
    func setUpData(array:NSArray)
    {
        for i in 0 ..< array.count
        {
            nameofhotels.add((array[i] as AnyObject).value(forKey: "Name") as! String)
            latitudeofhotels.add((array[i] as AnyObject).value(forKey: "Latitude") as! Double)
            longitudeofhotels.add((array[i] as AnyObject).value(forKey: "Longitude") as! Double)
        }
        
        for j in 0 ..< self.nameofhotels.count
        {
            let nullelement1 = "null"
            let nullelement2 = Double(nullelement1)
            if((array[j] as AnyObject).value(forKey: "InstagramUserId") as? Double != nullelement2)
            {
                dictionaryofinstagramid.setObject((array[j] as AnyObject).value(forKey: "InstagramUserId")!, forKey: nameofhotels[j] as! String as NSCopying)
            }
        }
        
        print(dictionaryofinstagramid)
        
        for k in 0 ..< nameofhotels.count
        {
            if((array[k] as AnyObject).value(forKey: "TwitterUserName") as! String != "")
            {
                dictionaryoftwitterusername.setObject((array[k] as AnyObject).value(forKey: "TwitterUserName")!, forKey: nameofhotels[k] as! String as NSCopying)
            }
        }
        
        for l in 0 ..< nameofhotels.count
        {
            let nullelement1 = "null"
            let nullelement2 = Double(nullelement1)
            
            if((array[l] as AnyObject).value(forKey: "FacebookUserId") as? Double != nullelement2)
            {
                dictionaryoffacebookid.setObject((array[l] as AnyObject).value(forKey: "FacebookUserId")!, forKey: nameofhotels[l] as! String as NSCopying)
            }
            
        }
        for m in 0 ..< nameofhotels.count
        {
            let nullelement1 = ""
            
            if((array[m] as AnyObject).value(forKey: "InstagramUserName") as? String != nullelement1)
            {
                dictionaryforinstagramusername.setObject((array[m] as AnyObject).value(forKey: "InstagramUserName")!, forKey: nameofhotels[m] as! String as NSCopying)
            }
        }
        
        //let currentLocation:CLLocationCoordinate2D? = CLLocationCoordinate2DMake(12.45, 23.45)
        let currentLocation = CLLocationManager().location?.coordinate
        
        for i in 0 ..< self.nameofhotels.count
        {
            let lati = Double(self.latitudeofhotels[i] as! NSNumber)
            let long = Double(self.longitudeofhotels[i] as! NSNumber)
            let destinationlocation=CLLocation(latitude:lati , longitude:long)
            
            let staticloca=CLLocation(latitude: (currentLocation?.latitude)!, longitude: (currentLocation?.longitude)!)
            
            //let staticloca=CLLocation(latitude: 34.050977, longitude: -118.248027)
            let distance=staticloca.distance(from: destinationlocation)
            distanceofhotels.add(distance)
        }
        
        //
        var objectsArray1 = ["\(nameofhotels[0])"]
        for i in 1 ..< nameofhotels.count
        {
            objectsArray1.append(nameofhotels[i] as! String)
        }
        
        var keysArray1 = [distanceofhotels[0]]
        for j in 1 ..< distanceofhotels.count
        {
            
            keysArray1.append(distanceofhotels[j])
            
        }
        
        var response1 = Dictionary<String, Double>()
        
        response1=NSDictionary(objects: keysArray1, forKeys: objectsArray1 as [NSCopying]) as! Dictionary<String, Double>
        
        let byValue = {
            (elem1:(key: String, val: Double), elem2:(key: String, val: Double))->Bool in
            if elem1.val < elem2.val {
                return true
            } else {
                return false
            }
        }
        let sortedDict = response1.sorted(by: byValue)
        sorteddictarray = response1
        
        for m in 0 ..< sortedDict.count
        {
            
            nameofhotelssorted.add(sortedDict[m].0)
            
        }
        self.check1()
    }
    
    func check1()
    {
        
        if(position1<countofhotel)
        {
            
            let name = nameofhotelssorted[position1]
            print(name)
            if((dictionaryoffacebookid.object(forKey: name)) != nil && facebooknum == 1)
            {
                for i in sorteddictarray
                {
                    if((i.0) == name as! String)
                    {
                        let dis1 = i.1 as Double
                        
                        let kilometers = dis1 / 1000.0
                        
                        let miles = kilometers * 0.62137
                        
                        var string1=String(miles)
                        
                        if(miles<10)
                        {
                            string1 = string1.substring(to: string1.characters.index(string1.startIndex, offsetBy: 3))
                        }
                        else if(miles>=10 && miles<100)
                        {
                            string1 = string1.substring(to: string1.characters.index(string1.startIndex, offsetBy: 4))
                        }
                        else
                        {
                            string1 = string1.substring(to: string1.characters.index(string1.startIndex, offsetBy: 5))
                        }
                        
                        distancetoshowongrid.add(string1)
                    }
                }
                
                hotelnamearr.add(name)
                let facebookname1 = (dictionaryoffacebookid.object(forKey: name)) as! NSNumber
                let facebookname2 = String(describing: facebookname1)
                print(facebookname2)
                twitterimage("",facebookid: facebookname2)
            }
                
            else if((dictionaryoftwitterusername.object(forKey: name)) != nil && twitternum == 1)
            {
                
                for i in sorteddictarray
                {
                    if((i.0) == name as! String)
                    {
                        let dis1 = i.1 as Double
                        let kilometers = dis1 / 1000.0
                        
                        let miles = kilometers * 0.62137
                        
                        var string1=String(miles)
                        
                        if(miles<10)
                        {
                            string1 = string1.substring(to: string1.characters.index(string1.startIndex, offsetBy: 3))
                        }
                        else if(miles>=10 && miles<100)
                        {
                            string1 = string1.substring(to: string1.characters.index(string1.startIndex, offsetBy: 4))
                        }
                        else
                        {
                            string1 = string1.substring(to: string1.characters.index(string1.startIndex, offsetBy: 5))
                        }
                        
                        distancetoshowongrid.add(string1)
                    }
                    
                }
                
                hotelnamearr.add(name)
                let twittername1 = (dictionaryoftwitterusername.object(forKey: name)) as! String
                print(twittername1)
                twitterimage(twittername1,facebookid: "")
            }
                
            else if((dictionaryofinstagramid.object(forKey: name)) != nil && instagramnum == 1)
            {
                
                for i in sorteddictarray
                {
                    if((i.0) == name as! String)
                    {
                        let dis1 = i.1 as Double
                        let kilometers = dis1 / 1000.0
                        
                        let miles = kilometers * 0.62137
                        
                        var string1=String(miles)
                        if(miles<10)
                        {
                            string1 = string1.substring(to: string1.characters.index(string1.startIndex, offsetBy: 3))
                        }
                        else if(miles>=10 && miles<100)
                        {
                            string1 = string1.substring(to: string1.characters.index(string1.startIndex, offsetBy: 4))
                        }
                        else
                        {
                            string1 = string1.substring(to: string1.characters.index(string1.startIndex, offsetBy: 5))
                        }
                        
                        distancetoshowongrid.add(string1)
                    }
                }
                hotelnamearr.add(name)
                let instaid1 = (dictionaryofinstagramid.object(forKey: name)) as! NSNumber
                let instaid2 = String(describing: instaid1)
                if self.accesstokenInstagram != "" {
                    json(instaid2 as NSString)
                } else {
                    let ref = Database.database().reference()
                    ref.child("Users/instaUsers/\(instaid2)/picture").observeSingleEvent(of: DataEventType.value, with: { (snap) in
                        if let pic = snap.value, !(pic is NSNull) {
                            
                            //Set Profile URL
                            let url1 = URL(string: pic as! String)
                            
                            let img=try? Data(contentsOf: url1!)
                            
                            var imageof = UIImage()
                            
                            if(img == nil)
                            {
                                imageof = UIImage(named: "NoImage")!
                                
                                self.imagearray1.add(imageof)
                                
                                self.position1 += 1
                                self.instagramnum=1
                                self.twitternum=1
                                self.facebooknum=1
                                self.check1()
                            }
                            else
                            {
                                imageof = UIImage(data: img!)!
                                
                                self.imagearray1.add(imageof)
                                
                                self.position1 += 1
                                self.instagramnum=1
                                self.twitternum=1
                                self.facebooknum=1
                                self.check1()
                                
                            }
                        } else {
                            self.json(instaid2 as NSString)
                        }
                    })
                }
            }
            else
            {
                position1 += 1
                self.check1()
            }
        }
        else
        {
            if (UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad)
            {
                countofhotel = countofhotel + 35
            }
            else
            {
                countofhotel = countofhotel + 30
            }
            countoffooter=1
        }
    }
    
    
    override func didReceiveMemoryWarning()
    {
        
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return imagearray1.count
    }
    
    // make a cell for each cell index path
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        
        // get a reference to our storyboard cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "gridcell", for: indexPath) as! CollectionViewCell
        
        cell.image_view.image=imagearray1[indexPath.row] as? UIImage
        cell.namelabel.text=hotelnamearr[indexPath.row] as? String
        
        let distancestring = distancetoshowongrid[indexPath.row] as! String
        cell.distancelabel.text = "\(distancestring) Miles"
        
        if (UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad)
        {
            cell.distancelabel.font=cell.distancelabel.font.withSize(13)
            cell.namelabel.font = cell.namelabel.font.withSize(13)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath)
    {
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        
        let deviceSize = UIScreen.main.bounds.size
        
        var cellWidth = CGFloat()
        
        var cellHeight = CGFloat()
        
        if (UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad)
        {
            cellWidth = ((deviceSize.width / 5) - 6)
            cellHeight = cellWidth
        }
        else
        {
            cellWidth = ((deviceSize.width / 3) - 3)
            cellHeight=cellWidth
        }
        cell_height = cellHeight
        return CGSize(width: cellWidth , height: cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        
        let cellof = collection_view.cellForItem(at: indexPath) as! CollectionViewCell
        
        let nameofstring = cellof.namelabel.text
        let obj = self.storyboard!.instantiateViewController(withIdentifier: "feedvc") as! FeedVC
        obj.restaurantlabelname=nameofstring! as NSString
        obj.instagramiddict = dictionaryofinstagramid
        obj.facebookuserdict = dictionaryoffacebookid
        obj.twitteruserdict = dictionaryoftwitterusername
        obj.accesstokenofFB = self.accesstokenFB
        obj.profileImage = cellof.image_view.image!
        obj.instagramTokenValid = self.instagramAccessTokenValid
        obj.dictionaryinstagramusername = self.dictionaryforinstagramusername
        self.navigationController?.pushViewController(obj, animated: true)
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize
    {
        if((footerhidden1==1)&&(footerhidden2==1))
        {
            return CGSize(width: self.view.frame.size.width, height: 0)
        }
        if (UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad)
        {
            return CGSize(width: self.view.frame.size.width, height: 0)
        }
        return CGSize(width: self.view.frame.size.width, height: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView
    {
        
        if kind == UICollectionElementKindSectionHeader {
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "header", for: indexPath)
            
            return header
            
        } else {
            
            let footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "footer1", for: indexPath)
            
            if(countoffooter == 0)
            {
                footer.isHidden = true
            }
            else
            {
                footer.isHidden = false
            }
            
            return footer
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView)
    {
        
        if (self.collection_view.contentOffset.y >= self.collection_view.contentSize.height - cell_height - self.view.frame.size.height)
        {
            
            if(countoffooter != 0) {
                if(self.collection_view.contentSize.height - cell_height - self.view.frame.size.height > 0) {
                    self.collection_view.contentOffset = CGPoint(x: self.collection_view.contentOffset.x, y: self.collection_view.contentSize.height - cell_height - self.view.frame.size.height)
                }
                
                if(self.loadmorebutton.isHidden == true) {
                    self.loadmorebutton.isHidden = false
                }
            }
        }
    }
    @IBAction func logoutAction(_ sender: UIButton) {
        
        let alertView = UIAlertController(title: "Warning", message: "Are you sure want to Logout?", preferredStyle: .alert)
        
        alertView.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action -> Void in
            
            let loginManager: FBSDKLoginManager = FBSDKLoginManager()
            loginManager.logOut()
            
            FHSTwitterEngine .shared() .clearAccessToken()
            
            UserDefaults.standard.setValue("", forKey:"instagramtoken")
            UserDefaults.standard.removeObject(forKey: "userUrl")
            self.navigationController?.popToRootViewController(animated: true)
        }))
        
        alertView.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        
        present(alertView, animated: true, completion: nil)
    }
    
    func json(_ userid:NSString)
    {
        
        let jsonUrlPath="https://api.instagram.com/v1/users/\(userid)/?access_token=\(self.accesstokenInstagram)"
        
        let url:URL = URL(string: jsonUrlPath)!
        
        let session  = URLSession.shared
        
        let task = session.dataTask(with: url, completionHandler: {data,response,error -> Void in
            if error != nil
            {
                print(error!.localizedDescription)
                return
            }
            
            let err:NSError?
            
            do
            {
                self.itemsdict = try JSONSerialization.jsonObject(with: data! , options: JSONSerialization.ReadingOptions.mutableContainers) as! NSMutableDictionary
                
                if(self.accesstokenInstagram == "")
                {
                    var imgof = UIImage()
                    
                    imgof=UIImage(named: "NoImage")!
                    
                    self.imagearray1.add(imgof)
                    
                    self.position1 += 1
                    self.instagramnum=1
                    self.twitternum=1
                    self.facebooknum=1
                    self.check1()
                    
                } else if(self.itemsdict.value(forKey: "data") == nil) {
                    
                    var imgof = UIImage()
                    
                    imgof=UIImage(named: "NoImage")!
                    
                    self.imagearray1.add(imgof)
                    
                    self.position1 += 1
                    self.instagramnum=1
                    self.twitternum=1
                    self.facebooknum=1
                    self.check1()
                }
                else
                {
                    self.instaimgurl=((self.itemsdict.value(forKey: "data") as AnyObject).value(forKey: "profile_picture"))! as! NSString
                    
                    let url1 = URL(string: self.instaimgurl as String)
                    
                    let img=try? Data(contentsOf: url1!)
                    
                    var imageof = UIImage()
                    
                    if(img == nil)
                    {
                        imageof = UIImage(named: "NoImage")!
                        
                        self.imagearray1.add(imageof)
                        
                        self.position1 += 1
                        self.instagramnum=1
                        self.twitternum=1
                        self.facebooknum=1
                        self.check1()
                    }
                    else
                    {
                        imageof = UIImage(data: img!)!
                        
                        self.imagearray1.add(imageof)
                        
                        self.position1 += 1
                        self.instagramnum=1
                        self.twitternum=1
                        self.facebooknum=1
                        self.check1()
                        
                    }
                    
                }
                
            } catch _
            {
                print("error ")
            }
            
            DispatchQueue.main.async(execute: {
                
                self.collection_view.reloadData()
                
            })
            
        })
        
        task.resume()
        
    }
    @IBAction func loadMoreAction(_ sender: UIButton) {
        self.instagramnum=1
        self.twitternum=1
        self.facebooknum=1
        
        countoffooter = 0
        self.loadmorebutton.isHidden = true
        
        check1()
    }
    
    @IBAction func loadmorebutton(_ sender: AnyObject)
    {
        
        self.instagramnum=1
        self.twitternum=1
        self.facebooknum=1
        
        countoffooter = 0
        
        self.collection_view.reloadData()
        
        check1()
        
    }
    
    func twitterimage(_ username: String,facebookid: String)
    {
        
        var image_url = URL(string:"")
        if(facebookid == "")
        {
            image_url = URL(string: "https://twitter.com/\(username)/profile_image?size=original")!
        }
        if(username == "")
        {
            image_url = URL(string: "https://graph.facebook.com/\(facebookid)/picture?type=large")!
        }
        
        let priority = DispatchQueue.GlobalQueuePriority.default
        DispatchQueue.global(priority: priority).async {
            // do some task
            
            var image = UIImage()
            
            let image_data = try? Data(contentsOf: image_url!)
            
            let name1 = self.nameofhotelssorted[self.position1]
            
            if(image_data == nil)
            {
                if(username == "")
                {
                    if((self.dictionaryoftwitterusername.object(forKey: name1)) != nil)
                    {
                        self.instagramnum=0
                        self.twitternum=1
                        self.facebooknum=0
                        self.check1()
                    } else if((self.dictionaryofinstagramid.object(forKey: name1)) != nil)
                    {
                        self.instagramnum=1
                        self.twitternum=0
                        self.facebooknum=0
                        self.check1()
                    } else
                    {
                        image = UIImage(named: "NoImage")!
                        self.imagearray1.add(image)
                        
                        self.instagramnum=1
                        self.twitternum=1
                        self.facebooknum=1
                        self.position1 += 1
                        self.check1()
                    }
                } else {
                    if((self.dictionaryofinstagramid.object(forKey: name1)) != nil)
                    {
                        self.instagramnum=1
                        self.twitternum=0
                        self.facebooknum=0
                        self.check1()
                    } else
                    {
                        image = UIImage(named: "NoImage")!
                        self.imagearray1.add(image)
                        
                        self.instagramnum=1
                        self.twitternum=1
                        self.facebooknum=1
                        self.position1 += 1
                        self.check1()
                    }
                }
            }
            else
            {
                image = UIImage(data: image_data!)!
                self.imagearray1.add(image)
                self.instagramnum=1
                self.twitternum=1
                self.facebooknum=1
                self.position1 += 1
                self.check1()
            }
            
            DispatchQueue.main.async {
                // update some UI
                self.collection_view.reloadData()
            }
        }
    }
    
    @IBAction func btnProfileTap(sender:UIButton) {
        let profileVC = self.storyboard!.instantiateViewController(withIdentifier: "ProfileVC") as! ProfileVC
        self.navigationController?.pushViewController(profileVC, animated: true)
    }
    
    @IBAction func demobutton(_ sender: AnyObject)
    {
        
    }
    func facebookaccess()
    {
        
        let jsonUrlPath = "https://graph.facebook.com/oauth/access_token?client_id=1677242839265376&client_secret=7c859a470d314b04ba7e72eb4be33163&grant_type=client_credentials"
        
        let url:URL = URL(string: jsonUrlPath)!
        
        let session  = URLSession.shared
        
        let task = session.dataTask(with: url, completionHandler: {data,response,error -> Void in
            if error != nil
            {
                print(error!.localizedDescription)
                return;
            }
            
            do
            {
                let respnse = try JSONSerialization.jsonObject(with: data! , options: JSONSerialization.ReadingOptions.mutableContainers) as! NSMutableDictionary
                self.accesstokenFB = respnse.value(forKey: "access_token") as! String
            }
            catch _
            {
                print("error ")
            }
            
            
            DispatchQueue.main.async(execute: {
                
            })
            
        })
        
        task.resume()
        
    }
    func AccessTokenInstagram() {
        
        let jsonUrlPath = "https://api.instagram.com/oauth/authorize/?client_id=0770d11b6b624bd580e6d8dcb5f1d213&redirect_uri=https://www.google.co.in&response_type=token"
        
        
        guard let requestUrl = Foundation.URL(string:jsonUrlPath) else { return }
        var request = URLRequest(url:requestUrl)
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) {
            (data, response, error) in
            let URLString = response!.url!.absoluteString
            
            if (URLString as NSString).range(of: "access_token=").location != NSNotFound {
                let accessToken = URLString.components(separatedBy: "=").last!
                self.accesstokenInstagram = accessToken
            }

            self.check1()
            if error != nil
            {
                print(error!.localizedDescription)
            }
            
            DispatchQueue.main.async(execute: {
                
            })
        }
        
        task.resume()
    }
    
    //MARK: Function to Check Validity of Instagram Access Token
    
    func instagramAccessTokenValidity() {
        let jsonUrlPath="https://api.instagram.com/v1/users/12345678/?access_token=\(self.accesstokenInstagram)"
        
        let url:URL = URL(string: jsonUrlPath)!
        
        let session  = URLSession.shared
        
        let task = session.dataTask(with: url, completionHandler: {data,response,error -> Void in
            if error != nil
            {
                print(error!.localizedDescription)
            }
            
            do
            {
                let response = try JSONSerialization.jsonObject(with: data! , options: JSONSerialization.ReadingOptions.mutableContainers) as! NSMutableDictionary
                
                
                if(response.value(forKey: "data") == nil) {
                    let errormessage = (response.value(forKey: "meta") as AnyObject).value(forKey: "error_message") as! String
                    
                    if(errormessage == "The access_token provided is invalid."){
                        self.instagramAccessTokenValid = "Invalid"
                    } else {
                        self.instagramAccessTokenValid = "Valid"
                    }
                } else {
                    self.instagramAccessTokenValid = "Valid"
                }
                
            } catch _
            {
                print("error ")
            }
            
            DispatchQueue.main.async(execute: {
                
            })
            
        })
        
        task.resume()
    }
}
