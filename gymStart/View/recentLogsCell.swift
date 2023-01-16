//
//  recentLogsCell.swift
//  gymStart
//
//  Created by Jahangeer Aslam on 12/03/2021.
//

import UIKit
import Firebase

class recentLogsCell: UICollectionViewCell {
    
    //sets up collection cell outlets
    @IBOutlet weak var exName: UILabel!
    @IBOutlet weak var exGroup: UILabel!
    @IBOutlet weak var cellView: UIView!
    var exData : [String : [Int]]?
    
    let gymStartDB = Firestore.firestore()
    @IBOutlet weak var recentLogsTableView: UITableView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        cellView.layer.cornerRadius = 25 //allows the collection cell to have round corners
       recentLogsTableView.register(UINib(nibName: "recentLogsDataSubCell", bundle: nil), forCellReuseIdentifier: "recentLogsDataSubCell-ReuseID")
        recentLogsTableView.dataSource = self
        recentLogsTableView.delegate = self
        
        DispatchQueue.main.async { //keeps the information in the LogsTableview up to date
            self.recentLogsTableView.reloadData()
            self.recentLogsTableView.reloadInputViews()
        }
        recentLogsTableView.backgroundColor = UIColor .clear
    }

    
}


extension recentLogsCell : UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return exData?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "recentLogsDataSubCell-ReuseID", for: indexPath) as! recentLogsDataSubCell
        print(exData!.keys)
        let sortedData = Array(exData!.keys).sorted(by : <)
        let set = sortedData[indexPath.row]
        let tempArray = exData![set]
        cell.set.text = set
        cell.reps.text = "\(tempArray![1]) reps"
        cell.weight.text = "\(tempArray![0]) KG"
        return cell

     
    }

    
}


