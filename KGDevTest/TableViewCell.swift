//
//  TableViewCell.swift
//  KGDevTest
//
//  Created by Nisal Perera on 2015-12-24.
//  Copyright © 2015 Nisal Perera. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {
    
    var point: Point? {
        didSet {
            titleLabel.text = point?.pointTitle
            detailLabel.text = point?.pointDescription
        }
    }
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var detailLabel: UILabel!
    @IBOutlet var thumbImage: UIImageView!
    
    

}
