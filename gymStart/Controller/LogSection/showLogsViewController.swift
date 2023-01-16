//
//  showLoggedExercisesViewController.swift
//  gymStart
//
//  Created by Jahangeer Aslam on 07/03/2021.
//

import UIKit
import Firebase


class showLogsViewController: UIViewController {
    @IBOutlet weak var logsTableView: UITableView!
    
    var noOfUserLogs : Int?
    var loggedExerciseGroups : String?
    var loggedExerciseNames : [String] = []
    let gymStartDB = Firestore.firestore()
    
    var logsCollection : [logsStruct] = []
    
    override func viewDidLoad() {
        
            getUserLogs()
            logsTableView.dataSource = self        // 1) get the data for the cell
            logsTableView.delegate = self         // 2) ßcheck what happens when cell is p
    
        
        
        super.viewDidLoad()
        self.logsTableView.rowHeight = 100
    
        //registers the logsTableView custom cell type
        logsTableView.register(UINib(nibName: "userLogsCell", bundle: nil), forCellReuseIdentifier: "userLogsCell-ReuseID")
        
        
        

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    
    func getUserLogs(){

        //gets the collection
        if let currentUser = Auth.auth().currentUser{
            let docRefrence = gymStartDB.collection("profiles").document(currentUser.email!).collection("userExeriseLogs")
            //checks if we can get documents from that collection
            ///
             //   .order(by: "timeStamp", descending: true).limit(to: 2)
            // use this to order for the last 3 entries on the homepage
            // design cell first
            // then show first 3 enteries in a table view vb  
            docRefrence.getDocuments{
            (QuerySnapshot, error) in
            if let e = error{
                print("There was an error getting data from Database. Error Code : \(e.localizedDescription)")

            }
            else{
                // loops through all logs in the collection
                for doc in QuerySnapshot!.documents{
                    let log = doc.data()
                    //print("\(doc.documentID) => \(doc.data())")
                    print("Log Number: \(log["logID"]!)")
                    print("Exercise Group : \(log["exerciseGroup"]!)")
                    print("Exercise Name : \(log["exerciseName"]!)")
                    print("Exercise Data : \(log["exerciseData"]!)")
                    
                    print("No. of User Logs : \(QuerySnapshot!.documents.count)")
          
                    self.noOfUserLogs = QuerySnapshot!.documents.count //sets the number of logs in the collection
                    
                    let logID = log["logID"] as? Int
                    let exName = log["exerciseName"]! as? String
                    let exGroup = log["exerciseGroup"]! as? String
                    let firebaseTimeStamp = log["firebaseTimeStamp"] as? String
                    let exDateAndTime = log["exerciseDateAndTime"] as? String
                   
                    let exData = log["exerciseData"] as? [String : [Int]]
                    self.logsCollection.append(logsStruct(logID : logID , exName: exName, exGroup: exGroup, exData: exData, firebaseTimeStamp : firebaseTimeStamp, exDateAndTime : exDateAndTime))
            
                    DispatchQueue.main.async {
                        self.logsTableView.reloadData() // ensures the table view updates after we retireve the cell data
                    }
       
                }
                
            }

            }
        }
    }
}


extension showLogsViewController : UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return noOfUserLogs ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "userLogsCell-ReuseID", for: indexPath) as! userLogsCell
        
        
       // cell.cellLabel.text = loggedExerciseNames[indexPath.row]
        

        
        let selectedLog = logsCollection[indexPath.row]
        print("selectedLog is \(selectedLog)")
        print("Whole logs collection is \(logsCollection)")
        
        cell.logDetails.text = "\(selectedLog.exName ?? " ") | \(selectedLog.exGroup ?? " ")"
        cell.logID.text = "Log \(selectedLog.logID ?? 0)"
    
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // gets the index value of the current row
        let indexPath = logsTableView.indexPathForSelectedRow
        let index = indexPath?.row
        print("Segue prepped 1")
        if segue.destination is showLogDetailsViewController{
            let vc = segue.destination as? showLogDetailsViewController
            vc?.exLog = logsCollection[index!]
            
            
            print("Segue prepped 2 ")
            
        }

    }

    
 


    
    
}
extension showLogsViewController : UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showLogDetails", sender: nil)
    }
}

