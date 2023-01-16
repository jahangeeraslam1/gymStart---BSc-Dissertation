//
//  educateScene2ViewController.swift
//  gymStart
//
//  Created by Jahangeer Aslam on 02/03/2021.
//



import UIKit

class educateScene2ViewController: UIViewController {
    
    
    
    //set up varaibles for to get data from previous scene
    var exerciseGroupName : String!
    var bodyPartExercises : [String]!
    var detailsOfSelectedExercises : [exercisesStruct] = []

 
    @IBOutlet weak var tableView: UITableView!
    
    
    // Do any additional setup after loading the view.
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.rowHeight = 125
        
       
        
        //registers the tableView custom cell type
        tableView.register(UINib(nibName: "templateCellForES", bundle: nil), forCellReuseIdentifier: "templateCellForES-ID")
        
        //looks to the extension classes to
       
        //shows the group name but if there is a problem with it it shows a space
        title = "\(exerciseGroupName ?? " " )" // title for the nav bar
        //
        
        

    }
    
    //shows the navigation bar if hidden
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
        tableView.dataSource = self // 1) get the data for the ells
        tableView.delegate = self// 2) perfrom an action when a cell is pressed
    }
    
    
    //prepares the data the next scene will need after segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       
        // gets the index value of the current row
        let indexPath = tableView.indexPathForSelectedRow
        let index = indexPath?.row

        //select the exercise name + instructions from the detailsOfSelectedExercises dictionary
        let exerciseName = detailsOfSelectedExercises[index!].exerciseName
        let exerciseInstructions = detailsOfSelectedExercises[index!].exerciseInstructions
        
        //selects the relevant images for this exercise
        var imageArray = [String]()
        imageArray = detailsOfSelectedExercises[index!].exerciseImages

        print("User has selected the exercise \(exerciseName)")
        print("The instructions for thie exercise are \(exerciseInstructions)")
        print("The images for this exercise are \(imageArray)")
   

        //create an instance of exerciseInfoTemplate and set the variables we want to send across in
        let exerciseInfoPage = segue.destination as! exerciseInfoTemplate
        exerciseInfoPage.exerciseName = exerciseName
        exerciseInfoPage.exerciseInstructions = exerciseInstructions
        exerciseInfoPage.imageArray = imageArray


    }
    
}




// this extension is responsbile for populating the tableView e.g number of cells to create and what data to put in them
extension educateScene2ViewController : UITableViewDataSource{
    
    // this method sets number of sells to create
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bodyPartExercises.count // we used the length of our exercises struct here
    }
    
    
    
    //this method is going to be called for each value in bodyPartExercises.count ansd sets what data to put in the cells
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "templateCellForES-ID", for: indexPath) as! templateCellForES // use as! to make a cell of a custom type defined in exerciseGroupsCell.xib
        let exerciseName = bodyPartExercises[indexPath.row]
        cell.cellLabel.text = exerciseName
        // use indexPath.row to get that current cells index number
        // then we use that to tap into that row in the exerciseGroups struct
        //finally we assign that to the custom cell's label
        
        var imageArray : [String] = []
        // gets the first image for each object in the detailsOfSelectedExercises dictonary
        
        for i in detailsOfSelectedExercises {
            let temp = i.exerciseImages
            imageArray.append(temp[0])
        }
        // these images are then set into thier designated cell
        let exerciseImage = imageArray[indexPath.row]
        cell.cellImageView.image = UIImage(imageLiteralResourceName: exerciseImage)
        
        //displays the cell on the screen
        return cell
        
    }

}

extension educateScene2ViewController : UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showExerciseDetails", sender: nil)
    }
}

