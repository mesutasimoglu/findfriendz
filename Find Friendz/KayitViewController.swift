//
//  KayitViewController.swift
//  Find Friendz
//
//  Created by Mesut Yılmaz on 15.05.2016.
//  Copyright © 2016 Mesut Yılmaz. All rights reserved.
//

import UIKit
import Parse
class KayitViewController: UIViewController {
    
    
   
    @IBOutlet weak var kayitAd: UITextField!
    @IBOutlet weak var kayitSifre: UITextField!
    @IBOutlet weak var email: UITextField!
    
    @IBAction func kayit(sender: UIButton) {
        
        
        let user = PFUser()
        user.username = kayitAd.text!
        user.password = kayitSifre.text!
        user.email = email.text!
        
        
        
        user.signUpInBackgroundWithBlock { (result, error) in
            
            if error == nil && result == true {
                // İşlem tamam
                let alert = UIAlertController(title: "FIND FRIEND", message: "KAYIT BASARILI", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "TESEKKÜRLER", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)

                
                
            }
            else {
                //Hatalar hatalar
            }
        }
        
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "homePage"  {
            
            PFUser.logOut()
            print(PFUser.currentUser()?.username)
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
