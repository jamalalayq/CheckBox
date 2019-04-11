//
//  ViewController.swift
//  CheckBox
//
//  Created by Jamal on 08/31/2017.
//  Copyright (c) 2017 Jamal alayq. All rights reserved.
//

import UIKit
import CheckBox

class ViewController: UIViewController {
    
    @IBOutlet weak var chk: CheckBox!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        chk.cornerRadius = 7
        chk.onClick = { (checkbox) in
            print(checkbox.isChecked)
        }
    }

}

