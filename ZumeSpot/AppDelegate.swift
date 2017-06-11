
import UIKit
import Firebase
import FBSDKCoreKit
import FBSDKShareKit


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate
{
    
    var window: UIWindow?
    let INSTAGRAM_AUTHURL = "https://api.instagram.com/oauth/authorize/"
    let INSTAGRAM_APIURl =  "https://api.instagram.com/v1/users/"
    let INSTAGRAM_CLIENT_ID = "42a1a7203338418d8c533df07a78737f"
    let INSTAGRAM_CLIENTSERCRET = "05c59ded562c4ac0b82a76dbd70c3fe1"
    let INSTAGRAM_REDIRECT_URI = "http://www.brihaspatitech.com"
    let INSTAGRAM_ACCESS_TOKEN = "access_token"
    let INSTAGRAM_SCOPE = "likes+comments+public_content+follower_list"
    
    var instagramvariable=0
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool{
        
        
        FirebaseApp.configure()
        
        // Override point for customization after application launch.
        FBSDKButton.classForCoder()
        
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        FHSTwitterEngine.shared().permanentlySetConsumerKey("KOKRbwhZuqnTbr2AUC3ESxl2D", andSecret: "82cPIuPjpLMxrNp4nlXG0XSa3SNorbKSis9ZkQysxMfeVrszJX")
        
        FHSTwitterEngine.shared().loadAccessToken()
        
        if(UserDefaults.standard.value(forKey: "instagramtoken") == nil){
            UserDefaults.standard.setValue("", forKey:"instagramtoken")
        }
        
        if(UserDefaults.standard.value(forKey: "twitterhashtagposts") == nil){
            UserDefaults.standard.setValue([], forKey:"twitterhashtagposts")
        }
        UserDefaults.standard.synchronize()
        
        let accesstokenInstagram = UserDefaults.standard.value(forKey: "instagramtoken") as! String
        
        if(FBSDKAccessToken.current() != nil)
        {
            print("facebook logged in")
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            
            let walkthroughVC = storyboard.instantiateViewController(withIdentifier: "gridvc") as! GridVC
            
            let navigationController = self.window?.rootViewController as! UINavigationController
            
            navigationController.pushViewController(walkthroughVC, animated: false)
            
        } else if(FHSTwitterEngine.shared().accessToken.key != nil)
        {
            print("twitter logged in")
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            
            let walkthroughVC = storyboard.instantiateViewController(withIdentifier: "gridvc") as! GridVC
            
            let navigationController = self.window?.rootViewController as! UINavigationController
            
            navigationController.pushViewController(walkthroughVC, animated: false)
        } else if(accesstokenInstagram != "") {
            
            UserDefaults.standard.set(true, forKey: "showindicator")
            UserDefaults.standard.synchronize()
            
            instagramAccessTokenValidity({ (isSuccess) -> Void in
                if(isSuccess == true) {
                    print("Instagram logged in")
                    
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    
                    let walkthroughVC = storyboard.instantiateViewController(withIdentifier: "gridvc") as! GridVC
                    
                    let navigationController = self.window?.rootViewController as! UINavigationController
                    DispatchQueue.main.async(execute: {
                        navigationController.pushViewController(walkthroughVC, animated: false)
                    })
                    
                } else {
                    
                }
            })
            
        }
        
        return FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool
    {
        if (FBSDKApplicationDelegate.sharedInstance() != nil)
        {
            return FBSDKApplicationDelegate.sharedInstance().application(application, open: url, sourceApplication: sourceApplication, annotation: annotation)
        }
        
        return true
    }
    func applicationWillResignActive(_ application: UIApplication)
    {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
        
    }
    
    func applicationDidEnterBackground(_ application: UIApplication)
    {
        
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        
    }
    
    func applicationWillEnterForeground(_ application: UIApplication)
    {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
        
    }
    
    func applicationDidBecomeActive(_ application: UIApplication)
    {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        FBSDKAppEvents.activateApp()
    }
    
    func applicationWillTerminate(_ application: UIApplication)
    {
        
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        //        let loginManager: FBSDKLoginManager = FBSDKLoginManager()
        //        loginManager.logOut()
        
    }
    func instagramAccessTokenValidity(_ finished: @escaping ((_ isSuccess: Bool)->Void)) {
        
        let accesstokenInstagram = UserDefaults.standard.value(forKey: "instagramtoken") as! String
        
        let jsonUrlPath="https://api.instagram.com/v1/users/12345678/?access_token=\(accesstokenInstagram)"
        
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
                        
                        finished(false)
                    } else {
                        
                        finished(true)
                    }
                    
                } else {
                    
                    finished(true)
                }
                
            } catch _
            {
                print("error ")
            }
            
        })
        
        task.resume()
        
    }
    
}

