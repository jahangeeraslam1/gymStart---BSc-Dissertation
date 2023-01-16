//
//  userLogsCell.swift
//  gymStart
//
//  Created by Jahangeer Aslam on 08/03/2021.
//

import UIKit

class userLogsCell: UITableViewCell {
    
    @IBOutlet weak var logID: UILabel!
    @IBOutlet weak var logDetails: UILabel!
    @IBOutlet weak var logView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        logView.layer.cornerRadius = 25
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
//file:///Users/jahangeeraslam/Desktop/gymStart/gymStart/View/Main.storyboard: error: IB Designables: Failed to render and update auto layout status foruserDashboardViewController (aCl-Ne-w0L): Failed to launch designables agent because tool was shutting down. Check the console for a more detailed description and please file a bug report at feedbackassistant.apple.com.
