//
//  userDashboardViewController.swift
//  gymStart
//
//  Created by Jahangeer Aslam on 10/03/2021.
//

import UIKit
import Firebase
import MBCircularProgressBar

class userDashboardViewController: UIViewController {
    
    let gymStartDB = Firestore.firestore()
    
    //Backdrop view outlets
    @IBOutlet weak var dateTimeLabel: UILabel!
    @IBOutlet weak var welcomeMessage: UILabel!
    var dateTimer = Timer()
    
    //Personal Best View Outlets
    @IBOutlet weak var welcomeMessageView: UIView!
    @IBOutlet weak var tileView1: UIView!
    @IBOutlet weak var tileView2: UIView!
    @IBOutlet weak var tileView3: UIView!
    @IBOutlet weak var PB1weightNullLabel: UILabel!
    @IBOutlet weak var PB2weightNullLabel: UILabel!
    @IBOutlet weak var PB3weightNullLabel: UILabel!
    @IBOutlet weak var PB1repsNullLabel: UILabel!
    @IBOutlet weak var PB2repsNullLabel: UILabel!
    @IBOutlet weak var PB3repsNullLabel: UILabel!
    @IBOutlet weak var PB1circleView: MBCircularProgressBarView!
    @IBOutlet weak var PB2circleView: MBCircularProgressBarView!
    @IBOutlet weak var PB3circleView: MBCircularProgressBarView!
    @IBOutlet weak var PB1repsView: MBCircularProgressBarView!
    @IBOutlet weak var PB2repsView: MBCircularProgressBarView!
    @IBOutlet weak var PB3repsView: MBCircularProgressBarView!
    @IBOutlet weak var PB1exerciseName: UILabel!
    @IBOutlet weak var PB2exerciseName: UILabel!
    @IBOutlet weak var PB3exerciseName: UILabel!
    @IBOutlet weak var noPBDataView: UIView!
    var pbExerciseNames :[String] = Data.homeTab.pbTile.pbExerciseNames
    

    //Recent Logs View Outlets
    @IBOutlet weak var recentLogsCollectionView: UICollectionView!
    var recentLogs : [logsStruct] = []
    
    @IBOutlet weak var noRecentLogsView: UIView!
    
    //Daily Top Tip Outlets
    var userGoal : String?
    @IBOutlet weak var topTipTextView: UITextView!
    let topTips : [String : [String]] =
        ["Gain Muscle"            : Data.homeTab.topTipsTile.gainMuscleData,
         "Lose Fat"              : Data.homeTab.topTipsTile.looseFatData,
         "Improve Overall Health" : Data.homeTab.topTipsTile.improveOverallHealthData,
         "Other"                  : Data.homeTab.topTipsTile.otherData
        ]
                                                  
                          
    
