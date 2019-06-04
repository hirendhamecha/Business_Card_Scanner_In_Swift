//
//  ScannedInfoShowDetailsVC.swift
//  Business_Card_Scanner_In_Swift
//
//  Created by Hiren Dhamecha on 01/06/19.
//  Copyright © 2019 Hiren Dhamecha. All rights reserved.
//

import UIKit

class ScannedInfoShowDetailsVC: UIViewController
{

    var strName : String!
    var strEmail : String!
    var strMob : String!
    var strAdddress : String!
    var mainArray : NSMutableArray!
    
    @IBOutlet var txtAddress: UITextView!
    @IBOutlet var txtMobile: UITextField!
    @IBOutlet var txtEmail: UITextField!
    @IBOutlet var txtName: UITextField!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.getDetailsFromScannedData() // call details from scanned_data !
    }

    //Mark:- GET DETAILS FROM CARD DATA
    func getDetailsFromScannedData() -> Void
    {
        print("Scanned Details :\(self.mainArray)")
        for i in 0...self.mainArray.count - 1
        {
            let strLine = self.mainArray.object(at: i) as? String
            let arrstrJoin = (strLine?.components(separatedBy: " ").count)!
            let addressarrstrJoin = (strLine?.components(separatedBy: " ").count)!
            
            if self.isValidEmail(testStr: strLine!)
            {
                if self.txtEmail.text == ""
                {
                    self.strEmail = strLine
                    self.txtEmail.text = self.strEmail
                }
            }
            
            if addressarrstrJoin > 6
            {
                print("Address :\(strLine)")
                if (strLine?.contains("@"))!
                {
                    let arrOfstrEmail = strLine?.components(separatedBy: " ")
                    if (arrOfstrEmail?.count)! > 0
                    {
                        let strforEmailAddress = arrOfstrEmail![(arrOfstrEmail?.count)! - 1]
                        if strforEmailAddress.contains("@")
                        {
                            if self.txtEmail.text == ""
                            {
                                self.strEmail = strforEmailAddress
                                self.txtEmail.text = self.strEmail
                            }
                        }
                        
                        let arrstrJoin = NSMutableArray.init()
                        for i in 0...(arrOfstrEmail?.count)! - 2
                        {
                            arrstrJoin.add(String.init(format: "%@", arrOfstrEmail![i]))
                        }
                        
                        if self.txtAddress.text == ""
                        {
                            let strAddressFinal  = arrstrJoin.componentsJoined(by: " ")
                            self.strAdddress = strAddressFinal
                            self.txtAddress.text = self.strAdddress
                        }
                        
                    }
                }
                else
                {
                    if self.txtAddress.text == ""
                    {
                        self.strAdddress = strLine
                        self.txtAddress.text = self.strAdddress
                    }
                }
            }

            if arrstrJoin == 2
            {
                let letters = NSCharacterSet.letters
                let phrase = strLine
                let range = strLine?.rangeOfCharacter(from: letters)
                if let test = range
                {
                    if self.txtName.text == ""
                    {
                        self.strName = strLine
                        self.txtName.text = self.strName
                    }
                }
            }
            
            let strArray = strLine?.components(separatedBy: NSCharacterSet.decimalDigits.inverted)
            let newString = NSArray(array: strArray!).componentsJoined(by: "")
            if self.txtMobile.text == ""
            {
                if newString.count >= 10
                {
                    let index = newString.index(newString.startIndex, offsetBy: 0)
                    let fstchar = newString[index]
                    if fstchar == "0"
                    {
                        self.strMob = String(newString.prefix(11))
                        self.txtMobile.text = self.strMob
                    }
                    else
                    {
                        if newString.contains("91")
                        {
                            self.strMob = String(newString.prefix(12))
                            self.txtMobile.text = self.strMob
                        }
                        else
                        {
                            self.strMob = String(newString.prefix(10))
                            self.txtMobile.text = self.strMob
                        }
                    }
                }
            }
        }
        
        let strNamed = self.mainArray.object(at: 0) as? String
        if self.txtName.text == ""
        {
            let strarray = strNamed?.components(separatedBy: " ") as? NSArray
            if (strarray?.count)! >= 2
            {
                let strfirst = strarray![0] as? String
                let strSecond = strarray![1] as? String
                
                self.strName = String.init(format: "%@ %@", strfirst!,strSecond!)
                self.txtName.text = self.strName
            }
            else
            {
                self.strName = strNamed
                self.txtName.text = self.strName
            }
        }
    }
    
    
    func isValidEmail(testStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
    //MARK:- Memory mgnt :
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
