//
//  exerciseGroupsCell.swift
//  gymStart
//
//  Created by Jahangeer Aslam on 01/03/2021.
//

import UIKit

class templateCellForES: UITableViewCell {
    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var cellLabel: UILabel!
    @IBOutlet weak var cellImageView: UIImageView!
    
    

    override func awakeFromNib() {
        super.awakeFromNib()
        
        cellView.layer.cornerRadius = 20 //allows the collection cell to have round corners
        // Initialization code for anything in the .xib file
    }
    
    


    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
