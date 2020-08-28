//


import UIKit

class TutorialOneViewController: UIViewController {
    
    //MARK:- Outlets
    @IBOutlet weak var btnNext: UIButton!
    @IBOutlet weak var lblText: UILabel!
    
    //MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        hideNavigationBar()
        //lblText.font = UIFont(name: "BebasNeue-Regular.otf", size: 107)
        
        //  MARK: - swipe
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeLeft.direction = .left
        self.view.addGestureRecognizer(swipeLeft)
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeRight.direction = .right
        self.view.addGestureRecognizer(swipeRight)
        
    }
    
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    
}

//MARK:- Action
extension TutorialOneViewController {
    
    @IBAction func btnNext_Action(_ sender: UIButton) {
        self.pushVC(storyboard: .Splash, viewController: .TutorialTwoVC, animated: true) { (vc) in }
    }
    
    @objc
    func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            switch swipeGesture.direction {
            case UISwipeGestureRecognizer.Direction.left:
                print("left")
                self.pushVC(storyboard: .Splash, viewController: .TutorialTwoVC, animated: true) { (vc) in}
            case UISwipeGestureRecognizer.Direction.right:
                print("right")
            default:
                break
            }
        }
    }
}
