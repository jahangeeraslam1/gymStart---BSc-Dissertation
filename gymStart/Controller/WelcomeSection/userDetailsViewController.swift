//
//  userDetailsViewController.swift
//  gymStart
//
//  Created by Jahangeer Aslam on 09/03/2021.
//

import UIKit
import Firebase
import PKHUD

class userDetailsViewController: UIViewController {
    
    @IBOutlet weak var firstNameTF: UITextField!
    
    @IBOutlet weak var lastNameTF: UITextField!
    
    @IBOutlet weak var userGoalTF: UITextField!
    
    @IBOutlet weak var userAgeLabel: UILabel!
    
    @IBOutlet weak var errorLabel: UITextView!
    let userGoals  = ["Gain Muscle", "Lose Fat", "Improve Overall Health", "Other"]
     
    var pickerView = UIPickerView()
    
    
    let gymStartDB = Firestore.firestore()
    
    var stepperClickedBool = false
    
    @IBOutlet weak var ageStepper: UIStepper!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(true, animated: true) // hides nav bar
        
        userGoalTF.inputView = pickerView
        pickerView.dataSource = self
        pickerView.delegate = self

        ageStepper.value = 16
        ageStepper.wraps = true
        ageStepper.autorepeat = true
        ageStepper.maximumValue = 100
        ageStepper.minimumValue = 16
        userAgeLabel.text = "16"
        userAgeLabel.isHidden = true
        
        
        errorLabel.isHidden = true
        

        // Do any additional setup after loading the view.
    }
    
    @IBAction func ageStepperValueChanged(_ sender: UIStepper) {
        
     
        userAgeLabel.text  = Int(sender.value).description
        
        stepperClickedBool = true
        
        userAgeLabel.isHidden = false
        
    }
    
    @IBAction func doneButtonPressed(_ sender: UIButton) {
        
        if firstNameTF.text!.isEmpty || lastNameTF.text!.isEmpty || userGoalTF.text!.isEmpty || stepperClickedBool == false {
            errorLabel.isHidden = false
            
            errorLabel.text = "Please complete all the fields!"
            HUD.flash(.error, delay: 1.5)
        }
        else {
            print(" User's First Name is \(firstNameTF.text!) ")
            print(" User's Last Name is \(lastNameTF.text!) ")
            print(" User's Age is \(userAgeLabel.text!) ")
            print(" User's Age is \(userGoalTF.text!) ")
            print("About to attempt to register details to Database!")
          
            
            
            errorLabel.isHidden = true
            //registers new user details into profiles database
            if let newUser = Auth.auth().currentUser { // check the user is signed in
                let userData : [String :Any] = [ // create key value pairs for the data we wish to store
                    "firebaseUserName" : newUser.uid,
                    "email" : newUser.email!,
                    "firstName" : firstNameTF.text!,
                    "lastName" : lastNameTF.text!,
                    "age" : userAgeLabel.text!,
                    "exerciseGoal" : userGoalTF.text!
                ]
                self.gymStartDB.collection("profiles").document(newUser.email!).setData(userData)//save this data to the doucment with the user's email as the documentID
                {
                    (error) in
                    if let e = error { // checks for errors and prints them to console log
                        print("ISSUE : Couldn't register user details. Error : \(e.localizedDescription)")
                        
                    }
                    else{ // informs user of sucess if no error detected
                        print("User Details Registered Sucessfully!")
                        HUD.flash(.success, delay: 1.5) { finished in
                            print("Performing Segue to Home Screen")
                            self.performSegue(withIdentifier: "userDetailsVCtotabBarVC", sender: self)
                        }
                    }
                }
                
            }
            

        }
    }
    
    
    

}
extension userDetailsViewController : UIPickerViewDelegate, UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    //number of rows the pickerview shows
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return userGoals.count
    }
    //gets the titles the pickerview displays
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return userGoals[row]
    }
    //puts our selection from the picker view into the userGoalTF
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        userGoalTF.text = userGoals[row]
        //userGoalTF.resignFirstResponder()
    }
    
    
    
  
    
    
    
    
    
}
