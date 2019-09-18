//
//  ViewController.swift
//  helloApp
//
//  Created by Riley John Gibbs on 9/2/19.
//  Copyright © 2019 Riley John Gibbs. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var greetingLabel: UILabel!
    @IBOutlet weak var helloGoodbyeSwitch: UISwitch!
    @IBOutlet weak var helloButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameTextField.text = "Riley"
        sayHello("")
    }

    @IBAction func sayHello(_ sender: Any) {
        let shouldSayHello = helloGoodbyeSwitch.isOn
        if shouldSayHello {
            greetingLabel.text = "Hello, \(nameTextField.text ?? "human")!"
        } else {
            greetingLabel.text = "Goodbye, \(nameTextField.text ?? "human")!"
        }
    }
    
    @IBAction func toggleSwitch(_ sender: UISwitch) {
        let hello = sender.isOn
        if hello {
            helloButton.setTitle("Say Hello", for: .normal)
        } else {
            helloButton.setTitle("Say Goodbye", for: .normal)
        }
    }
}

