//
//  ViewController.swift
//  Pitch Perfect
//
//  Created by Dev on 2015-11-17.
//  Copyright © 2015 Zaytun Lab. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var recordInProgress: UILabel!

    @IBOutlet weak var stopButton: UIButton!
    
    @IBOutlet weak var recordButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        
        recordButton.enabled = true
        
        stopButton.hidden = true
    }
    
    
    @IBAction func recordAudio(sender: UIButton) {
        
        recordButton.enabled = false
        
        recordInProgress.hidden = false
        
        stopButton.hidden = false
    }

    @IBAction func stopAudio(sender: UIButton) {
        
        recordInProgress.hidden = true
    }
}

