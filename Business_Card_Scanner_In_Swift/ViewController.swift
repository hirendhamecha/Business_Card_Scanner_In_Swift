//
//  ViewController.swift
//  Business_Card_Scanner_In_Swift
//
//  Created by Hiren Dhamecha on 01/06/19.
//  Copyright © 2019 Hiren Dhamecha. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate,CropViewControllerDelegate
{
    let debugMode = true
    private var extractedTextError: Error? {
        didSet {
            self.performSegue(withIdentifier: "showError", sender: self)
        }
    }
    private var extractedTextBlocks: [String]? {
        didSet {
            if debugMode { print("extracted blocks: \(extractedTextBlocks!)") }
            //self.performSegue(withIdentifier: "showInfo", sender: self)
            
            
        }
    }
    
    //Card Utilities
    private let cardDetection = CardDetectionUtility()
    private let faceDetection = FaceDetectionUtility()
    private let ocrUtility = OCRUtility()
    var mainArray : NSMutableArray!
    
    @IBOutlet var imgCard: UIImageView!
    @IBOutlet var btnTapToCard: UIButton!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

    }

    
    @IBAction func onClickforOpenCard(_ sender: Any)
    {
        self.showActionSheet()
    }
    
    //MARK:- OPTION = > FROM CAMERA
    func camera()
    {
        let myPickerController = UIImagePickerController()
        myPickerController.delegate = self
        myPickerController.sourceType = UIImagePickerControllerSourceType.camera
        self.present(myPickerController, animated: true, completion: nil)
        
    }
    
    //MARK:- OPTION = > FROM GALLERY
    func photoLibrary()
    {
        let myPickerController = UIImagePickerController()
        myPickerController.delegate = self
        myPickerController.sourceType = UIImagePickerControllerSourceType.photoLibrary
        self.present(myPickerController, animated: true, completion: nil)
    }
    
    //MARK:- Imagepicker Delegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])
    {
        let chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        dismiss(animated: true, completion: nil)
        
        let controller = CropViewController()
        controller.delegate = self
        controller.image = chosenImage
        let navController = UINavigationController(rootViewController: controller)
        present(navController, animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController)
    {
        dismiss(animated: true, completion: nil)
    }
    
    //MARK:- Cropping Delegate !
    func cropViewController(_ controller: CropViewController, didFinishCroppingImage image: UIImage)
    {
        
    }
    
    func cropViewController(_ controller: CropViewController, didFinishCroppingImage image: UIImage, transform: CGAffineTransform, cropRect: CGRect)
    {
        controller.dismiss(animated: true, completion: nil)
        self.imgCard.image = image
        self.cardScanning(capturedImage: self.imgCard.image!)
        
    }
    
    func cropViewControllerDidCancel(_ controller: CropViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
   
    
    //MARK:- Show Gallery / Camera option :
    
    func showActionSheet()
    {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Camera", style: UIAlertActionStyle.default, handler: { (alert:UIAlertAction!) -> Void in
            self.camera()
        }))
        actionSheet.addAction(UIAlertAction(title: "Gallery", style: UIAlertActionStyle.default, handler: { (alert:UIAlertAction!) -> Void in
            self.photoLibrary()
        }))
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: { (alert:UIAlertAction!) -> Void in
        }))
        self.present(actionSheet, animated: true, completion: nil)
        
    }
    
    func cardScanning(capturedImage : UIImage) -> Void
    {
        ocrUtility.detectText(image: capturedImage) { (error, blocks) in
            if error != nil { self.extractedTextError = error }
            else if blocks != nil { self.extractedTextBlocks = blocks
                
                print("asd : \(self.extractedTextBlocks)")
                
                //                let str  =  self.extractedTextBlocks?.joined(separator: "\n")
                //                let alert = UIAlertView.init(title: "Scanned Card ", message: str, delegate: nil, cancelButtonTitle: "OK")
                //                alert.show()
                
                self.mainArray = NSMutableArray.init(array: self.extractedTextBlocks!)
                if self.mainArray != nil
                {
                    self.performSegue(withIdentifier: "show", sender: nil)
                }
                else
                {
                    
                }
            }
        }
        
    }
    
    //MARK:- PASS Scanned data to another ViewController :
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.identifier == "segueToShowDetails"
        {
            let dest = segue.destination as? ScannedInfoShowDetailsVC
            dest?.mainArray = self.mainArray
        }
        
    }
    
    //MARK:- memrmoy mgnt :
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

