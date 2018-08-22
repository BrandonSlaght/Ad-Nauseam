import UIKit

class ViewController: UIViewController {
    
    final let FIRST_LAUNCH = "first_launch"
    
    final let STORM = "storm"
    final let WHITE = "white"
    final let RED = "red"
    final let BLUE = "blue"
    final let GREEN = "green"
    final let BLACK = "black"
    final let COLORLESS = "colorless"
    
    @IBOutlet weak var stormView: UIView!
    @IBOutlet weak var whiteView: UIView!
    @IBOutlet weak var redView: UIView!
    @IBOutlet weak var blueView: UIView!
    @IBOutlet weak var greenView: UIView!
    @IBOutlet weak var blackView: UIView!
    @IBOutlet weak var colorlessView: UIView!
    
    @IBOutlet weak var stormImage: UIImageView!
    @IBOutlet weak var plainsImage: UIImageView!
    @IBOutlet weak var mountainImage: UIImageView!
    @IBOutlet weak var islandImage: UIImageView!
    @IBOutlet weak var forestImage: UIImageView!
    @IBOutlet weak var swampImage: UIImageView!
    @IBOutlet weak var wasteImage: UIImageView!
    
    @IBOutlet weak var stormPlus: UIView!
    @IBOutlet weak var stormMinus: UIView!
    @IBOutlet weak var plainsPlus: UIView!
    @IBOutlet weak var plainsMinus: UIView!
    @IBOutlet weak var mountainPlus: UIView!
    @IBOutlet weak var mountainMinus: UIView!
    @IBOutlet weak var islandPlus: UIView!
    @IBOutlet weak var islandMinus: UIView!
    @IBOutlet weak var forestPlus: UIView!
    @IBOutlet weak var forestMinus: UIView!
    @IBOutlet weak var swampPlus: UIView!
    @IBOutlet weak var swampMinus: UIView!
    @IBOutlet weak var wastePlus: UIView!
    @IBOutlet weak var wasteMinus: UIView!
    
    @IBOutlet weak var stormCount: UILabel!
    @IBOutlet weak var plainsCount: UILabel!
    @IBOutlet weak var mountainCount: UILabel!
    @IBOutlet weak var islandCount: UILabel!
    @IBOutlet weak var forestCount: UILabel!
    @IBOutlet weak var swampCount: UILabel!
    @IBOutlet weak var wasteCount: UILabel!
    
    @IBAction func stormPlusGesture(_ sender: UILongPressGestureRecognizer) {
        handleCounterTouch(target: stormPlus, count: stormCount, up: true, gesture: sender)
    }
    @IBAction func stormMinusGesture(_ sender: UILongPressGestureRecognizer) {
        handleCounterTouch(target: stormMinus, count: stormCount, up: false, gesture: sender)
    }
    @IBAction func plainsPlusGesture(_ sender: UILongPressGestureRecognizer) {
        handleCounterTouch(target: plainsPlus, count: plainsCount, up: true, gesture: sender)
    }
    @IBAction func plainsMinusGesture(_ sender: UILongPressGestureRecognizer) {
        handleCounterTouch(target: plainsMinus, count: plainsCount, up: false, gesture: sender)
    }
    @IBAction func mountainPlusGesture(_ sender: UILongPressGestureRecognizer) {
        handleCounterTouch(target: mountainPlus, count: mountainCount, up: true, gesture: sender)
    }
    @IBAction func mountainMinusGesture(_ sender: UILongPressGestureRecognizer) {
        handleCounterTouch(target: mountainMinus, count: mountainCount, up: false, gesture: sender)
    }
    @IBAction func islandPlusGesture(_ sender: UILongPressGestureRecognizer) {
        handleCounterTouch(target: islandPlus, count: islandCount, up: true, gesture: sender)
    }
    @IBAction func islandMinusGesture(_ sender: UILongPressGestureRecognizer) {
        handleCounterTouch(target: islandMinus, count: islandCount, up: false, gesture: sender)
    }
    @IBAction func forestPlusGesture(_ sender: UILongPressGestureRecognizer) {
        handleCounterTouch(target: forestPlus, count: forestCount, up: true, gesture: sender)
    }
    @IBAction func forestMinusGesture(_ sender: UILongPressGestureRecognizer) {
        handleCounterTouch(target: forestMinus, count: forestCount, up: false, gesture: sender)
    }
    @IBAction func swampPlusGesture(_ sender: UILongPressGestureRecognizer) {
        handleCounterTouch(target: swampPlus, count: swampCount, up: true, gesture: sender)
    }
    @IBAction func swampMinusGesture(_ sender: UILongPressGestureRecognizer) {
        handleCounterTouch(target: swampMinus, count: swampCount, up: false, gesture: sender)
    }
    @IBAction func wastePlusGesture(_ sender: UILongPressGestureRecognizer) {
        handleCounterTouch(target: wastePlus, count: wasteCount, up: true, gesture: sender)
    }
    @IBAction func wasteMinusGesture(_ sender: UILongPressGestureRecognizer) {
        handleCounterTouch(target: wasteMinus, count: wasteCount, up: false, gesture: sender)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override var prefersStatusBarHidden: Bool {
        return false
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.becomeFirstResponder()

        setupWindowFirstResponder()
        setupImageBorderRadii()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        registerDefaultSettings()
        setupSelectedCounters()
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        handleFirstLaunchSetup()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func motionEnded(_ motion: UIEventSubtype, with event: UIEvent?) {
        if motion == .motionShake && hasNonzeroCounter(){
            showResetConfirmationAlert()
        }
    }
    
    func handleFirstLaunchSetup() {
        if !UserDefaults.standard.bool(forKey: FIRST_LAUNCH) {
            showFirstLaunchAlert()
            UserDefaults.standard.set(true, forKey: FIRST_LAUNCH)
        }
    }
    
    func registerDefaultSettings() {
        let stanDefaults = UserDefaults.standard
        let appDefaults = [STORM : true, RED : true, BLUE : true]
        stanDefaults.register(defaults: appDefaults)
        stanDefaults.synchronize()
    }
    
    func setupWindowFirstResponder() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(setupSelectedCounters),
            name: NSNotification.Name.UIApplicationWillEnterForeground,
            object: nil)
    }
    
