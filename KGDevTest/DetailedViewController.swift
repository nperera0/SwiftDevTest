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
    @IBOutlet var imageTitle:UINavigationItem!
    @IBOutlet var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        detailLabel.text = point.pointDescription
        imageTitle.title = point.title
        
        var urlPath : String!
        urlPath = point?.imageUrl
        
        let imageURL:String! = "http://ios.kg-dev.com/api/photos/\(urlPath)"
        
        Alamofire.request(.GET, imageURL).response {
            (request: NSURLRequest?, response: NSHTTPURLResponse?, data: NSData?, error: NSError?) -> Void in
            
            if let data = data {
                let image = UIImage(data: data as NSData)
                self.imageView.image = image
            }
        }

    }

}
