//
//  showLogDetailsViewController.swift
//  gymStart
//
//  Created by Jahangeer Aslam on 08/03/2021.
//

import UIKit

class showLogDetailsViewController: UIViewController {
    
    @IBOutlet weak var logDetailsTableView: UITableView!
    @IBOutlet weak var exGroup: UILabel!
    @IBOutlet weak var exName: UILabel!
    @IBOutlet weak var exDateAndTime: UILabel!
    var exData : [String : [Int]]?
    
    @IBOutlet weak var tile1View: UIView!
    var exLog : logsStruct?

    override func viewDidLoad() {
        super.viewDidLoad()
        logDetailsTableView.dataSource = self
       // logDetailsTableView.delegate = self only needed if we are clicking on the cell
        
        logDetailsTableView.register(UINib(nibName: "logDetailsCell", bundle: nil), forCellReuseIdentifier: "logDetailsCell-ReuseID")
        
        
        if let exLog = exLog {
            exName.text = exLog.exName
            exGroup.text = exLog.exGroup
            exDateAndTime.text = exLog.exDateAndTime
            
            exData = exLog.exData
  
            print ("Exercise Name is \(exName.text!)")
            print("Exericse Group is \(exGroup.text!)")
            print("Exercise Data is...")
            for x in exData!{
                print(x)
            }
            print(exData!.count)
        }
        tile1View.layer.cornerRadius = 25

    }
    

}

extension showLogDetailsViewController : UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return exData?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "logDetailsCell-ReuseID", for: indexPath) as! logDetailsCell
        
        
       // cell.cellLabel.text = loggedExerciseNames[indexPath.row]
        print(exData!.keys)
        //for item in Array(exData!.keys){
        let sortedData = Array(exData!.keys).sorted(by : <)
        let set = sortedData[indexPath.row]

        print("Sorted data is .....\(sortedData)")
        
        cell.set.text = set
        let tempArray = exData![set]
        print("Temp array is \(tempArray!)")

        cell.reps.text = "\(tempArray![1])"
        cell.weight.text = "\(tempArray![0]) KG"
  
      
        return cell

     
    }
    
    
    
    
}