    func showFirstLaunchAlert() {
        let alert = UIAlertController(title: "Welcome", message: "Remember to shake to reset the counters, and that you can control which counters are visible from the Settings app > Floating Mana", preferredStyle: .alert)
        let dismissAction = UIAlertAction(title: "Dismiss", style: .default) {
            (alert: UIAlertAction!) -> Void in
        }
        alert.addAction(dismissAction)
        present(alert, animated: true, completion:nil)
    }
    
    func showResetConfirmationAlert() {
        let alert = UIAlertController(title: "Clear Count", message: "Are you sure you want to clear the counters?", preferredStyle: .alert)
        let clearAction = UIAlertAction(title: "Clear", style: .destructive) {
            (alert: UIAlertAction!) -> Void in
            self.setCountersToZero()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .default) {
            (alert: UIAlertAction!) -> Void in
        }
        alert.addAction(clearAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion:nil)
    }
    
    func hasNonzeroCounter() -> Bool{
        return (self.stormCount.text != "0" ||
                self.plainsCount.text != "0" ||
                self.mountainCount.text != "0" ||
                self.islandCount.text != "0" ||
                self.forestCount.text != "0" ||
                self.swampCount.text != "0" ||
                self.wasteCount.text != "0")
    }
    
    func setCountersToZero() {
        self.stormCount.text = "0"
        self.plainsCount.text = "0"
        self.mountainCount.text = "0"
        self.islandCount.text = "0"
        self.forestCount.text = "0"
        self.swampCount.text = "0"
        self.wasteCount.text = "0"
    }
    
    @objc func setupSelectedCounters() {
        unhideAllCounterViews()
        showSelectedCounterViews()
    }
    
    func unhideAllCounterViews() {
        stormView.isHidden = false
        whiteView.isHidden = false
        redView.isHidden = false
        blueView.isHidden = false
        greenView.isHidden = false
        blackView.isHidden = false
        colorlessView.isHidden = false
    }
    
    func showSelectedCounterViews() {
        if !UserDefaults.standard.bool(forKey: STORM) {
            stormView.isHidden = true
            stormCount.text = "0"
        }
        if !UserDefaults.standard.bool(forKey: WHITE) {
            whiteView.isHidden = true
            plainsCount.text = "0"
        }
        if !UserDefaults.standard.bool(forKey: RED) {
            redView.isHidden = true
            mountainCount.text = "0"
        }
        if !UserDefaults.standard.bool(forKey: BLUE) {
            blueView.isHidden = true
            islandCount.text = "0"
        }
        if !UserDefaults.standard.bool(forKey: GREEN) {
            greenView.isHidden = true
            forestCount.text = "0"
        }
        if !UserDefaults.standard.bool(forKey: BLACK) {
            blackView.isHidden = true
            swampCount.text = "0"
        }
        if !UserDefaults.standard.bool(forKey: COLORLESS) {
            colorlessView.isHidden = true
            wasteCount.text = "0"
        }
    }
    
    func setupImageBorderRadii() {
        stormImage.layer.cornerRadius = 10
        plainsImage.layer.cornerRadius = 10
        mountainImage.layer.cornerRadius = 10
        islandImage.layer.cornerRadius = 10
        forestImage.layer.cornerRadius = 10
        swampImage.layer.cornerRadius = 10
        wasteImage.layer.cornerRadius = 10
    }
    
    func handleCounterTouch(target: UIView, count: UILabel, up: Bool, gesture: UILongPressGestureRecognizer) {
        if (gesture.state == .ended) {
            brightenView(target: target)
            if (up) {
                incrementLabel(target: count)
            } else {
                decrementLabel(target: count)
            }
        } else if (gesture.state == .began) {
            dimView(target: target)
        }
    }
    
    func brightenView(target: UIView) {
        target.backgroundColor = .clear
    }
    
    func dimView(target: UIView) {
        target.backgroundColor = .black
    }
    
    func incrementLabel(target: UILabel) {
        target.text = String((target.text! as NSString).integerValue + 1)
    }
    
    func decrementLabel(target: UILabel) {
        if(target.text != "0") {
            target.text = String((target.text! as NSString).integerValue - 1)
        }
    }
}
