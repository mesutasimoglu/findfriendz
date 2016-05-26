//
//  TableViewController.swift
//  Find Friendz
//
//  Created by Mesut Yılmaz on 15.05.2016.
//  Copyright © 2016 Mesut Yılmaz. All rights reserved.
//

import UIKit
import Parse
import MapKit

class TableViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,CLLocationManagerDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    
    var usernames = [String]()
    var locations = [CLLocationCoordinate2D]()
    var distances = [CLLocationDistance]()
    
    var locationManager:CLLocationManager!
    
    var latitude: CLLocationDegrees = 0
    var longitude: CLLocationDegrees = 0
    

    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
    

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return usernames.count
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let  cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        
        let distanceDouble = Double(distances[indexPath.row])
        
        let roundedDistance = Double(round(distanceDouble * 10) / 10)
        
        cell.textLabel?.text = usernames[indexPath.row] + " - " + String(roundedDistance) + "km uzaklıkta"
        
        return cell
        
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        
    }
    
    
    
  
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "logout"  {
            
            PFUser.logOut()
            print(PFUser.currentUser()?.username)
        
        }   else if segue.identifier == "tableCell" {
            
            
            
            if let destination = segue.destinationViewController as? LocationViewController {
                
                destination.requestLocation = locations[(tableView.indexPathForSelectedRow?.row)!]
                destination.requestUsername = usernames[(tableView.indexPathForSelectedRow?.row)!]
                
            }
            
            
            
        }
            
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        
        let location:CLLocationCoordinate2D = (manager.location?.coordinate)!
        
        self.latitude  = location.latitude
        self.longitude = location.longitude
        
       // print("Locations = \(location.latitude) \(location.longitude)")
        
        let userQuery = PFQuery(className: "_User")
        userQuery.whereKey("location", nearGeoPoint: PFGeoPoint(latitude: location.latitude, longitude: location.longitude))
        userQuery.limit = 10
        userQuery.findObjectsInBackgroundWithBlock { (objects:[PFObject]?, error :NSError?) in
            
            if let objects = objects as? [PFUser]{
                
                
                self.usernames.removeAll()
                self.locations.removeAll()
                
                for object in objects {
                    
                    if object["friend"] == nil {
                        
                    
                    if let username = object["username"] as?  String {
                        self.usernames.append(username)
                    }
                    
                    if let returnedLocation = object["location"] as? PFGeoPoint {
                        
                        
                        let requestLocation = CLLocationCoordinate2DMake(returnedLocation.latitude, returnedLocation.longitude)
                    
                        self.locations.append(requestLocation)
                        
                        let requestCLLocation =  CLLocation(latitude: requestLocation.latitude, longitude: requestLocation.longitude)
                        let friendCLLocation = CLLocation(latitude: location.latitude, longitude: location.longitude)
                        
                        let distance = friendCLLocation.distanceFromLocation(requestCLLocation)
                        
                        self.distances.append(distance/1000)
                        

                    }
                        
                    }
                    
                }
                self.tableView.reloadData()
              //  print(self.locations)
              //  print(self.usernames)
                
            } else {
                print(error)
            }

        }

    }


}
