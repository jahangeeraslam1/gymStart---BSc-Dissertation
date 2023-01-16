//
//  logSceneViewController.swift
//  gymStart
//
//  Created by Jahangeer Aslam on 17/02/2021.
//

import Foundation
import UIKit
import Firebase
import PKHUD


class performExerciseViewController : UIViewController{
    
    var exerciseGroup : String = ""
    var exerciseName : String = ""
    
    
    @IBOutlet weak var exerciseNameLabel: UILabel!
    @IBOutlet weak var exerciseGroupLabel: UILabel!
    
    @IBOutlet weak var setNumberLabel: UILabel!
    @IBOutlet weak var nextSetButton: UIButton!
    @IBOutlet weak var previousSetButton: UIButton!
    
    
    @IBOutlet weak var weightLabel: UILabel!
    @IBOutlet weak var weightSlider: UISlider!
    @IBOutlet weak var weightView: UIView!
    
    @IBOutlet weak var instructionsTextView: UITextView!
    
    @IBOutlet weak var repsLabel: UILabel!
    @IBOutlet weak var repsSlider: UISlider!
    @IBOutlet weak var repsView: UIView!
    
    
    @IBOutlet weak var saveSetButton: UIButton!
    @IBOutlet weak var cancelExerciseButton: UIButton!
    @IBOutlet weak var endExerciseButton: UIButton!
    
    let setArray = Data.logsTab.setArray
    var workoutData : [String : [Int]] = [:]
    var count : Int = 0
    
    var timer: Timer?
    var runCount = 0
    
    let gymStartDB = Firestore.firestore()
  
                                        

    

    

    
    // Do any additional setup after loading the view.
    override func viewDidLoad() {
        super.viewDidLoad()
        self.workoutData = [:]
        //displays the exercise name and group
        exerciseNameLabel.text = exerciseName
        exerciseGroupLabel.text = "Exercise Group : \(exerciseGroup)"
        
        //disables previousSetButton
        self.previousSetButton.isEnabled = false
        self.previousSetButton.alpha = 0.5
        
        //dislpays the starting set as SET 1
        setNumberLabel.text = "\(setArray[0])"
        
        //sets inital slider values to 0
        self.repsSlider.value = 1
        self.weightSlider.value = 1
        
        //round the corners on the views
        weightView.layer.cornerRadius = 25
        repsView.layer.cornerRadius = 25
        
        // hides labels which are not needed yet
        self.repsLabel.isHidden = true
        self.weightLabel.isHidden = true
        self.instructionsTextView.isHidden = false
        
        
        
        
        
        
    }
    
    // hides the nav bar
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    
    
    @IBAction func nextSetButtonClicked(_ sender: UIButton) {
       
        if count < setArray.count - 1  {
            count = count + 1
            updateSetLabel()
            previousSetButton.isEnabled = true
            previousSetButton.alpha = 1
            self.instructionsTextView.isHidden = false

        }
        else{
            print("Max Set Reached by User")
            // disable the next button once max set has been reached
            if (count == setArray.count - 1){
                nextSetButton.isEnabled = false
                nextSetButton.alpha = 0.5
            }
        }
        updateSliders()
    }
    
    
    
    
    @IBAction func previousSetButtonClicked(_ sender: UIButton) {
        
        if count > 0 {
            count = count - 1
            updateSetLabel()
            nextSetButton.isEnabled = true
            nextSetButton.alpha = 1
            self.instructionsTextView.isHidden = false
        }
        else{
            print("Min Set Reached by User")
            // dull the back button once min set has been reached
            if (count == 0){
                previousSetButton.isEnabled = false
                previousSetButton.alpha = 0.5
            }
        }
        updateSliders()
    }
    

    
    
   
    
    
    // updates slider labels to match slider values
    func updateSliderLabels(){
        weightLabel.text = "\(Int(weightSlider.value))" + " KG"
        repsLabel.text = "\(Int(repsSlider.value))" + " Reps"
    }

