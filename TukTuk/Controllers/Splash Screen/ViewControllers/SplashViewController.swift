//


import UIKit

class SplashViewController: UIViewController {

    //MARK:- Outlets
    @IBOutlet weak var prgressBar: UIProgressView!
    
    //MARK:- Variables
    let progress = Progress(totalUnitCount: 2)
    
    //MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        hideNavigationBar()
        prgressBar.transform = prgressBar.transform.scaledBy(x: 1, y: 5)
        self.startProgressTimer()
        
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    
}

//MARK:- Custom Methods
extension SplashViewController {
    
    func startProgressTimer() {
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { (timer) in
            guard self.progress.isFinished == false else {
                timer.invalidate()
                print("finished")
                let isUserLoggedIn = k_UserDef.bool(forKey: IS_USER_LOGGED_IN)
                if let isSkipTutorial = k_UserDef.value(forKey: SKIP_TUTORIAL) as? Bool {
                    if isUserLoggedIn {
                        Singleton.shared.setHomeView()
                    } else {
                        if isSkipTutorial == true {
                            self.perform(#selector(SplashViewController.goToLoginView), with: nil, afterDelay: 0.5)
                        } else {
                            self.perform(#selector(SplashViewController.goToTutorialViews), with: nil, afterDelay: 1.0)
                        }
                    }
                    
                } else {
                    self.perform(#selector(SplashViewController.goToTutorialViews), with: nil, afterDelay: 1.0)
                }
                return
            }
            self.progress.completedUnitCount += 1
            let progressFloat = Float(self.progress.fractionCompleted)
            self.prgressBar.setProgress(progressFloat, animated: true)
        }
    }
}

//MARK:- Action
extension SplashViewController {
    @objc func goToTutorialViews() {
        self.performSegue(withIdentifier: Controller.TutorialOneVC.rawValue, sender: nil)
    }
    @objc func goToLoginView() {
        self.pushVC(storyboard: .Landing, viewController: .PhoneVerifyVC, animated: false) { (vc) in }
    }
}
