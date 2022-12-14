//
//  PlayerViewController.swift
//  AlamofireWithSwiftyJSON
//
//  Created by Jobaid on 10/19/17.
//  Copyright © 2017 Kode. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import AlamofireImage
import WebKit
import AVFoundation
import AVKit
import GoogleMobileAds
class PlayerViewController: UIViewController,GADBannerViewDelegate,GADInterstitialDelegate {
    
    
    @IBOutlet weak var playbtn: UIButton!
    
    @IBOutlet weak var pausebtn: UIButton!
    var interstitial: GADInterstitial?
    var ID : String!
    
    @IBOutlet weak var idshow: UILabel!
    
      let playerController = AVPlayerViewController()
   var player: AVAudioPlayer?
    @IBOutlet weak var video: UIView!
    
    
    @IBOutlet weak var banner: GADBannerView!
    
   
   

    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if connectedToNetwork() == true {
           
              Timer.scheduledTimer(timeInterval: TimeInterval(900), target: self, selector: #selector(PlayerViewController.loadad), userInfo: nil, repeats: true)
            setupPlayer()
            bannerview(banner)
        }
        else {
            showEventsAcessDeniedAlert()
        }
      
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @objc func setupPlayer() {
        
      
       
        //viEw.loadHTMLString("<html><body><div id=\"youkuplayer\" style=\"width:100%;height:100%\"></div><script type=\"text/javascript\" src=\"http://player.youku.com/jsapi\"></script><script type=\"text/javascript\"> var player = new YKU.Player('youkuplayer',{styleid: '0', client_id: 'q298ajhzxkkp019cjzkoq01', vid: '\(String(describing: videosID))',newPlayer: true, autoplay: true});  function playVideo(){player.playVideo();}function currentTime(){ return player.currentTime();}function seekTo(s){ player.seekTo(s); }</script></body></html>", baseURL: nil)
        //viEw.allowsInlineMediaPlayback = false
        //viEw.backgroundColor = UIColor.black
        //viEw.reload()
        //videoview.allowsInlineMediaPlayback = true
        
        //videoview.loadHTMLString("<iframe width=\"\(videoview.frame.width)\" height=\"\(videoview.frame.height)\" src=\"https://www.youtube.com/embed/\(ID)\" frameborder=\"0\" allowfullscreen></iframe>", baseURL: nil)
        
        guard let url = URL(string: ID)
            else {
                return
        }
        // Create a new AVPlayer and associate it with the player view
        let player = AVPlayer(url: url)
        
        
        playerController.player = player
        self.addChildViewController(playerController)
        
        //player.view.frame = video.bounds
       
        playerController.view.frame = video.bounds
        playerController.view.center = CGPoint(x:video.bounds.midX, y:video.bounds.midY)
        video.addSubview(playerController.view)
        playerController.player?.actionAtItemEnd = .none
        loopVideo(videoPlayer: player)
        playerController.player?.play()
        playerController.showsPlaybackControls = true
        player.seek(to: kCMTimeZero)
      
        
       
      
    }
    override func viewWillDisappear(_ animated: Bool) {
        playerController.player?.pause()
    }
    
    @IBAction func play(_ sender: Any) {
        setupPlayer()
    }
    
    func loopVideo(videoPlayer: AVPlayer) {
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil, queue: nil) { notification in
            
            self.playerController.player?.seek(to: kCMTimeZero)
            self.playerController.player?.play()
        }
    }
    
    @IBAction func plays(_ sender: Any) {
        playerController.player?.play()
        playbtn.isHidden = true
        pausebtn.isHidden = false
    }
    
    @IBAction func pause(_ sender: Any) {
        playerController.player?.pause()
        playbtn.isHidden = false
        pausebtn.isHidden = true
        
    }
    @IBAction func fullscreen(_ sender: Any) {
        
    }
    
    
    
    //Admob
    
    @objc func bannerview(_ banner: GADBannerView){
        banner.adSize = kGADAdSizeBanner
     
        banner.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(banner)
        view.addConstraints(
            [NSLayoutConstraint(item: banner,
                                attribute: .top,
                                relatedBy: .equal,
                                toItem: bottomLayoutGuide,
                                attribute: .bottom,
                                multiplier: 1,
                                constant: 0),
             NSLayoutConstraint(item: banner,
                                attribute: .centerX,
                                relatedBy: .equal,
                                toItem: view,
                                attribute: .centerX,
                                multiplier: 1,
                                constant: 0)
            ])
        banner.adUnitID = "ca-app-pub-2742338884223376/6782723054"
        banner.rootViewController = self
         banner.load(GADRequest())
          banner.delegate = self
    }
    func adViewDidReceiveAd(_ banner: GADBannerView) {
        print("adViewDidReceiveAd")
    }
    
    /// Tells the delegate an ad request failed.
    func adView(_ banner: GADBannerView,
                didFailToReceiveAdWithError error: GADRequestError) {
        print("adView:didFailToReceiveAdWithError: \(error.localizedDescription)")
    }
    
    /// Tells the delegate that a full screen view will be presented in response
    /// to the user clicking on an ad.
    func adViewWillPresentScreen(_ banner: GADBannerView) {
        print("adViewWillPresentScreen")
    }
    
    /// Tells the delegate that the full screen view will be dismissed.
    func adViewWillDismissScreen(_ banner: GADBannerView) {
        print("adViewWillDismissScreen")
    }
    
    /// Tells the delegate that the full screen view has been dismissed.
    func adViewDidDismissScreen(_ banner: GADBannerView) {
        print("adViewDidDismissScreen")
    }
    
    /// Tells the delegate that a user click will open another app (such as
    /// the App Store), backgrounding the current app.
    func adViewWillLeaveApplication(_ banner: GADBannerView) {
        print("adViewWillLeaveApplication")
    }
    
    
    
    //inter
    
    
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
}
