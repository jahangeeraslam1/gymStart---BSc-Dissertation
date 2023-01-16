//
//  logSectionViewController.swift
//  gymStart
//
//  Created by Jahangeer Aslam on 07/03/2021.
//

import UIKit

class logSectionViewController: UIViewController {

    @IBOutlet weak var newLogButton: UIButton!
    @IBOutlet weak var showLogsButton: UIButton!
    
    @IBOutlet weak var newLogButtonView: UIView!
    
    @IBOutlet weak var spaceView: UIView!
    @IBOutlet weak var showLogsButtonView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Logs"
        newLogButtonView.layer.cornerRadius = 25
        newLogButton.layer.cornerRadius = 25
        showLogsButtonView.layer.cornerRadius = 25
        showLogsButton.layer.cornerRadius = 25


    }
    
    //SHOWS the navigation bar and hides the back button
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    

    }
    
    @IBAction func unwind( _ seg: UIStoryboardSegue) {
    }
    
    

}
