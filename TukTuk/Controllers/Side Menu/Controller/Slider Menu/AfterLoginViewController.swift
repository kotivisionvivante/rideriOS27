//


import UIKit

class AfterLoginViewController: SideMenu, SideMenuDelegate {

    override public func awakeFromNib() {
        super.awakeFromNib()
        self.menuPreferredStatusBarStyle = .lightContent
        self.contentViewShadowColor = .black
        self.contentViewShadowOffset = CGSize(width: 0, height: 0)
        self.contentViewShadowOpacity = 0.6
        self.contentViewShadowRadius = 12
        self.contentViewShadowEnabled = true
        self.contentViewController = self.storyboard!.instantiateViewController(withIdentifier: "DashboardViewController")
        self.leftMenuViewController = self.storyboard!.instantiateViewController(withIdentifier: "kLeftMenuView")
        self.rightMenuViewController = self.storyboard!.instantiateViewController(withIdentifier: "kRightMenuView")
        self.delegate = self
    }

    override public func viewDidLoad() {
        super.viewDidLoad()
        hideNavigationBar()
        self.parallaxEnabled = false
        self.panGestureLeftEnabled = false
        self.panGestureRightEnabled = false
    }

    override public func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Helper Methods
    
    override var prefersStatusBarHidden: Bool {
        return false
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        hideNavigationBar()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        hideNavigationBar()
        super.viewDidDisappear(animated)
    }

    // MARK: - <SideMenuDelegate>

    public func sideMenu(_ sideMenu: SideMenu, willShowMenuViewController menuViewController: UIViewController) {
        print("willShowMenuViewController")
    }

    public func sideMenu(_ sideMenu: SideMenu, didShowMenuViewController menuViewController: UIViewController) {
        print("didShowMenuViewController")
    }

    public func sideMenu(_ sideMenu: SideMenu, willHideMenuViewController menuViewController: UIViewController) {
        print("willHideMenuViewController")
    }

    public func sideMenu(_ sideMenu: SideMenu, didHideMenuViewController menuViewController: UIViewController) {
        print("didHideMenuViewController")
    }
}


extension UIViewController {

    public var sideMenuViewController: SideMenu? {
        get {
            guard var iterator = self.parent else { return nil }
            guard let strClass = String(describing: type(of: iterator)).components(separatedBy: ".").last else { return nil }

            while strClass != nibName {
                if iterator is SideMenu {
                    return iterator as? SideMenu
                } else if iterator.parent != nil && iterator.parent != iterator {
                    iterator = iterator.parent!
                }
            }
            return nil
        }
        set(newValue) {
            self.sideMenuViewController = newValue
        }
    }

    // MARK: - Public
    // MARK: - IBAction Helper methods

    @IBAction public func presentLeftMenuViewController(_ sender: AnyObject) {
        self.sideMenuViewController?.presentLeftMenuViewController()
    }

    @IBAction public func presentRightMenuViewController(_ sender: AnyObject) {
        self.sideMenuViewController?.presentRightMenuViewController()
    }
}
