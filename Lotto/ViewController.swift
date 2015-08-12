//
//  ViewController.swift
//  Lotto
//
//  Created by Anderson Ng on 2015-07-07.
//  Copyright (c) 2015 Anderson Ng. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    
    
    var lottoNumbers = [Int]()
    var winningNumbers = [1,2,3,4,5,6]
    var showLoseAlert = true
    


    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        
        lottoDisplay.userInteractionEnabled = false
        lottoDisplay.dataSource = self
        lottoDisplay.delegate = self
        
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject(winningNumbers, forKey: "winningNumbers")
        winningNumbers = defaults.objectForKey("winningNumbers") as! [Int]
        if defaults.integerForKey("times") == 0 {
            defaults.setInteger(1, forKey: "times")
            defaults.setBool(showLoseAlert, forKey: "updatedAlert")
            
        } else {
            let alertValue = defaults.boolForKey("updatedAlert")
            showLoseAlert = alertValue
        }

        println(winningNumbers)
        for var i = 1; i<50; ++i{
            lottoNumbers.append(i)
        }
        
        
        
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func settings() {
        lottoDisplay.hidden = true
    }
    
   
    @IBOutlet weak var lottoDisplay: UIPickerView!
    @IBOutlet weak var generateButton: UIButton!
    @IBAction func generateNumber() {
        var numberOfChoices = 49
        var usedLottoNumber = [Int]()
        var chosenLotto = [Int]()
        var uniqueNumber = true
        
        generateButton.enabled = false
        
        for var i = 0; i < 6; ++i{
            var randomNumber = Int(arc4random() % 49)
            do{
                if contains(usedLottoNumber, randomNumber){
                    uniqueNumber = false
                    randomNumber = Int(arc4random() % 49)
                }else{
                    uniqueNumber = true
                }
            }while !uniqueNumber
            
            lottoDisplay.selectRow(randomNumber, inComponent: i, animated: true)
            chosenLotto.append(randomNumber + 1)
            usedLottoNumber.append(randomNumber)
            uniqueNumber = false
            }
        
        lottoDisplay.reloadAllComponents()
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(0.7 * Double(NSEC_PER_SEC))), dispatch_get_main_queue()) {
            if self.checkForWinningNumber(chosenLotto, winningLotto: self.winningNumbers){
                self.winAlert()
            }else if self.showLoseAlert{
                self.loseAlert()
            }
            self.generateButton.enabled = true
        }
    }
    func checkForWinningNumber(lotto: [Int], winningLotto:[Int])->Bool{
        for number in lotto{
            if !contains(winningLotto, number){
                return false
            }
        }
        return true
    }
    
    func winAlert(){
        let ac = UIAlertController(title: "Congratulations", message: "You won the lottery!", preferredStyle: UIAlertControllerStyle.Alert)
        ac.addAction(UIAlertAction(title: "Keep rolling", style: UIAlertActionStyle.Cancel, handler: nil))
        presentViewController(ac, animated: true, completion: nil)
    }
    
    func loseAlert(){
        let ac = UIAlertController(title: "Sorry", message: "You didn't win the lottery", preferredStyle: UIAlertControllerStyle.Alert)
        ac.addAction(UIAlertAction(title: "Keep rolling", style: UIAlertActionStyle.Cancel, handler: nil))
        presentViewController(ac, animated: true, completion: nil)
    }

    @IBAction func unwindToViewController(sender: UIStoryboardSegue) {
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        
        // Create a new variable to store the instance of the next view controller
        let destinationVC = segue.destinationViewController as! SettingsViewController
        destinationVC.updatedWinningNumbers = winningNumbers
        destinationVC.updatedAlert = showLoseAlert
        
    }

    

    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 6
    }
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return lottoNumbers.count
    }
    
    func pickerView(pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        var string = String(lottoNumbers[row])
        return NSAttributedString(string: string, attributes: [NSForegroundColorAttributeName:UIColor.whiteColor()])
    }


}

