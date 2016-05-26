//
//  LocationViewController.swift
//  Find Friendz
//
//  Created by Mesut Yılmaz on 16.05.2016.
//  Copyright © 2016 Mesut Yılmaz. All rights reserved.
//

import UIKit
import Parse
import MapKit

class LocationViewController: UIViewController,CLLocationManagerDelegate,MKMapViewDelegate{
    
    
    var usernames = [String]()
    var locations = [CLLocationCoordinate2D]()
    var distances = [CLLocationDistance]()
    var latitude:CLLocationDegrees = 0.0
    var longitute:CLLocationDegrees = 0.0
    
    var requestLocation:CLLocationCoordinate2D = CLLocationCoordinate2DMake(0, 0)
    var requestUsername:String = ""

    
    @IBAction func direction(sender: AnyObject) {
        
        var query = PFQuery(className: "_User")
        query.whereKey("username", equalTo: requestUsername)
        query.findObjectsInBackgroundWithBlock { (objects:[PFObject]?,error: NSError?) in
            
            if error == nil {
                
                if let objects = objects as [PFObject]?{
                    
                    for object in objects {
                        
                       let query = PFQuery(className: "_User")
                        query.getObjectInBackgroundWithId(object.objectId!, block: { (object:PFObject?, error:NSError?) in
                            
                            if error != nil {
                                print(error)
                            }else if let object = object {
                                
                                object["friend"] = PFUser.currentUser()?.username
                                object.saveInBackground()
                                let requestCLLocation =  CLLocation(latitude: self.requestLocation.latitude, longitude: self.requestLocation.longitude)

                                
                                CLGeocoder().reverseGeocodeLocation(requestCLLocation, completionHandler: { (placemarks:
                                    [CLPlacemark]?,error: NSError?) in
                                    
                                    if (error != nil) {
                                        
                                        print("Hata" + (error?.localizedDescription)!)
                                        return
                                    }else {
                                        
                                        if placemarks?.count > 0 {
                                            let pm = placemarks![0] as CLPlacemark
                                            
                                            let mkPm = MKPlacemark(placemark: pm)
                                            
                                            let mapItem = MKMapItem(placemark: mkPm)
                                            
                                            mapItem.name = self.requestUsername
                                            let launchOptions = [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving]
                                            mapItem.openInMapsWithLaunchOptions(launchOptions)

                                        }
                                    }
                                    
                                })
                                
                            }
                            
                            
                        })
                        
                        
                    }
                }
                
            }else {
                print(error)
            }
        }
        

    }
    
    @IBOutlet weak var map: MKMapView!
    
    

    
    var locationManager:CLLocationManager!
    
    
  
    
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        
        let location:CLLocationCoordinate2D = (manager.location?.coordinate)!
        
        self.latitude  = location.latitude
        self.longitute = location.longitude
        
        //print("Locations = \(location.latitude) \(location.longitude)")
        let region = MKCoordinateRegion(center: requestLocation, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        
        self.map.setRegion(region, animated: true)
        
        let objectAnnotation = MKPointAnnotation()
        objectAnnotation.coordinate = requestLocation
        objectAnnotation.title = requestUsername
        self.map.addAnnotation(objectAnnotation)

        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(requestUsername)
        print(requestLocation)
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
       
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

   

}
