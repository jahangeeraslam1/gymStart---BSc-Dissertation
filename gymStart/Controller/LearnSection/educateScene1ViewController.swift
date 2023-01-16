//
//  learnSceneViewController.swift
//  gymStart
//
//  Created by Jahangeer Aslam on 11/01/2021.
//

import UIKit

class educateScene1ViewController: UIViewController {
 

    @IBOutlet weak var tableView: UITableView!
    
    // datastructure for front page shows bodypart name and cell image
    var exerciseGroups = Data.educateTab.exerciseGroups
    // sets each of the bodyParts to have multiple exercises to undertake
    var exerciseNames = Data.educateTab.exerciseNames
    
    // detailes for every exercise
    var listOfAllExercises = Data.educateTab.listOfAllExercises
    
    // Do any additional setup after loading the view.
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.rowHeight = 125
        
        //registers the tableView custom cell type
        tableView.register(UINib(nibName: "templateCellForES", bundle: nil), forCellReuseIdentifier: "templateCellForES-ID")
        
        //looks to the extension classes to
        tableView.dataSource = self // 1) get the data for the cell
        tableView.delegate = self// 2) check what happens when cell is pressed
        
        
        
    }
     override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.dataSource = self // 1) get the data for the cell
        tableView.delegate = self// 2) check what happens when cell is pressed
        //hides the navigation bar after it has appeared

        navigationController?.setNavigationBarHidden(true, animated: animated)
        
    }
    
    
    //prepares the data the next view controller will need
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // gets the index value of the current row
        let indexPath = tableView.indexPathForSelectedRow
        let index = indexPath?.row
        
        //sets which bodyPart has been selected based on the index value of the user's selection
        let selectedBodyPart = exerciseGroups[index!].body
        
        // bodyPartExercises now contains a list of all the exercises for that bodyPart e.g. ['ex1', 'ex2' etc...]
        let bodyPartExercises = exerciseNames[selectedBodyPart]!
        
        //create the empty structure to read in deails about the selected exercises
        var detailsOfSelectedExercises : [exercisesStruct] = []
        
        for name in bodyPartExercises{ //for each of the exercise names
            
            for i in 0..<listOfAllExercises.count { // look through every item in the listOfAllExercises
                
                if listOfAllExercises[i].exerciseName == name { // when we find a match for the exericses name
                    detailsOfSelectedExercises.append(listOfAllExercises[i])// pull the data for it into the detailsOfSelectedExercises dictionary
                }
            }
        }
        
        
        
        
        print("User has selected the exercise group \(selectedBodyPart)")
        print("The exercises in this group are :  \(bodyPartExercises)")


        //create an instance of exerciseInfoTemplate and set the variables we want to send across in
        let nextScene = segue.destination as! educateScene2ViewController
        nextScene.exerciseGroupName = selectedBodyPart
        nextScene.bodyPartExercises = bodyPartExercises
        nextScene.detailsOfSelectedExercises = detailsOfSelectedExercises
        

    }
    

 

    
     
}

// this extension is responsbile for populating the tableView E.G no of cells it needs and what text to show
extension educateScene1ViewController : UITableViewDataSource{
    
    // shows how many rows to print
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return exerciseGroups.count // we used the length of our exercises struct here
    }
    
    //populates the tableView - for each cell this method is called
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "templateCellForES-ID", for: indexPath) as! templateCellForES  // use as! to make use our custom cell type defined in exerciseGroupsCell.xib
       
        // indexPath.row - gets that current cells index number
        // use that to tap into that row in the exerciseGroups struct
        //finally we assign that to the custom cell's exerciseLabel
        let bodyPart = exerciseGroups[indexPath.row].body
        cell.cellLabel.text = bodyPart
        
        //gets the image refrence from exerciseGroups dictionary value
        let bodyPartImage = exerciseGroups[indexPath.row].image
        //converts the image refrence to an image and allocates it to the cell
        cell.cellImageView.image = UIImage(imageLiteralResourceName: bodyPartImage)
        return cell
    }
}
//what happens when we click a row
extension educateScene1ViewController : UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showExercisesForGroup", sender: nil)
    }
}






