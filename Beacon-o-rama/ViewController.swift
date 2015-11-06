import UIKit

class ViewController: UIViewController, ESTBeaconManagerDelegate {
    
    enum beaconColor : Int {
        case RED = 10894
        case GREEN = 27635
        case BLUE = 55043
    }
    
    var ourBeacons = [beaconColor.RED.rawValue, beaconColor.GREEN.rawValue, beaconColor.BLUE.rawValue]
    
    var red : CGFloat = 0.0
    var green : CGFloat = 0.0
    var blue : CGFloat = 0.0
    
    //var color = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
    
    let colors = [
        1: UIColor(red: 0/255, green: 255/255, blue: 0/255, alpha: 1),
        2: UIColor(red: 255/255, green: 255/255, blue: 0/255, alpha: 1),
        3: UIColor(red: 255/255, green: 0/255, blue: 0/255, alpha: 1)
    ]

    let beaconManager = ESTBeaconManager()
    let beaconRegion = CLBeaconRegion(proximityUUID: NSUUID(UUIDString: "B9407F30-F5F8-466E-AFF9-25556B57FE6D")!, identifier: "Free-ranged beacons and eggs")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.beaconManager.delegate = self
        self.beaconManager.requestAlwaysAuthorization()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.beaconManager.startRangingBeaconsInRegion(self.beaconRegion)
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        self.beaconManager.stopRangingBeaconsInRegion(self.beaconRegion)
    }
    
    func beaconManager(manager: AnyObject, didRangeBeacons beacons: [CLBeacon], inRegion region: CLBeaconRegion) {
        let ours = beacons.filter(isOurs).sort{ (a : CLBeacon, b : CLBeacon) -> Bool in
            return a.minor.integerValue > b.minor.integerValue
        }
       
       /* print(ours.map{ (b : CLBeacon) -> Int in
            return b.minor.integerValue
        })*/
        
        var newColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
        for beacon in ours {
            newColor = calculateColor(beacon)
        }
        UIView.animateWithDuration(2, animations: {
            self.view.backgroundColor = newColor
        })
       
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func isOurs (beacon: CLBeacon) -> Bool {
        return ourBeacons.contains(beacon.minor.integerValue)
    }
    
    func calculateColor(beacon : CLBeacon) -> UIColor {
        
        var colorValue : CGFloat = CGFloat(1.0 - 0.3*beacon.accuracy)
        //print(NSDateFormatter.localizedStringFromDate(NSDate(), dateStyle: .NoStyle, timeStyle: .FullStyle))
        //print(beacon.accuracy)
        if (colorValue < 0) {
            colorValue = 0
        } else if (colorValue > 1) {
            colorValue = 1
        }
        //print(red, green, blue)
        switch beacon.minor {
        case beaconColor.RED.rawValue:
            red = colorValue
            return UIColor(red: colorValue, green: green, blue : blue, alpha: 1)
        case beaconColor.GREEN.rawValue:
            green = colorValue
            return UIColor(red: red, green: colorValue, blue : blue, alpha: 1)
        default:
            blue = colorValue
            return UIColor(red: red, green: green, blue : colorValue, alpha: 1)
        }
        
    }
}

