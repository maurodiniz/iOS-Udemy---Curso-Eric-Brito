//
//  SettingsViewController.swift
//  Pensamentos
//
//  Created by Mauro Augusto Diniz on 16/04/19.
//  Copyright © 2019 Mauro Augusto Diniz. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    @IBOutlet weak var swAutoRefresh: UISwitch!
    @IBOutlet weak var slTimeInterval: UISlider!
    @IBOutlet weak var scColorScheme: UISegmentedControl!
    @IBOutlet weak var lbTimeInterval: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func ChangeAutoRefresh(_ sender: UISwitch) {
    }
    
    @IBAction func ChangeTimeInterval(_ sender: UISlider) {
    }
    @IBAction func ChangeColorScheme(_ sender: UISegmentedControl) {
    }
    
    
}
