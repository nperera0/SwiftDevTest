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
            titleLabel.text = point?.pointTitle
            detailLabel.text = point?.pointDescription
            
            var urlPath : String!
            urlPath = point?.thumb
            
            let imageURL:String! = "http://ios.kg-dev.com/api/photos/\(urlPath)"
            
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