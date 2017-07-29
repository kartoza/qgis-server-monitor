//
//  ViewController.swift
//  ServerMonitor
//
//  Created by Tim Sutton on 2017/07/27.
//  Copyright © 2017 Tim Sutton. All rights reserved.
//

import UIKit


class ViewController: UIViewController {

    @IBOutlet weak var refreshButton: UIButton!
    
    @IBAction func refreshPressed(_ sender: Any) {
        print ("Refresh pressed");
        let scriptUrl = "http://qgis.org"
        let myUrl = NSURL(string: scriptUrl)
        let request = NSMutableURLRequest(url:myUrl! as URL)
        request.httpMethod = "GET"
        let task = URLSession.shared.dataTask(with: request as URLRequest) {
            data, response, error in
            
            // Check for error
            if error != nil
            {
                print("error=\(String(describing: error))")
                return
            }
            
            // Print out response string
            let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
            print("responseString = \(String(describing: responseString))")
        }
        task.resume()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        refreshButton.layer.cornerRadius = 4;
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

