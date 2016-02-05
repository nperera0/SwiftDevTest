//
//  TableViewCell.swift
//  KGDevTest
//
//  Created by Nisal Perera on 2015-12-24.
//  Copyright © 2015 Nisal Perera. All rights reserved.
//

import UIKit
import Alamofire

class TableViewCell: UITableViewCell {
    
    var point: Point? {
        didSet {
            titleLabel.text = point?.title
            detailLabel.text = point?.pointDescription
            
            var urlPath : String!
            urlPath = point?.thumbUrl
            
            let imageURL:String! = "http://ios.kg-dev.com/api/photos/\(urlPath)"
            
            // pull the image by calling rest API endpoint
            Alamofire.request(.GET, imageURL).response {
                (request: NSURLRequest?, response: NSHTTPURLResponse?, data: NSData?, error: NSError?) -> Void in
                
                if let data = data {
                    let image = UIImage(data: data as NSData)
                    self.thumbImage.image = image
                }
            }
        }
    }
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var detailLabel: UILabel!
    @IBOutlet var thumbImage: UIImageView!
    
    

}