    //when the viewLoads up execute:
    override func viewDidLoad() {
        super.viewDidLoad()
        // sets the tiles to have curves
        tileView1.layer.cornerRadius = 25
        tileView2.layer.cornerRadius = 25
        tileView3.layer.cornerRadius = 25
        
        self.noPBDataView.layer.cornerRadius = 25
        self.noRecentLogsView.layer.cornerRadius = 25
        
     
    
        
     
        
        
        dateTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateDateTimeLabel), userInfo: nil, repeats: true)
        
        recentLogsCollectionView.register(UINib(nibName: "recentLogsCell", bundle: nil), forCellWithReuseIdentifier: "recentLogsCell-ID")
        
        self.getDailyTopTip()
       
    }
    
    //each time the view appears on screen execute:
    override func viewWillAppear(_ animated : Bool) {
        super.viewWillAppear(animated)
        noPBDataView.alpha = 0.8
        noRecentLogsView.alpha = 0.8
        
        self.PB1exerciseName.text = pbExerciseNames[0]
        self.PB2exerciseName.text = pbExerciseNames[1]
        self.PB3exerciseName.text = pbExerciseNames[2]
        
        //configure the PBcircleViews
        let PBcircleViews : [MBCircularProgressBarView] = [PB1circleView,PB2circleView,PB3circleView,PB1repsView,PB2repsView,PB3repsView]
        for circleView in PBcircleViews{
            circleView.value = 0
            circleView.showValueString = false
        }
        
        //confifure the PBnullLabels
        let PBnullLabels : [UILabel] = [PB1weightNullLabel,PB2weightNullLabel,PB3weightNullLabel,PB1repsNullLabel,PB2repsNullLabel,PB3repsNullLabel]
        for nullLabel in PBnullLabels{
            nullLabel.isHidden = false
        }
    
       
        //keep this data in sync each time it is changed
        DispatchQueue.main.async {
            //PersonalBestView Data
            
           
            self.getPBs(exerciseName : self.pbExerciseNames[0],
                            pbnullLabels : [self.PB1weightNullLabel,self.PB1repsNullLabel],
                            pbCircleViews : [self.PB1circleView, self.PB1repsView])
            self.getPBs(exerciseName : self.pbExerciseNames[1],
                            pbnullLabels : [self.PB2weightNullLabel,self.PB2repsNullLabel],
                            pbCircleViews : [self.PB2circleView, self.PB2repsView])
            self.getPBs(exerciseName : self.pbExerciseNames[2],
                            pbnullLabels : [self.PB3weightNullLabel,self.PB3repsNullLabel],
                            pbCircleViews : [self.PB3circleView, self.PB3repsView])
            for nullLabel in PBnullLabels{
                    nullLabel.reloadInputViews()
            }
            
            self.getRecentLogs()
       
          
            }
        self.recentLogsCollectionView.delegate = self
        self.recentLogsCollectionView.dataSource = self
        
        //RecentExerciseLogsView Data

    }
    
    
    //gets the current date and time from the system
    @objc func updateDateTimeLabel(){
        let rightNow = Date()
        let fmatter = DateFormatter()
        fmatter.dateStyle = .medium
        fmatter.timeStyle = .medium
        let currentDateandTime = fmatter.string(from: rightNow)
        dateTimeLabel.text = currentDateandTime
    
    }
    


    func getPBs(exerciseName : String, pbnullLabels : [UILabel], pbCircleViews : [MBCircularProgressBarView]){
        var pbData : [Int] = []
        var maxWeight : Int = 0
        var reps : Int = 0
        if let currentUser = Auth.auth().currentUser{
            //gets the locations the user's logs are stored
            let userLogsRef = gymStartDB.collection("profiles").document(currentUser.email!).collection("userExeriseLogs")
            //executes query
            let query = userLogsRef.whereField("exerciseName", isEqualTo: exerciseName)
            //checks if we can get documents from that collection
            query.getDocuments{ (QuerySnapshot, error) in
                if let e = error{
                print("Error getting data from GymStartDB. Error Code : \(e.localizedDescription)")
                }
                else{ // if we can then loops through the logs
                    for doc in QuerySnapshot!.documents {
                        let log = doc.data()
                        if log["exerciseName"] as! String != exerciseName{ //checks if it matches our compound exercise
                            print("Data not Found")
                        }
                        else{
                            if let e = log["exerciseData"]{ //and if exercise data exists in here
                                let exerciseData = e as! [String : [Int]]
                               
                                for (_,data) in exerciseData{
                                    
                                    if maxWeight < data[0]{ //gets the maxWeight for that exercise and the corresponding set value
                                        maxWeight = data[0]
                                        reps = data[1]
                                    }
                                }
                                pbData = [maxWeight,reps]
                                pbnullLabels[0].isHidden = true
                                pbnullLabels[1].isHidden = true
                                UIView.animate(withDuration: 3){ // displays this data in an dynamic format onto the screen
                                    pbCircleViews[0].showValueString = true
                                    pbCircleViews[0].value = CGFloat(pbData[0])
                                    pbCircleViews[1].showValueString = true
                                    pbCircleViews[1].value = CGFloat(pbData[1])
                                    self.noPBDataView.alpha = 0
                                    print(" The PB weight for \(exerciseName) is \(pbCircleViews[0].value)")
                                    print(" The PB Reps for \(exerciseName) is \(pbCircleViews[1].value)")
                                }
                            } // closurse for exercisedata not nill
                        }//clouse for each doc in doucments
                    }
                }//else closure
            }//query docs closure
        }
        //if auth user closure
    }//function closure
    

    
    
    func getRecentLogs(){
        self.recentLogs = []
        if let currentUser = Auth.auth().currentUser{ // checks if user is signed in
            let docRefrence = gymStartDB.collection("profiles").document(currentUser.email!).collection("userExeriseLogs").order(by: "firebaseTimeStamp", descending: true).limit(to: 3)      // gets the last 3 exercise logs the user has undertaken from gymStartDB
            docRefrence.getDocuments{
            (QuerySnapshot, error) in
            if let e = error{
                print("Error getting data from GymStartDB. Error Code : Error Code : \(e.localizedDescription)")
            }
            else{
                // loops through all logs in the collection
                for doc in QuerySnapshot!.documents{
                    let log = doc.data()
                    let logID = log["logID"] as? Int
                    let exName = log["exerciseName"]! as? String
                    let exGroup = log["exerciseGroup"]! as? String
                    let exData = log["exerciseData"] as? [String : [Int]]
                    self.noRecentLogsView.alpha = 0
                    self.recentLogs.append(logsStruct(logID : logID , exName: exName, exGroup: exGroup, exData: exData))//appends the log from the users account to our localally stored recent logs collection
                    DispatchQueue.main.async {
                        self.recentLogsCollectionView.reloadData() // ensures the table view updates after we retireve the cell data
                    }
                }

            }

            }
        }
       
        }
    
    
    func getDailyTopTip(){
        if let currentUser = Auth.auth().currentUser{
            let docRefrence = gymStartDB.collection("profiles").document(currentUser.email!)
              docRefrence.getDocument{
              (document, error) in
                    if let e = error {
                        print("Error getting data from GymStartDB. Error Code : \(e.localizedDescription)")
                        }
                    else{
                        let userGoal = document!["exerciseGoal"]! as? String
                        let userName = document!["firstName"]! as? String
                        print("The current user's name is \(userName!)")
                        print("The current user's goal is \(userGoal!)")
                        if (userGoal != nil) {
                            let array = self.topTips[userGoal!]
                            let randomInt = Int.random(in: 0..<array!.count)
                            let tipForToday = array![randomInt]
                            self.topTipTextView.text = tipForToday
                            print("The users Daily Top Tip is \(tipForToday)")
                       
                        }
                        self.welcomeMessage.text = "Welcome \(userName ?? " ")!"
                    }
              }
  
    
        }
    }
            
            
        
            
            
        
        
        
}

extension userDashboardViewController : UICollectionViewDataSource,UICollectionViewDelegate{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
          return 1
      }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return recentLogs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = recentLogsCollectionView.dequeueReusableCell(withReuseIdentifier: "recentLogsCell-ID", for: indexPath)  as! recentLogsCell
        
        let log = recentLogs[indexPath.row]
        cell.exName.text = "\(log.exName ?? " ")" // if name is empty prints a blank string
        cell.exGroup.text = "Group : \(log.exGroup ?? " ")" // if group is empty prints a blank string
        cell.exData = log.exData! //sends exData over to the cell ready to add it into the UITableViiw
        cell.awakeFromNib() //sets up the cell data
        
        return cell
    }
    
    
}


