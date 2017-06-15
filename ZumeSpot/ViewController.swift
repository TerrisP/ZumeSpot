//  Created by Terris Phillips on 6/4/17.
//  Copyright © 2017 Terris Phillips. All rights reserved.
//


import UIKit
import CoreLocation
import MapKit
import Foundation
import Accounts
import FBSDKCoreKit
import FBSDKLoginKit
import Firebase
import FirebaseAuth



class ViewController: UIViewController,CLLocationManagerDelegate,NSURLConnectionDelegate
{
    
    var dataModel = Data()
    var data = Data()
    var datamodel1 = Data()
    let appdele=AppDelegate()
    var accountStore = ACAccountStore()
    var locationManager = CLLocationManager()
    var cllocat=CLLocation(latitude: 30.709109, longitude: 76.696176)
    
    @IBOutlet var facebookbutton: UIButton!
    @IBOutlet var twitterbutton: UIButton!
    @IBOutlet var instagrambutton: UIButton!
    
    @IBOutlet var demoimage: UIImageView!
    @IBOutlet weak var demofortwitter: UIImageView!
    @IBOutlet weak var demoforfacebookimg: UIImageView!
    @IBOutlet var loginwithtwitterlabel: UILabel!
    
    @IBOutlet var loginwithinstagramlabel: UILabel!
    @IBOutlet var loginwithfblabel: UILabel!
    var latitudearray=NSMutableArray()
    var longitudearray=NSMutableArray()
    var distancearray=NSMutableArray()
    
    var namearray=NSMutableArray()
    var demolatitude=NSMutableArray()
    var demolongitude=NSMutableArray()
    var demoname=NSMutableArray()
    var demoinstagramuserid=NSMutableArray()
    
    var nameofhotels = NSMutableArray()
    var latitudeofhotels = NSMutableArray()
    var longitudeofhotels = NSMutableArray()
    var distanceofhotels = NSMutableArray()
    
    var sorteddistance=[AnyObject]()
    
    var dictionaryofname = NSMutableDictionary()
    var dictionaryofinstagramid = NSMutableDictionary()
    var dictionaryoftwitterusername = NSMutableDictionary()
    var dictionaryoffacebookid = NSMutableDictionary()
    
    var nameofhotelssorted = NSMutableArray()
    
    var imageofimsta = UIImage()
    
    var imagearray = [UIImage]()
    
    var backviewofactivity = UIView()
    
    let engine = FHSTwitterEngine()
    
    var bearerToken = String()
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if (UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad)
        {
            
            loginwithfblabel.font = loginwithfblabel.font.withSize(27)
            loginwithtwitterlabel.font=loginwithtwitterlabel.font.withSize(27)
            loginwithinstagramlabel.font = loginwithinstagramlabel.font.withSize(27)
            
        }
        
        
        //BACK VIEW OF ACTIVITY INDICATOR
        
        let widthofview = self.view.frame.size.width
        let heightofview = self.view.frame.size.height
        backviewofactivity.frame = CGRect(x: 0, y: 0, width: widthofview, height: heightofview)
        backviewofactivity.backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 254/255, alpha: 0.5)
        self.view.addSubview(backviewofactivity)
        
        self.backviewofactivity.isHidden = true
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        
        self.navigationController?.isNavigationBarHidden=true
        
        self.facebookbutton.layer.cornerRadius=5
        self.twitterbutton.layer.cornerRadius=5
        self.instagrambutton.layer.cornerRadius=5
        
        let boolforindicator = UserDefaults.standard.bool(forKey: "showindicator")
        
        if(boolforindicator == true) {
            self.backviewofactivity.isHidden = false
            
            ActivityIndicator.current().show()
        } else {
            
        }
        
    }
    override func viewWillDisappear(_ animated: Bool)
    {
        UserDefaults.standard.set(false, forKey: "showindicator")
        self.backviewofactivity.isHidden = true
        
        ActivityIndicator.current().hide()
    }
    override func didReceiveMemoryWarning()
    {
        
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus)
    {
        
        
    }
    
    @IBAction func facebookAction(_ sender: UIButton) {
        
        FBSDKLoginManager().logIn(withReadPermissions: ["email"], from: self) { (result, err) in
            if err != nil {
                print("Custom FB Login failed:", Error.self)
                return
            }

            self.addUser()
            
            if ((FBSDKAccessToken.current()) != nil)
                            {
                                self.backviewofactivity.isHidden = false
            
                                ActivityIndicator.current().show()
            
                                FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, picture.type(large), email"]).start(completionHandler: { (connection, result, error) -> Void in
            
                                    if (error == nil)
                                    {
            
                                        let obj = self.storyboard!.instantiateViewController(withIdentifier: "gridvc") as! GridVC
                                        self.navigationController?.pushViewController(obj, animated: true)
            
                                        self.backviewofactivity.isHidden = false
            
                                        ActivityIndicator.current().hide()
                                    } else {
            
                                        self.backviewofactivity.isHidden = true
                                        
                                        ActivityIndicator.current().hide()
                                    }
                                    
                        })
                }
        }

}
    
    
    @IBAction func twitteraction(_ sender: AnyObject)
    {
        
        let loginController = FHSTwitterEngine.shared().loginController { (success) -> Void in
            
            let obj = self.storyboard!.instantiateViewController(withIdentifier: "gridvc") as! GridVC
            self.navigationController?.pushViewController(obj, animated: true)
            
            } as UIViewController
        self .present(loginController, animated: true, completion: nil)
        
    }
    
    
    @IBAction func instagramaction(_ sender: AnyObject)
    {
        
        let obj = self.storyboard!.instantiateViewController(withIdentifier: "instagramvc") as! InstagramVC
        self.navigationController?.pushViewController(obj, animated: true)
        
    }
    
    
    
    func addUser() {
        let accessToken = FBSDKAccessToken.current()
        guard let accessTokenString = accessToken?.tokenString else { return }
        
        let credentials = FacebookAuthProvider.credential(withAccessToken: accessTokenString)
        Auth.auth().signIn(with: credentials, completion: { (user, error) in
            if error != nil {
                print("Something went wrong with our FB user: ", error ?? "")
                return
            }
            
            print("Successfully logged in with our user: ", user ?? "")
        })
        
        FBSDKGraphRequest(graphPath: "/me", parameters: ["fields": "id, name, email"]).start { (connection, result, err) in
            
            if err != nil {
                print("Failed to start graph request:", err ?? "")
                return
            }
            print(result ?? "")
        }
    }

    
}
