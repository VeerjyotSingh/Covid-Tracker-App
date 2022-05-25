//
//  ViewController.swift
//  Covid
//
//  Created by Veerjyot Singh on 07/05/22.
//

import UIKit

class ViewController: UIViewController {
    @IBAction func news(_ sender: UIButton) {
        performSegue(withIdentifier: "homeToNews", sender: self)
        APICaller.shared.getTopStories{result in}
        }
    @IBAction func symptoms(_ sender: UIButton) {
        performSegue(withIdentifier: "homeToSymptoms", sender: self)
    }
    @IBAction func stats(_ sender: UIButton) {
        performSegue(withIdentifier: "homeToStats", sender: self)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

}
