//
//  PoitsListController.swift
//  KGDevTest
//
//  Created by Nisal Perera on 2015-12-24.
//  Copyright © 2015 Nisal Perera. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class PoitsListController: UITableViewController {
    
    var points = Array<Point>()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getPoints()
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
                        let tempPoint = Point()
                        tempPoint.pointTitle = item["title"].string!
                        tempPoint.pointDescription = item["description"].string!
                        tempPoint.thumb = item["thumb"].string!
                        tempPoint.image = item["image"].string!
                        tempPoint.latitude = item["latitude"].double!
                        tempPoint.longitude = item["longitude"].double!
                        self.points.append(tempPoint)
                        
                    }
                }
                
                // Make sure we refresh the table view on the main thread
                dispatch_async(dispatch_get_main_queue()) {
                    self.tableView.reloadData()
                }
            }
        }
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // return the number of rows
        return points.count
    }
    
    // automatically adjust the height of the cell
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    override func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("PointViewCell", forIndexPath: indexPath) as! TableViewCell

        // Configure the cell...
        cell.point = points[indexPath.row]

        return cell
    }
    

    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let cell = sender as? UITableViewCell {
            if let indexPath = self.tableView.indexPathForCell(cell) {
                let point = points[indexPath.row]
                let detailController = segue.destinationViewController as! DetailedViewController
                detailController.point = point
            }
        }
    }
    

}
