//
//  DetailedViewController.swift
//  KGDevTest
//
//  Created by Nisal Perera on 2015-12-24.
//  Copyright © 2015 Nisal Perera. All rights reserved.
//

import UIKit
import Alamofire

class DetailedViewController: UIViewController {
    
    var point: Point!
    @IBOutlet var detailLabel: UILabel!
    @IBOutlet var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        detailLabel.text = point.pointDescription
        
        var urlPath : String!
        urlPath = point?.image
        
        let imageURL:String! = "http://ios.kg-dev.com/api/photos/\(urlPath)"
        
        Alamofire.request(.GET, imageURL).response {
            (request: NSURLRequest?, response: NSHTTPURLResponse?, data: NSData?, error: NSError?) -> Void in
            
            if let data = data {
                let image = UIImage(data: data as NSData)
                self.imageView.image = image
            }
        }

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
