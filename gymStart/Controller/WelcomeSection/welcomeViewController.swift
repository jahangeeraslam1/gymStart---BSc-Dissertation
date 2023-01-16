//
//  registerViewController.swift
//  gymStart
//
//  Created by Jahangeer Aslam on 06/01/2021.
//

import UIKit
import Firebase
import AVFoundation
import PKHUD

class welcomeViewController: UIViewController {

    
    //variable setup
    @IBOutlet weak var gymStartLogo: UIImageView!
    
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var passwordTFicon: UIImageView!
    @IBOutlet weak var emailTFicon: UIImageView!
    
    @IBOutlet weak var errorLabel: UITextView!

    @IBOutlet weak var buttonsView: UIView!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var registerButton: UIButton!
    
    //set up required variables for background video
    @IBOutlet var videoLayer: UIView!
    var playerLayer = AVPlayerLayer()
    var playerLooper : AVPlayerLooper?
    
    //gets the gymStartDB from FireBase
    let gymStartDB = Firestore.firestore()
    
    
    // viewDidLoad() function performs any inital setup needed
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(false, animated: true) // hides nav bar
        self.errorLabel.isHidden = true // hide error label
        playBackgroundVideo()
    }
    
    
    //hides the navigation bar after it has appeared
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    func playBackgroundVideo(){
        
        
        //loads the file
        let path = Bundle.main.url(forResource: "welcomeFitnessVideo2-noAudio", withExtension: "mov")!
        let playerItem = AVPlayerItem(url : path)

        //sets up the player
        let player = AVQueuePlayer(playerItem:playerItem)
        playerLayer.frame = self.view.bounds
        playerLayer.player = player
        playerLayer.videoGravity = .resizeAspectFill
        self.videoLayer.layer.addSublayer(playerLayer)
        
        //loops
        playerLooper = AVPlayerLooper(player: player, templateItem: playerItem)
        
        // plays the player
        player.play()
       
        //moves player to background
        videoLayer.bringSubviewToFront(emailTF)
        videoLayer.bringSubviewToFront(passwordTF)
        videoLayer.bringSubviewToFront(errorLabel)
        videoLayer.bringSubviewToFront(passwordTFicon)
        videoLayer.bringSubviewToFront(emailTFicon)
        videoLayer.bringSubviewToFront(passwordTFicon)
        videoLayer.bringSubviewToFront(gymStartLogo)
        videoLayer.bringSubviewToFront(buttonsView)
    }
    
    
    

    

    

    @IBAction func signInButton(_ sender: UIButton) {
        
        self.errorLabel.text = "" //clears the error label ready to show new errors
    
        if let email = emailTF.text , let password = passwordTF.text {
            Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
                if let e = error { // save any error (if error occurs as e)
                    print("ISSUE : Couldn't sign in user . Error : \(e.localizedDescription)")
                    HUD.flash(.error, delay: 1.5) { finished in
                        self.errorLabel.text = e.localizedDescription
                        self.errorLabel.isHidden = false
                    }
                }
                else{
                    print("User Signed In Sucessfully!")
                    HUD.flash(.success, delay: 2.5) { finished in
                        self.performSegue(withIdentifier: "welcomeVCtoTabBarVC", sender: self)
                        print("Performing Segue to Home Screen")
                    
                    }
                   
       
                }
                
            } //authResult closure
        } // if let closure
    }
    
    
    

    
  

    //function to register a new user to Firebase
    @IBAction func registerButton(_ sender: UIButton) {
        self.errorLabel.text = "" //clears the error label ready to show new errors
        
        if let email = emailTF.text , let password = passwordTF.text { //checks values can be converted to strings
            Auth.auth().createUser(withEmail: email, password: password) { authResult, error in    //creates a new user and checks if an error occured
                if let e = error { // if error occurs when creating account
                    print("ISSUE : Couldn't create user . Error : \(e.localizedDescription)")
                    HUD.flash(.error, delay: 1.5) { finished in //provides users with error message
                        self.errorLabel.text = e.localizedDescription
                        self.errorLabel.isHidden = false
                    }
                }
                else{
                        //Sign in the new user created
                        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
                            if let e = error { // / if error occurs when creating account
                                self.errorLabel.text = e.localizedDescription
                                self.errorLabel.isHidden = false // informs user of error and shows it to the console log
                                print("ISSUE : Couldn't sign in user . Error : \(e.localizedDescription)")
                            }
                            else{
                                print("User Signed In Sucessfully!")
                                HUD.flash(.success, delay: 1.5) { finished in
                                    print("Performing Segue to User Datails Screen") // displays sign in sucess message to user and console log
                                    self.performSegue(withIdentifier: "welcomeVCtoUserDetailsVC", sender: self)//sends user to the next screen to enter their registration details
                                }
                            }
                        }
                    }
            } // authResult closure
        } // if let closure
    }
}



