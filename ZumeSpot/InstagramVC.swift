//
//  InstagramVC.swift
//  ZumeSpot
//


import UIKit

class InstagramVC: UIViewController, UIWebViewDelegate{
    
    
    var namearray=NSMutableArray()
    
    let appdele=AppDelegate()
    
    @IBOutlet weak var web_view: UIWebView!
    
    var kBaseURL = "https://instagram.com/"
    var kAuthenticationURL="oauth/authorize/?client_id=%@&redirect_uri=%@&response_type=token&scope=likes+comments+basic"
    var kClientID = "42a1a7203338418d8c533df07a78737f"
    //  var kRedirectURI="http://dev1.businessprodemo.com/Slipperyslickproductions/php/"
    var kRedirectURI="http://www.brihaspatitech.com"
    var kAccessToken="access_token"
    var typeOfAuthentication = ""
    
    var sorteddistance=[AnyObject]()
    
    var pushFromPostScreen = String()
    
    @IBOutlet weak var backbutton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func BackButton(_ sender: UIButton) {
        ActivityIndicator.current().hide()
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool)
    {UIApplication.shared.isStatusBarHidden = true
        
        var authURL: String? = nil
        if (typeOfAuthentication == "UNSIGNED") {
            authURL = "\(appdele.INSTAGRAM_AUTHURL)?client_id=\(appdele.INSTAGRAM_CLIENT_ID)&redirect_uri=\(appdele.INSTAGRAM_REDIRECT_URI)&response_type=token&scope=\(appdele.INSTAGRAM_SCOPE)&DEBUG=True"
        }
        else {
            authURL = "\(appdele.INSTAGRAM_AUTHURL)?client_id=\(appdele.INSTAGRAM_CLIENT_ID)&redirect_uri=\(appdele.INSTAGRAM_REDIRECT_URI)&response_type=code&scope=\(appdele.INSTAGRAM_SCOPE)&DEBUG=True"
        }
        web_view.loadRequest(URLRequest(url: URL(string: authURL!)!))
        web_view.delegate = self
    }
    
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool
    {
        //        let urlString = request.URL!.absoluteString
        //        let Url = request.URL!
        //        let UrlParts = Url.pathComponents!
        //        if UrlParts.count == 1 {
        //            let tokenParam = (urlString as NSString).rangeOfString(kAccessToken)
        //            if tokenParam.location != NSNotFound {
        //                var token = urlString.substringFromIndex(urlString.startIndex.advancedBy(NSMaxRange(tokenParam)))
        //                // If there are more args, don't include them in the token:
        //                let endRange = (token as NSString).rangeOfString("&")
        //                if endRange.location != NSNotFound {
        //                    token = token.substringToIndex(token.startIndex.advancedBy(endRange.location))
        //                }
        //                if token.characters.count > 0 {
        //                    // call the method to fetch the user's Instagram info using access token
        //                   // gAppData.getUserInstagramWithAccessToken(token)
        //                }
        //            }
        //            else {
        //                print("rejected case, user denied request")
        //            }
        //            return false
        //        }
        return self.checkRequestForCallbackURL(request)
        
        
    }
    
    func webViewDidStartLoad(_ webView: UIWebView) {
        ActivityIndicator.current().show()
        web_view.layer.removeAllAnimations()
        web_view.isUserInteractionEnabled = false
        UIView.animate(withDuration: 0.1, animations: {() -> Void in
            //  loginWebView.alpha = 0.2;
        })
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        ActivityIndicator.current().hide()
        web_view.layer.removeAllAnimations()
        web_view.isUserInteractionEnabled = true
        UIView.animate(withDuration: 0.1, animations: {() -> Void in
            //loginWebView.alpha = 1.0;
        })
    }
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        //        print("Code : %d \nError : %@", error!.code, error!.description)
        //        //Error : Error Domain=WebKitErrorDomain Code=102 "Frame load interrupted"
        //        if error!.code == 102 {
        //            return
        //        }
        //        if error!.code == -1009 || error!.code == -1005 {
        //            //        _completion(kNetworkFail,kPleaseCheckYourInternetConnection);
        //        }
        //        else {
        //            //        _completion(kError,error.description);
        //        }
        //      //  UIUtils.networkFailureMessage()
        self.webViewDidFinishLoad(webView)
        
    }
    
    
    func checkRequestForCallbackURL(_ request: URLRequest) -> Bool {
        let urlString = request.url!.absoluteString
        if (typeOfAuthentication == "UNSIGNED") {
            // check, if auth was succesfull (check for redirect URL)
            if urlString.hasPrefix(appdele.INSTAGRAM_REDIRECT_URI) {
                // extract and handle access token
                let range = (urlString as NSString).range(of: "#access_token=")
                self.handleAuth(urlString.substring(from: urlString.characters.index(urlString.startIndex, offsetBy: range.location + range.length)))
                return false
            }
        }
        else {
            print(appdele.INSTAGRAM_REDIRECT_URI)
            print(urlString)
            if urlString.hasPrefix(appdele.INSTAGRAM_REDIRECT_URI) {
                // extract and handle access token
                let range = (urlString as NSString).range(of: "code=")
                self.makePostRequest(urlString.substring(from: urlString.characters.index(urlString.startIndex, offsetBy: range.location + range.length)))
                return false
            }
        }
        return true
    }
    
    func makePostRequest(_ code: String)
    {
        
        let post = "client_id=\(appdele.INSTAGRAM_CLIENT_ID)&client_secret=\(appdele.INSTAGRAM_CLIENTSERCRET)&grant_type=authorization_code&redirect_uri=\(appdele.INSTAGRAM_REDIRECT_URI)&code=\(code)"
        let postData = post.data(using: String.Encoding.ascii, allowLossyConversion: true)!
        let postLength = "\(UInt(postData.count))"
        let requestData = NSMutableURLRequest(url: URL(string: "https://api.instagram.com/oauth/access_token")!)
        requestData.httpMethod = "POST"
        requestData.setValue(postLength, forHTTPHeaderField: "Content-Length")
        requestData.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        requestData.httpBody = postData
        
        // var response: NSURLResponse? = nil
        //var responseData = try! NSURLConnection.sendSynchronousRequest(requestData, returningResponse: response)!
        var urldata=Data()
        var requestError: NSError? = nil
        let response : AutoreleasingUnsafeMutablePointer<URLResponse?>? = nil
        do{
            let urlData = try NSURLConnection.sendSynchronousRequest(requestData as URLRequest, returning: response)
            urldata=urlData
            print(urlData)
        }
        catch (let e) {
            print(e)
        }
        let dict = try! JSONSerialization.jsonObject(with: urldata, options: JSONSerialization.ReadingOptions.allowFragments)
        print(dict)
        self.handleAuth(((dict as AnyObject).value(forKey: "access_token") as! String))
        
    }
    func handleAuth(_ authToken: String)
    {
        if(self.pushFromPostScreen == "Yes") {
        UserDefaults.standard.setValue(authToken, forKey: "instagramtoken")
            self.navigationController?.popViewController(animated: false)
        } else {
        print("successfully logged in with Tocken == \(authToken)")
        // self.dismissViewControllerAnimated(true, completion: { _ in })
        // print("permissions of instagram  \(authToken)")
        UserDefaults.standard.setValue(authToken, forKey: "instagramtoken")
        
        let obj = self.storyboard!.instantiateViewController(withIdentifier: "gridvc") as! GridVC
//        obj.namearray=self.namearray
//        obj.sorteddistance1=self.sorteddistance
        //obj.accesstokenInstagram = authToken
        self.navigationController?.pushViewController(obj, animated: true)
        }
    }
}
