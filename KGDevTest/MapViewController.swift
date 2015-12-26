//
//  MapViewController.swift
//  KGDevTest
//
//  Created by Nisal Perera on 2015-12-26.
//  Copyright © 2015 Nisal Perera. All rights reserved.
//

import UIKit
import MapKit
import Alamofire
import SwiftyJSON

class MapViewController: UIViewController , MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    
    var points = Array<Point>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set initial location in Honolulu
        let initialLocation = CLLocation(latitude: 43.645113, longitude: -79.396137)
        centerMapOnLocation(initialLocation)
        
        getPoints()
        mapView.delegate = self
    }
    
    func getPoints(){
        // This function returns immediately: The request happens on a
        // background thread
        
        Alamofire.request(.GET, "http://ios.kg-dev.com/api/photos/points.json").response {
            (request: NSURLRequest?, response: NSHTTPURLResponse?, data: NSData?, error: NSError?) -> Void in
            if let data = data {
                // Interpret data (which is NSData) as a JSON object
                let json = JSON(data: data)
                
                //print(json)
                
                if let items = json["result"].array {
                    for item in items {
                        let coordinate = CLLocationCoordinate2D(latitude: item["latitude"].double!, longitude: item["longitude"].double!)
                        let tempPoint = Point(title: item["title"].string!,locationName: item["description"].string!,thumbUrl: item["thumb"].string!,imageUrl: item["image"].string!,coordinate: coordinate)
                        self.points.append(tempPoint)
                        
                    }
                }
                
                // Make sure we refresh the table view on the main thread
                dispatch_async(dispatch_get_main_queue()) {
                    self.mapView.addAnnotations(self.points)
                }
            }
        }
    }
    
    let regionRadius: CLLocationDistance = 1000
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
            regionRadius * 2.0, regionRadius * 2.0)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        
        if annotation is MKUserLocation {
            //return nil so map view draws "blue dot" for standard user location
            return nil
        }
        
        var pinView = mapView.dequeueReusableAnnotationViewWithIdentifier("pin")
        
        if pinView == nil {
            pinView = MKAnnotationView(annotation: annotation, reuseIdentifier: "pin")
            pinView!.canShowCallout = true
            
            // Add image to left callout
            var urlPath : String!
            urlPath = "images/thumb1.png"
            
            let imageURL:String! = "http://ios.kg-dev.com/api/photos/\(urlPath)"
            
            Alamofire.request(.GET, imageURL).response {
                (request: NSURLRequest?, response: NSHTTPURLResponse?, data: NSData?, error: NSError?) -> Void in
                
                if let data = data {
                    let image =  UIImage(data: data as NSData)
                    pinView!.image = image
                }
            }
            
                        // Add detail button to right callout
            //var calloutButton = UIButton.buttonWithType(.DetailDisclosure) as UIButton
            //pinView!.rightCalloutAccessoryView = calloutButton
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
        
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
