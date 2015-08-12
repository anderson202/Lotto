//
//  SettingsViewController.swift
//  Lotto
//
//  Created by Anderson Ng on 2015-07-10.
//  Copyright (c) 2015 Anderson Ng. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, NSCoding{
    
    var updatedAlert = true
    var updatedWinningNumbers = [Int]()
    var numbers = [Int]()
    let defaults = NSUserDefaults.standardUserDefaults()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        if defaults.integerForKey("times") == 0 {
            defaults.setInteger(1, forKey: "times")
            defaults.setBool(updatedAlert, forKey: "updatedAlert")
        } else {
            let alertValue = defaults.boolForKey("updatedAlert")
            updatedAlert = alertValue
        }
        
        updatedWinningNumbers = defaults.objectForKey("winningNumbers") as! [Int]
        settingsPicker.dataSource = self
        settingsPicker.delegate = self
        alertSwitch.setOn(updatedAlert, animated: true)
        
        
        
        
        
        for var i = 1; i < 50; ++i{
            numbers.append(i)
        }
        
        for var j = 0; j < 6; ++j{
        
            settingsPicker.selectRow(updatedWinningNumbers[j]-1, inComponent: j, animated: true)
            
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func save(value: Bool) {
        defaults.setBool(value, forKey: "updatedAlert")
    }
    
    @IBOutlet weak var alertSwitch: UISwitch!
    @IBAction func alertSwitch(sender: UISwitch) {
        if !sender.on{
            updatedAlert = false
            save(false)
            
        }else{
            updatedAlert = true
            save(true)
        }
    }
    @IBOutlet weak var settingsPicker: UIPickerView!
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        
        // Create a new variable to store the instance of the next view controller
        let destinationVC = segue.destinationViewController as! ViewController
        destinationVC.winningNumbers = updatedWinningNumbers
        destinationVC.showLoseAlert = updatedAlert
        destinationVC.lottoDisplay.hidden = false
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 6
    }
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 49
    }
    
    func pickerView(pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        
        return NSAttributedString(string: String(numbers[row]), attributes: [NSForegroundColorAttributeName:UIColor.whiteColor()])
    }
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        updatedWinningNumbers.removeAll()
        for var i = 0; i<6; ++i{
            updatedWinningNumbers.append(numbers[settingsPicker.selectedRowInComponent(i)])
        }
        defaults.setObject(updatedWinningNumbers, forKey: "winningNumbers")
    }


}

