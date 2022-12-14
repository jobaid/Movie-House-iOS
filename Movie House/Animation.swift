
import UIKit
import Alamofire
import SwiftyJSON
import AlamofireImage
import GoogleMobileAds

class Animation: UIViewController,GADBannerViewDelegate,GADInterstitialDelegate {
    
    var interstitial: GADInterstitial?
    @IBOutlet weak var tblview: UITableView!
    @objc var refreshControl: UIRefreshControl!
    
    
    
    @objc var arrRes = [[String:AnyObject]]()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        if connectedToNetwork() == true {
            Timer.scheduledTimer(timeInterval: TimeInterval(150), target: self, selector: #selector(Animation.loadad), userInfo: nil, repeats: true)
            
            
            getdata()
        }
        else {
            showEventsAcessDeniedAlert()
        }
        
        setupPullToRefresh()
        
    }
    
    @objc(tableView:heightForRowAtIndexPath:)
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 250.0
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func getdata(){
        Alamofire.request("https://bflix-f20b8.firebaseio.com/.json").responseJSON { (responseData) -> Void in
            if((responseData.result.value) != nil) {
                let swiftyJsonVar = JSON(responseData.result.value!)
                
                if let resData = swiftyJsonVar["animation"].arrayObject {
                    self.arrRes = resData as! [[String:AnyObject]]
                }
                if self.arrRes.count > 0 {
                    self.tblview.reloadData()
                }
            }
        }
    }
    
    
    
    @objc func tableView(_ tableView: UITableView, cellForRowAtIndexPath indexPath: IndexPath) -> UITableViewCell {
        let cell : UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "jcell")!
        var dict = arrRes[(indexPath as NSIndexPath).row]
        let texts = cell.viewWithTag(9) as! UILabel
        let image = cell.viewWithTag(10) as! UIImageView
        
        texts.text = dict["name"] as? String
        let url = URL(string : (dict["image"] as? String)!)!
        
        
        image.af_setImage(withURL: url, placeholderImage: nil)
        return cell
    }
    
    @objc func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrRes.count
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "id" {
            
            if let indexPath = self.tblview.indexPathForSelectedRow {
                let controller = segue.destination as! PlayerViewController
                let value = arrRes[indexPath.row]
                controller.ID = value["link"] as! String
                //controller.Full = value[""] as! String
                //controller.images = value["image"] as! String
            }
            
            
        }
        
    }
    
    
    @objc func setupPullToRefresh() {
        self.refreshControl = UIRefreshControl()
        self.refreshControl.attributedTitle = NSAttributedString(string: "Refresh", attributes: [NSAttributedStringKey.foregroundColor:UIColor.white])
        self.refreshControl.backgroundColor = UIColor.black
        self.refreshControl.tintColor = UIColor.white
        self.refreshControl.addTarget(self, action: #selector(Animation.refresh), for: UIControlEvents.valueChanged)
        self.tblview.addSubview(refreshControl)
    }
    @objc func refresh(sender: AnyObject) {
        // Pull to Refresh
        //stations.removeAll(keepingCapacity: false)
        
        getdata()
        
        // Wait 2 seconds then refresh screen
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.refreshControl.endRefreshing()
            self.view.setNeedsDisplay()
        }
    }
    func showEventsAcessDeniedAlert() {
        let alertController = UIAlertController(title: "No Internet Connection",
                                                message: "Please Connect Your Mobile Data or WIFI Connection",
                                                preferredStyle: .alert)
        
        let settingsAction = UIAlertAction(title: "Settings", style: .default) { (alertAction) in
            
            // THIS IS WHERE THE MAGIC HAPPENS!!!!
            if let appSettings = NSURL(string: UIApplicationOpenSettingsURLString) {
                UIApplication.shared.openURL(appSettings as URL)
            }
        }
        alertController.addAction(settingsAction)
        
        let cancelAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    
    
    //admob
    @objc func loadad() {
        interstitial = createAndLoadInterstitial()
    }
    
    
    
    
    
    
    
    private func createAndLoadInterstitial() -> GADInterstitial? {
        interstitial = GADInterstitial(adUnitID: "ca-app-pub-2742338884223376/5732052181")
        
        guard let interstitial = interstitial else {
            return nil
        }
        
        let request = GADRequest()
        request.testDevices = [ kGADSimulatorID ]
        interstitial.load(request)
        interstitial.delegate = self
        
        return interstitial
    }
    
    // MARK: - GADInterstitialDelegate methods
    
    func interstitialDidReceiveAd(_ ad: GADInterstitial) {
        print("Interstitial loaded successfully")
        ad.present(fromRootViewController: self)
    }
    
    func interstitialDidFail(toPresentScreen ad: GADInterstitial) {
        print("Fail to receive interstitial")
    }
    
}




