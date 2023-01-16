//
//  detailedViewController.swift
//  gymStart
//
//  Created by Jahangeer Aslam on 11/01/2021.
//

import UIKit

class exerciseInfoTemplate: UIViewController, UIScrollViewDelegate {
    
    // sets up variables to add data from learnSceneViewController into
    var exerciseName : String!
    var exerciseInstructions : String!
    var imageArray = [String]()
    
    //standard variables
    @IBOutlet weak var exericseNameLabelView: UIView!
    @IBOutlet weak var exerciseNameLabel: UILabel!
    @IBOutlet weak var dataBox: UITextView!
    @IBOutlet weak var dataBoxView: UIView!
    
    //variables for image scroll
    @IBOutlet weak var imageScrollView: UIScrollView!
    @IBOutlet weak var pageControl: UIPageControl!
    var frame = CGRect.zero
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
        //reads data from the learnSceneController into this class's outlets
        exerciseNameLabel.text = exerciseName
        dataBox.text = exerciseInstructions
        dataBoxView.layer.cornerRadius = 30
        exericseNameLabelView.layer.cornerRadius = 25
        
        
        
        //imageArray holds values of images to be shown e.g ["1.png, 2.png"]
        pageControl.numberOfPages = imageArray.count
        setUpImages()
        imageScrollView.delegate = self // not sure what this does ??
        
       // title = "\(exerciseName ?? " " )"
    }
    
    func setUpImages(){
        //for the legnth of the imageArray
        for index in 0..<imageArray.count{
            print("Image Loaded : " + imageArray[index] )
            
            // The images will be positioned side-by-side in the frame of the scroll view.
            frame.origin.x = imageScrollView.frame.size.width * CGFloat(index)
            frame.size = imageScrollView.frame.size
            
            //The images are loaded and added to the scroll view.
            let imageView = UIImageView(frame: frame)
            imageView.image = UIImage(named: imageArray[index])
            
            //shows the fit of the images into the UIImageView object
            imageView.contentMode = .scaleAspectFit
            //add the image to the scrollView
            self.imageScrollView.addSubview(imageView)
            
            //The contentsize is the total size of the scrollView.
            imageScrollView.contentSize = CGSize(width: (imageScrollView.frame.size.width * CGFloat(imageArray.count)), height: imageScrollView.frame.size.height)
            imageScrollView.delegate = self
        }
    }
    
    //This method will be called when the scrolling to the next image is ended. The content offset is the relative position of the the image to the origin of the scroll view
    func scrollViewDidEndDecelerating(_ scrollView : UIScrollView){
        let pageNumber  = scrollView.contentOffset.x / scrollView.frame.size.width
        pageControl.currentPage = Int(pageNumber)
    }
    

   
 
}
