//
//  ViewController.swift
//  Find Friendz
//
//  Created by Mesut Yılmaz on 15.05.2016.
//  Copyright © 2016 Mesut Yılmaz. All rights reserved.
//

import UIKit
import Parse


class ViewController: UIViewController {
    
    @IBAction func girisYap(sender: UIButton) {
        
        PFUser.logInWithUsernameInBackground(kAdiTextField.text!, password: sifreTextField.text!) { (user, error) in
            
            if let loggedinUser = user {
                
                // Kullanıcı nil değil
                print("başarılı")
                
            }else {
                // Kullanıcı nil ,error parametresine bak !
            }
        }
        
    }
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        kAdiTextField.resignFirstResponder()
        sifreTextField.resignFirstResponder()
    
    }

    @IBAction func kayıtButton(sender: UIButton) {
        
        /*print("tapped")
        
        let user = PFUser()
        user.username = kAdiTextField.text!
        user.password = sifreTextField.text!
        user.signUpInBackgroundWithBlock { (result, error) in
            if error == nil && result == true {
                // Kullanıcı başarı ile oluşturuldu
            
            }else {
                // hata mesajınının sebebi !
            }
            
        }
        */
    }
    @IBOutlet weak var sifreTextField: UITextField!
    @IBOutlet weak var kAdiTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

