//
//  ViewController.swift
//  Minesweeper@2019B
//
//  Created by Athar Mass on 01/04/2019.
//  Copyright © 2019 אתאר מסארוה. All rights reserved.
//

import UIKit
import SpriteKit

class ViewController: UIViewController , UIPickerViewDelegate,UIPickerViewDataSource{
  
    @IBOutlet weak var animateView: SKView!
    @IBOutlet weak var textLevel: UITextField!
    @IBOutlet weak var pickerLevels: UIPickerView!
    @IBOutlet weak var playerName: UITextField!
    @IBOutlet weak var gameView: GamePage!
    var scene:SceneExplosion?

    //create list
    var list: [String] = [String]()
    //GLOBAL VARIABLE
    struct MyVariables {
        static var levelDifficulty :String = "Easy"
        static var nameOfPlayer :String = "Player"
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Connect data:
        self.pickerLevels.delegate = self
        self.pickerLevels.dataSource = self
        
        // Input the data into the array
        list = ["Easy", "Medium", "Hard"]
        
        //Default label
        textLevel.text = "Select A Level"
        
        //Hide Keyboard when click any where
        self.hideKeyboardWhenTappedAround()
        
       
        
    }
    
    //Function to hide keyboard
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer =     UITapGestureRecognizer(target: self, action:    #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    var representedObject: Any? {
        didSet {
            // Update the view, if already loaded.
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    // Number of columns of data
    func  numberOfComponents(in pickerView: UIPickerView)->Int {

        return 1
    }
    // The number of rows of data
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
    
        return list.count
    }
    // The data to return for the row and component (column) that's being passed in
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        self.view.endEditing(true)
        return list[row]
    }
    
    func pickerView(_ pickerView: UIPickerView,didSelectRow row:Int, inComponent component: Int) {
        self.textLevel.text = self.list[row]
        self.pickerLevels.isHidden = true
    }
    
    @IBAction func textFieldDidBeginEditing(_ sender: UITextField) {
        if sender == self.textLevel{
            self.pickerLevels.isHidden = false
            sender.endEditing(true)
        }
    }
    
    @IBAction func nameFieldDidEndEditing(_ sender: UITextField) {
        if sender.text?.isEmpty ?? false{
            sender.endEditing(true)
        }
    }
    
    @IBAction func SavePlayerNameAndLevelDifficulty(_ sender: UIButton) {
        //Save level difficulty value
        MyVariables.levelDifficulty =  textLevel.text!

        //Save Player Name
        MyVariables.nameOfPlayer = playerName.text!
    }
    
    @IBAction func startTapped(_ sender: Any) {
        let username = playerName.text

        if ((username?.isEmpty)! ||  textLevel.text == "Select A Level") {
            let myAlert = UIAlertController(title: "Alert❗️", message: "All fields are required to fill in,\n Please try again!\n 😉 ", preferredStyle: UIAlertController.Style.alert)
            
            let okAction = UIAlertAction(title: "oK", style: UIAlertAction.Style.default,handler:nil)
            
            myAlert.addAction(okAction)
            
            self.present(myAlert,animated: true,  completion:nil)
            return
        }
     else{
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            if let vc = storyboard.instantiateViewController(withIdentifier: "GameScreen") as? GamePage {
                self.present(vc, animated: true, completion: nil)
            }
        }
    }
}

