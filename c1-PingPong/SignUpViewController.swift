    //
    //  SignUpViewController.swift
    //  Reseve Me
    //
    //  Created by Belay, Betelhem on 10/30/16.
    //  Copyright © 2016 Stars99. All rights reserved.
    //
    
    import UIKit
    import Parse
    
    class SignUpViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate,UIScrollViewDelegate  {
        
        
        @IBOutlet weak var profilePhotoImageView: UIImageView!
        @IBOutlet weak var signUpScrollView: UIScrollView!
        @IBOutlet weak var fieldParentView: UIView!
        @IBOutlet weak var buttonParentView: UIView!
        
        
        @IBOutlet weak var signUpSpinner: UIActivityIndicatorView!
        
        @IBOutlet weak var nameField: UITextField!
        @IBOutlet weak var emailField: UITextField!
        @IBOutlet weak var passwordField: UITextField!
        
        var image = UIImage.self
        
        var initialY: CGFloat!
        var offset: CGFloat!
        var textFieldInitialY: CGFloat!
        var buttonsInitialY: CGFloat!
        
        
        
        override func viewDidLoad() {
            super.viewDidLoad()
            
            self.signUpSpinner.isHidden = true
            
            
            profilePhotoImageView.layer.borderWidth = 1
            profilePhotoImageView.layer.masksToBounds = false
            profilePhotoImageView.layer.borderColor = UIColor.white.cgColor
            profilePhotoImageView.layer.cornerRadius = profilePhotoImageView.frame.height/2
            profilePhotoImageView.clipsToBounds = true
            
            
            signUpScrollView.delegate = self
            signUpScrollView.contentSize = signUpScrollView.frame.size
            signUpScrollView.contentInset.bottom = 100
            
            textFieldInitialY = fieldParentView.frame.origin.y
            buttonsInitialY = buttonParentView.frame.origin.y
            offset = -150
            
            
            NotificationCenter.default.addObserver(forName: Notification.Name.UIKeyboardWillShow, object: nil, queue: OperationQueue.main) { (notification: Notification) in
                self.fieldParentView.frame.origin.y = self.textFieldInitialY + self.offset
                self.buttonParentView.frame.origin.y = self.buttonsInitialY - 250
            }
            
            NotificationCenter.default.addObserver(forName: Notification.Name.UIKeyboardWillHide, object: nil, queue: OperationQueue.main) { (notification: Notification) in
                self.fieldParentView.frame.origin.y = self.textFieldInitialY
                self.buttonParentView.frame.origin.y = self.buttonsInitialY
            }
            
        }
//        override func viewWillAppear(_ animated: Bool) {
//            let transform = CGAffineTransform(scaleX: 0.2, y: 0.2)
//            fieldParentView.transform = transform
//            fieldParentView.alpha = 0
//            
//        }
        
        override func viewDidAppear(_ animated: Bool) {
            //Animate the code within over 0.3 seconds...
            UIView.animate(withDuration: 0.3) { () -> Void in
                // Return the views transform properties to their default states.
                self.fieldParentView.transform = CGAffineTransform.identity
                // self.loginNavBar.transform = CGAffineTransform.identity
                // Set the alpha properties of the views to fully opaque
                self.fieldParentView.alpha = 1
                
            }
            
            
        }
    
        
        @IBAction func didTapSignUp(_ sender: AnyObject) {
            
            signUpSpinner.isHidden = false
            signUpSpinner.startAnimating()
            
            let nameField = self.nameField.text;
            let emailField = self.emailField.text;
            let passwordField = self.passwordField.text;
            
            //check for empty fields
            if((nameField?.isEmpty)! || (emailField?.isEmpty)! || (passwordField?.isEmpty)!)
                
            {
                
                //  displayMyAlertMessage(userMessage: "All fields are required");
                return;
                
            }
            
            let user = PFUser()
            let imageData = UIImagePNGRepresentation(self.profilePhotoImageView.image!)
            let imageFile = PFFile(name:"image.png", data:imageData!)
            
            //            var userPhoto = PFObject(className:"UserPhoto")
            //            userPhoto["imageName"] = "My photo!"
            user["imageFile"] = imageFile
            //            userPhoto.saveInBackground(block: { (success: Bool, error: Error?) in
            
            //                })
            user.username = emailField
            user.password = passwordField
            user["fullName"] = nameField
            user.email = emailField
            
            user.signUpInBackground { (success: Bool, error: Error?) in
                if success {
                        let alertController = UIAlertController(title: "Success", message: "Sign Up", preferredStyle: UIAlertControllerStyle.alert)
                        let OKAction = UIAlertAction(title: "OK", style: .default) {action in
                            let storyboard = UIStoryboard(name: "Schedule", bundle: nil)
                            let eventVC = storyboard.instantiateViewController(withIdentifier: "ScheduleVC") as! ScheduleViewController
                            self.signUpSpinner.isHidden = true
                            self.present(eventVC, animated: true, completion: nil)
                            
                            // self.dismiss(animated: true, completion: nil)
                            
                        }
                        
                        //Add ok Action
                        alertController.addAction(OKAction)
                        //Present View controller
                        self.present(alertController, animated: true, completion: nil)
                        
                    }
//                    else {
//                        self.displayMyAlertMessage(userMessage: "sorry")
//                        print(error?.localizedDescription)
                    
                    
                    
                    
                    
//                    let imageData = UIImagePNGRepresentation(self.profilePhotoImageView.image!)
//                    // Create a parse file to store in cloud
//                    var parseImageFile = PFFile(name: "uploaded_image.png", data: imageData!)
//                   // user.email = emailField
//
//                    let userPhoto = PFObject(className:"UserPhoto")
//                    //user["userID"] = PFUser.current()
//                   // userPhoto["imageFile"] = parseImageFile
//                    var parseImageFile = PFFile(name: "uploaded_image.png", data: imageData
//                    currentUploads["imageFile"] = parseImageFile
//                    userPhoto["imageName"] = "My photo!"
//                    userPhoto.saveInBackground(block: { (success: Bool, error: Error?) in
//                        
//                    })
            }
            }
            
            func displayMyAlertMessage (userMessage: String)
                
            {
                let alertController = UIAlertController (title: "Sorry", message: userMessage, preferredStyle: UIAlertControllerStyle.alert);
                
                let OKAction = UIAlertAction(title: "OK", style: .default) {
                    (action) in
                    self.signUpSpinner.isHidden = true
                }
                // present Alert
                alertController.addAction(OKAction)
                self.present(alertController, animated: true, completion: nil)
        
        
        }
            @IBAction func didTapPhoto(_ sender: AnyObject) {
                let alertController = UIAlertController(title: nil, message: "Upload Profile Image", preferredStyle: .actionSheet)
                let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
                    
                }
                alertController.addAction(cancelAction)
                
                let OKAction = UIAlertAction(title: "Choose Photo", style: .default) { (action) in
                    
                    var photoPickerController = UIImagePickerController()
                    photoPickerController.delegate=self
                    photoPickerController.sourceType = UIImagePickerControllerSourceType.photoLibrary
                    self.present(photoPickerController, animated: true, completion: nil)
                    //set image
                    // profilePhotoImageView.image = info[UIImagePickerControllerOriginalImage] as? UIImage
                    
                    
                }
                alertController.addAction(OKAction)
                
                let destroyAction = UIAlertAction(title: "Take Photo", style: .destructive) { (action) in
                    if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
                        var photoPickerController = UIImagePickerController()
                        photoPickerController.delegate=self
                        photoPickerController.sourceType = UIImagePickerControllerSourceType.camera
                        self.present(photoPickerController, animated: true, completion: nil)
                        
                    }
                }
                alertController.addAction(destroyAction)
                
                self.present(alertController, animated: true) {
                    // ...
                }
                
                func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
                    
                }
            }
            
            
            @IBAction func didTapExit(_ sender: UIButton) {
                var alertController = UIAlertController(title: nil, message: "Are you sure you want to cancel?", preferredStyle: .alert)
                // let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
                
                dismiss(animated: true, completion: nil)
                
            }
            
            
            func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
                profilePhotoImageView.image = info[UIImagePickerControllerOriginalImage] as? UIImage
                self.dismiss(animated: true, completion: nil)
                
            }
            
            func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
    
    }
    
    
    
    }
    
    
    
    