    // shows weightLabel for WeightSlider + keeps label up to date
    @IBAction func WSChangedValue(_ sender: Any) {
        weightLabel.isHidden = false
        updateSliderLabels()
        
    }
    // shows repsLabel for RepsSlider + keeps label up to date
    @IBAction func RSChangedValue(_ sender: Any) {
        repsLabel.isHidden = false
        updateSliderLabels()
        
    }
    // updates the sliders based on previously saved user defined values
    func updateSliders(){
        var setData : [Int]
        if workoutData[setArray[count]] != nil {
            setData = workoutData[setArray[count]]!
            weightSlider.value = Float(setData[0])
            repsSlider.value = Float(setData[1])
            weightLabel.isHidden = false
            repsLabel.isHidden = false
        }
        else{
            weightSlider.value = 1
            weightLabel.isHidden = true
            repsSlider.value = 1
            repsLabel.isHidden = true
        }
        updateSliderLabels()
    }
    
    
    // keeps the setLabel updated
    func updateSetLabel(){
        setNumberLabel.text = "\(setArray[count])"
    }
    
    
    
    
    @IBAction func saveSetButtonPressed(_ sender: Any){
        // if the sliders have been set
        if weightSlider.value != 1 , repsSlider.value != 1 {
            
            instructionsTextView.isHidden = true // hide the instructions label
            saveSetButton.isEnabled = false
            saveSetButton.alpha = 0.5 // disable the button to avoid user pressing it twice
            let x = Int(weightSlider.value)
            let y = Int(repsSlider.value)
            let setData = [x,y]
            workoutData[setArray[count]] = setData   // add the data to the workoutData key value pair
            let currentSet: String = setArray[count]
        
        // informs user the of the outcome if the set was saved or if any error occurred
            HUD.flash(.labeledSuccess(title: "Success", subtitle: "\(currentSet) saved!"), delay: 1.0)
            PKHUD.sharedHUD.dimsBackground = true
            PKHUD.sharedHUD.userInteractionOnUnderlyingViewsEnabled = false
        }
        else{
            HUD.flash(.labeledError(title: "Error", subtitle: "Exercise set data not entered"), delay: 1.0)
            PKHUD.sharedHUD.dimsBackground = true
            PKHUD.sharedHUD.userInteractionOnUnderlyingViewsEnabled = false
        }
        saveSetButton.isEnabled = true
        saveSetButton.alpha = 1
    }
    

    
    @IBAction func cancelExerciseButtonPressed(_ sender: UIButton) {
        print("Exercise Cancelled By user")
        HUD.flash(.labeledProgress(title: "Cancelling...", subtitle: ""),delay: 1.0)
        performSegue(withIdentifier: "unwindToLogsSection", sender: self)
      
    }
    @IBAction func endExerciseButtonPressed(_ sender: UIButton) {
        
        if workoutData.count != 0 { // if data has been saved
            let randomInt = Int.random(in: 1000..<10000)
            let logID = "Log \(randomInt)"
    
            let timeStamp = Firebase.Timestamp.init()
            if let currentUser = Auth.auth().currentUser{ // and the user is signed in
                print ("The current user is \(currentUser.email!)")
                
                let rightNow = Date()
                let fmatter = DateFormatter()
                fmatter.dateStyle = .medium
                fmatter.timeStyle = .short
                let currentDateandTime = fmatter.string(from: rightNow) // gets the current date and time from system
               
                print("Attempting to save exercise data")
                print("Execise data is \n \(workoutData)")
                //formats data into key value pairs and adds a new doucment to the user exerciseLogs collection inside the user's account in the backend database
                gymStartDB.collection("profiles").document(currentUser.email!).collection("userExeriseLogs").document(logID).setData([
                                                            "logID"         : randomInt,
                                                            "exerciseName"  : exerciseName,
                                                            "exerciseGroup" : exerciseGroup,
                                                            "exerciseData"  : workoutData,
                                                    "firebaseTimeStamp"     : timeStamp,
                                                    "exerciseDateAndTime" : currentDateandTime
                                                            ])
                {(error) in
                    if  error != nil {
                        print("There was an issue detected saving data to GymStartDB")
                    }
                    else{
                        print("Exercise Data Saved to Database Sucessfully")
                        print("Performing segue back to Logs Screen")
                        self.performSegue(withIdentifier: "unwindToLogsSection", sender: self)
                        HUD.flash(.labeledSuccess(title: "Success", subtitle: "Exercise Saved!"), delay: 2.5)
                        PKHUD.sharedHUD.dimsBackground = true
                        PKHUD.sharedHUD.userInteractionOnUnderlyingViewsEnabled = false
                    }
                    
                }
            }
        }
        else{
            HUD.flash(.labeledError(title: "Error", subtitle: "No Set data has been saved"), delay: 2.5)
            PKHUD.sharedHUD.dimsBackground = true
            PKHUD.sharedHUD.userInteractionOnUnderlyingViewsEnabled = false
        }

    }
    
    
 
    
    
    
        
        
}
