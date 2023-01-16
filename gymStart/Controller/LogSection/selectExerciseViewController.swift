//
//  selectExerciseViewController.swift
//  gymStart
//
//  Created by Jahangeer Aslam on 06/03/2021.
//

import Foundation
import UIKit
import DropDown


class selectExerciseViewController : UIViewController{
    
    @IBOutlet weak var exerciseGroupView: UIView!
    
    @IBOutlet weak var exericseNameView: UIView!
    @IBOutlet weak var dropDownView1: UIView!
    @IBOutlet weak var dropDownView2: UIView!
    
    @IBOutlet weak var exerciseGroupLabel: UILabel!
    @IBOutlet weak var exerciseLabel: UILabel!
    
    var dropDown1Selected : Bool = false
    var dropDown2Selected : Bool = false
    
    let dropDown1 = DropDown()
    let dropDown2 = DropDown()
    
    //defines an empty dropdown1 values
    var dropDown1Values : [String] = []
    
    
    var exerciseNames : [String : [String]] = Data.educateTab.exerciseNames

    
    
    override func viewDidLoad() {
        
            
        super.viewDidLoad()
        
        exerciseGroupView.layer.cornerRadius = 25
        exericseNameView.layer.cornerRadius = 25
        
        dropDownView1.layer.cornerRadius = 25
        dropDownView2.layer.cornerRadius = 25
        
    
        //sets the inital text of the labels before dropdown selection
        exerciseGroupLabel.text = "Tap to select a group"
        exerciseLabel.text = "Tap to select an exercise"
        
        //reads in the dropDown1 values from the dictonary(exerciseNames)
        for (x,_) in exerciseNames{
            dropDown1Values.append(x)
        }
        //sets the view of the dropdown menu to dropDownView1, dropDownView2
        //sets the values of the dropdown menu
        dropDown1.anchorView = dropDownView1
        dropDown1.dataSource = dropDown1Values

        
        // ensures the dropdowns appears underneath the view and doesnt cover it
        dropDown1.bottomOffset = CGPoint(x: 0, y:(dropDown1.anchorView?.plainView.bounds.height)!)
        dropDown2.bottomOffset = CGPoint(x: 0, y:(dropDown1.anchorView?.plainView.bounds.height)!)
        dropDown1.direction = .bottom
        dropDown2.direction = .bottom
        
        
        // when a dropdown value is selected it updates the relevant label
        dropDown1.selectionAction =
            { [unowned self] (index: Int, item: String) in
            self.exerciseGroupLabel.text = item
                //looks in exercise names dictorinary for the exercises in that group
                //stores them in dropDown2Values
            let dropDown2Values = self.exerciseNames[exerciseGroupLabel.text!]
              
               //sets the datasource + vieww for the second dropdown menu
            dropDown2.anchorView = dropDownView2
            dropDown2.dataSource = dropDown2Values!
                
              //each time a chage is made to the exercise group the dropdown2 selected value resets
            self.exerciseLabel.text = "Tap to select an exercise"
                self.dropDown1Selected = true
            }
        dropDown2.selectionAction =
            { [unowned self] (index: Int, item: String) in
                self.exerciseLabel.text = item
                self.dropDown2Selected = true
            }

    }
    
    @IBAction func beginButtonClicked(_ sender: UIButton) {
        if dropDown1Selected == true , dropDown2Selected == true {
        performSegue(withIdentifier: "selectExerciseToPerformExercise", sender: self)
        }
        else{
            print("User needs to make selection first")
            //TODO : addHUD view with error saying this
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is performExerciseViewController{
            let vc = segue.destination as? performExerciseViewController
            
        
            vc?.exerciseName = exerciseLabel.text ?? ""
            vc?.exerciseGroup = exerciseGroupLabel.text ?? ""
            
            print("User has selected to undertake an the exercise \(exerciseLabel.text!) from the exercise group \(exerciseGroupLabel.text!)")
    
            print("Performing segue to the next screen!")
        }
    
    }

    
    //SHOWS the navigation bar
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
        self.dropDown1Selected = false
        self.dropDown2Selected = false
    }
    
    //shows the dropdown menues upon clicking on the view
    @IBAction func showDropDown1(_ sender: Any) {
        dropDown1.show()
    }
    @IBAction func showDropDown2(_ sender: Any) {
        dropDown2.show()
    }

 
    
    
}
