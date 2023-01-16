//
//  settingsSceneViewController.swift
//  gymStart
//
//  Created by Jahangeer Aslam on 11/01/2021.
//

import UIKit
import Firebase
import PKHUD

class settingsSceneViewController: UIViewController {
    
    let gymStartDB = Firestore.firestore()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        title = "Settings"
    }
    
    // function to log out user
    @IBAction func logOutPressed(_ sender: UIButton) {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut() // if singout is sucessful pop view back to welcome screen
            navigationController?.popToRootViewController(animated: true)
        }catch let signOutError as NSError { // cacth any errors
            print ("Error signing out: %@", signOutError)
            /* currently only print our error signing out to console
             should print it out to user etc.. */
    }
    
        
    }
    
    @IBAction func clearDataPressed(_ sender: Any) {
        
        if let currentUser = Auth.auth().currentUser{
            let docRefrence = gymStartDB.collection("profiles").document(currentUser.email!).collection("userExeriseLogs")
            
            docRefrence.getDocuments{
            (QuerySnapshot, error) in
            if let e = error{
                print("There was an error getting data from Database. Error Code : \(e.localizedDescription)")
                HUD.flash(.labeledError(title: "Error", subtitle: "Can not perform action!"), delay: 2.0)
                PKHUD.sharedHUD.dimsBackground = true
                PKHUD.sharedHUD.userInteractionOnUnderlyingViewsEnabled = false
            

            }
            else{
                // loops through all logs in the collection
                for doc in QuerySnapshot!.documents{
                    let ref = doc.reference
                    ref.delete() { error in
                        if let error = error {
                            print("Error removing document: \(error)")
                            HUD.flash(.labeledError(title: "Error", subtitle: "Can not perform action!"), delay: 2.0)
                            PKHUD.sharedHUD.dimsBackground = true
                            PKHUD.sharedHUD.userInteractionOnUnderlyingViewsEnabled = false
                        } else {
                            print("Document  removed!")
                        }
                    }
                }
                print("All doucments removed!")
                HUD.flash(.labeledSuccess(title: "Success", subtitle: "Data Deleted!"), delay: 2.0)
                PKHUD.sharedHUD.dimsBackground = true
                PKHUD.sharedHUD.userInteractionOnUnderlyingViewsEnabled = false
            }

            }
        }
    }
                    
            


}
