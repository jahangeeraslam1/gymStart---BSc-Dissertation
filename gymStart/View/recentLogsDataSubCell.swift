//
//  recentLogsDataSubCellTableViewCell.swift
//  gymStart
//
//  Created by Jahangeer Aslam on 12/03/2021.
//

import UIKit

class recentLogsDataSubCell: UITableViewCell {
    
    @IBOutlet weak var reps: UILabel!
    @IBOutlet weak var weight: UILabel!
    @IBOutlet weak var set: UILabel!
    @IBOutlet weak var cellView: UIView!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        cellView.layer.cornerRadius = 25
        cellView.layer.masksToBounds = false
   

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
