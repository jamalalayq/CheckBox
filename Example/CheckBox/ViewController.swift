//
//  ViewController.swift
//  CheckBox
//
//  Created by gemgemo on 08/31/2017.
//  Copyright (c) 2017 gemgemo. All rights reserved.
//

import UIKit
import CheckBox

class ViewController: UIViewController {
    
    @IBOutlet weak var chk: CheckBox!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        chk.onClick = { (checkbox) in
            print(checkbox.isChecked)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

