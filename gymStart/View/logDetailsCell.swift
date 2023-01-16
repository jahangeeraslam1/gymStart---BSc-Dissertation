//
//  logDetailsCell.swift
//  gymStart
//
//  Created by Jahangeer Aslam on 08/03/2021.
//

import UIKit

class logDetailsCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }


    @IBOutlet weak var reps: UILabel!
    @IBOutlet weak var weight: UILabel!
    @IBOutlet weak var set: UILabel!
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
