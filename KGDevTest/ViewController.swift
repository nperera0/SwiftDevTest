//
//  ViewController.swift
//  KGDevTest
//
//  Created by Nisal Perera on 2015-12-22.
//  Copyright © 2015 Nisal Perera. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    //segmentedControl is used to switch between ListView and MapView 
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    @IBOutlet weak var firstView: UIView!
    @IBOutlet weak var secondView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        firstView.hidden = false
        secondView.hidden = true
    }
    
    @IBAction func indexChanged(sender: UISegmentedControl) {
        switch segmentedControl.selectedSegmentIndex
        {
        case 0:
            firstView.hidden = false
            secondView.hidden = true
        case 1:
            firstView.hidden = true
            secondView.hidden = false
        default:
            break;
        }
    }
    
}

