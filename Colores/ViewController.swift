//
//  ViewController.swift
//  Colores
//
//  Created by Eugenio Barquín on 27/12/16.
//  Copyright © 2016 Eugenio Barquín. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var btnSwitch: UIButton!

    @IBOutlet weak var imgKnobBase: UIImageView!
    
    @IBOutlet weak var imgKnob: UIImageView!
    
       override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imgKnob.isHidden = true
        imgKnobBase.isHidden = true
       
    }
    override func viewWillAppear(_ animated: Bool) {
        btnSwitch.setImage(#imageLiteral(resourceName: "img_switch_off"), for: .normal)
        btnSwitch.setImage(#imageLiteral(resourceName: "img_switch_on"), for: .selected)
    }
    
    @IBAction func btnSwitchPressed(_ sender: UIButton) {
        btnSwitch.isSelected = !btnSwitch.isSelected
        if btnSwitch.isSelected {
            imgKnob.isHidden = false
            imgKnobBase.isHidden = false
            view.backgroundColor = UIColor(hue: 0.5, saturation: 0.5, brightness: 0.75, alpha: 1.0)
        } else {
            view.backgroundColor = UIColor(hue: 0.5, saturation: 0, brightness: 0.2, alpha: 1.0)
            imgKnob.isHidden = true
            imgKnobBase.isHidden = true
        }
    }

  
}

