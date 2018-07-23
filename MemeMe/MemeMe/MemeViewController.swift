//
//  MemeViewController.swift
//  MemeMe
//
//  Created by WY NG on 26/6/2018.
//  Copyright © 2018 lumanman. All rights reserved.
//

import UIKit

class MemeViewController: UIViewController, UIImagePickerControllerDelegate,
UINavigationControllerDelegate, UITextFieldDelegate {
    
    // MARK: Properties
    var memedImage : UIImage?
    var sentMeme: Meme?
    var dataLoaded = false
    var memes: [Meme]!
    
    // TextField attributes
    let memeTextAttributes:[String: Any] = [
        NSAttributedStringKey.strokeColor.rawValue: UIColor.black,
        NSAttributedStringKey.foregroundColor.rawValue: UIColor.white,
        NSAttributedStringKey.font.rawValue: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSAttributedStringKey.strokeWidth.rawValue: -3.0]
    
    // MARK: Outlets
    // Nav Bar
    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    
    // Tool Bar
    @IBOutlet weak var toolBar: UIToolbar!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    
    // Image View
    @IBOutlet weak var imageView: UIImageView!
    
    // Text Fields
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    
    
    // MARK: View Controller Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set text sttributes
        setDefaultTextAttributes(textField: topTextField, string: "TOP")
        setDefaultTextAttributes(textField: bottomTextField, string: "BOTTOM")
       
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if dataLoaded == true {
            if  sentMeme != nil {
                createEditedMeme(copy: sentMeme!)
            }
             dataLoaded = false
        }
        
        
        // Enable camera button
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        
        // Enable keyboard
        subscribeToKeyboardNotifications()
        
        // Enables share button
        shareButton.isEnabled = imageView.image != nil
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Disable Keyboard
        unsubscribeFromKeyboardNotifications()
    }
    
    // MARK: Button Clicked
    
    // choose an image from the Photo Album
    @IBAction func albumBtnClicked(_ sender: UIBarButtonItem) {
        pickAnImage(from: .photoLibrary)
    }
    
    // launch the camera and snap a photo for the meme
    @IBAction func cameraBtnClickef(_ sender: UIBarButtonItem) {
        pickAnImage(from: .camera)
    }
    
    // return to its launch state
    @IBAction func cancelBtnClicked(_ sender: UIBarButtonItem) {
        topTextField.text = "TOP"
        bottomTextField.text = "BOTTOM"
        imageView.image = nil
        shareButton.isEnabled = false
        
        dismiss(animated: true, completion: nil)
    }
    
    // share Meme with activity View
    @IBAction func shareBtnClicked(_ sender: UIBarButtonItem) {
        
        // generate a memed image
        memedImage = generateMemedImage()
        
        guard let img = memedImage else {
            print("fail togenerate a Meme")
            return
        }
        
        // define an instance of the ActivityViewController & pass the ActivityViewController a memedImage as an activity item
        let shareController = UIActivityViewController(activityItems: [img], applicationActivities: nil)
        
        // Save the meme
        shareController.completionWithItemsHandler = { activity, success, items, error in
            self.save()
            self.dismiss(animated: true, completion: nil)
        }
        
        // present the ActivityViewController
        present(shareController, animated: true, completion: nil)
        
    }
    
    // edit the Meme from sent VC
    func createEditedMeme(copy : Meme) {
        imageView.image = copy.originalImage
        memedImage = copy.memedImage
        topTextField.text = copy.topText
        bottomTextField.text = copy.bottomText
    }
    
    
    // MARK:  Pick Image
    func pickAnImage(from source: UIImagePickerControllerSourceType) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = source
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    // MARK: UIImagePickerController Delegates
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imageView.image = image
            imageView.contentMode = .scaleAspectFit
            shareButton.isEnabled = true
        }
        dismiss(animated: true, completion: nil)
    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    
    // MARK: Meme Generator
    
    func save() {
        // Create the meme
        let meme = Meme(topText: topTextField.text!, bottomText: bottomTextField.text!, originalImage: imageView.image!, memedImage: generateMemedImage())
        
        // Add it to the memes array in the Application Delegate
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        appDelegate.memes.append(meme)
 
    }
    
    func generateMemedImage() -> UIImage {
        // Hide toolbar and navbar
        navBar.isHidden = true
        toolBar.isHidden = true
        
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        // Show toolbar and navbar
        navBar.isHidden = false
        toolBar.isHidden = false
        
        return memedImage
    }
    
    
    // MARK: TextField Setting
    // Set default textField attributes
    func setDefaultTextAttributes(textField: UITextField, string: String){
        textField.text = string
        textField.defaultTextAttributes = memeTextAttributes
        textField.textAlignment = .center
        textField.delegate = self
        textField.returnKeyType = .done
    }
    
    // Clear text when begin to text
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if (textField.text == "TOP" || textField.text == "BOTTOM") {
            textField.text = ""
        }
    }
    
    
    // Closes keyboard when return key pressed
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // MARK: Keyboard Setting
    
    // Subcribe keyboard
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: .UIKeyboardWillHide, object: nil)
    }
    
    // UnSubcribe keyboard
    func unsubscribeFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide, object: nil)
    }
    
    // Show keyboard
    @objc func keyboardWillShow(_ notification:Notification) {
        
        // shift the view's frame up
        if bottomTextField.isFirstResponder {
            view.frame.origin.y -= getKeyboardHeight(notification)
        }
    }
    
    // Hide keyboard
    @objc func keyboardWillHide(_ notification:Notification) {
        
        // move the view frame back down to 0
        if bottomTextField.isFirstResponder {
            view.frame.origin.y = 0
        }
    }
    
    // Keyboard height
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        
        return keyboardSize.cgRectValue.height
    }
}

