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
        
        // set initial location and center the map
        let initialLocation = CLLocation(latitude: 43.645113, longitude: -79.396137)
        centerMapOnLocation(initialLocation)
        mapView.showsPointsOfInterest = false
        
        // populate the points array
        getPoints()
        
        // set MapViewController as delegate of MKMapViewDelegate
        mapView.delegate = self
    }
    
    func getPoints(){
        // This function returns immediately: The request happens on a background thread
        Alamofire.request(.GET, "http://ios.kg-dev.com/api/photos/points.json").response {
            (request: NSURLRequest?, response: NSHTTPURLResponse?, data: NSData?, error: NSError?) -> Void in
            if let data = data {
                // Interpret data (which is NSData) as a JSON object
                let json = JSON(data: data)
                
                //print(json)
                
                // parse the JSON response and populate the points array 
                if let items = json["result"].array {
                    for item in items {
                        let coordinate = CLLocationCoordinate2D(latitude: item["latitude"].double!, longitude: item["longitude"].double!)
                        let tempPoint = Point(title: item["title"].string!,locationName: item["description"].string!,thumbUrl: item["thumb"].string!,imageUrl: item["image"].string!,coordinate: coordinate)
                        self.points.append(tempPoint)
                        
                    }
                }
                
                // Make sure we refresh map view on the main thread
                dispatch_async(dispatch_get_main_queue()) {
                    self.mapView.addAnnotations(self.points)
                }
            }
        }
    }
    
    // called at mapView initialization
    let regionRadius: CLLocationDistance = 1000
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
            regionRadius * 2.0, regionRadius * 2.0)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    // MARK: - MKMapViewDelegate functions
    
    //customize the Pin Annotation View
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        
        if annotation is MKUserLocation {
            //return nil so map view draws "blue dot" for standard user location
            return nil
        }
        
        var pinView = mapView.dequeueReusableAnnotationViewWithIdentifier("pin")as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "pin")
            pinView!.canShowCallout = true
            pinView!.animatesDrop = true
            
            // add button to the right callout
            let button = UIButton(type: UIButtonType.DetailDisclosure) as UIButton // button with info sign in it
            pinView?.rightCalloutAccessoryView = button
            
            var urlPath:String = ""
            
            for point in points {
                if (annotation.title! == point.title){
                    urlPath = point.thumbUrl!
                    break;
                }
            }
            
            // Add image to left callout
            let imageURL:String! = "http://ios.kg-dev.com/api/photos/\(urlPath)"
            
            Alamofire.request(.GET, imageURL).response {
                (request: NSURLRequest?, response: NSHTTPURLResponse?, data: NSData?, error: NSError?) -> Void in
                
                if let data = data {
                    let mugIconView = UIImageView(image: UIImage(data: data as NSData))
                    pinView!.leftCalloutAccessoryView = mugIconView
                }
            }
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
    // When user taps on the disclosure button you can perform a segue to navigate to another view controller
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView{
            print(view.annotation!.title) // annotation's title
            
            performSegueWithIdentifier("mapSegue", sender: view)
        }
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if (segue.identifier == "mapSegue" )
        {
            //Perform a segue here to navigate to DetailedViewController
            let senderTitle = (sender as! MKAnnotationView).annotation!.title
            
            // find the point object of the clicked annotation and pass it to DetailedViewController
            for point in points {
                if (senderTitle! == point.title){
                    let detailController = segue.destinationViewController as! DetailedViewController
                    detailController.point = point
                    break;
                }
            }
        }
    }
    

}
