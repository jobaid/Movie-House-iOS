//
//  requests.swift
//  Bflix
//
//  Created by Jobaid on 10/24/17.
//  Copyright © 2017 Jobaid. All rights reserved.
//

import UIKit

class requests: UIViewController {

    @IBOutlet weak var web: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let url = URL(string: "https://docs.google.com/forms/d/e/1FAIpQLSeTdjxTNrr09Mh8Q_YAJvKjdxvq4YhtP6LN9yEj9Ig5pko8xw/viewform")
        if let unwrappedURL = url {
            
            let request = URLRequest(url: unwrappedURL)
            let session = URLSession.shared
            
            let task = session.dataTask(with: request) { (data, response, error) in
                
                if error == nil {
                    
                    self.web.loadRequest(request)
                    
                } else {
                    
                    print("ERROR: \(String(describing: error))")
                    
                }
                
            }
            
            task.resume()
            
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
