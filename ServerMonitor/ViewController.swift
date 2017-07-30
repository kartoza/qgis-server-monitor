//
//  ViewController.swift
//  ServerMonitor
//
//  Created by Tim Sutton on 2017/07/27.
//  Copyright © 2017 Tim Sutton. All rights reserved.
//

import UIKit


class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var refreshButton: UIButton!

    @IBOutlet weak var tableView: UITableView!
    
    // Data model: These strings will be the data for the table view cells
    // Each domain here also needs to be listed in the Info.plist
    // in section: App Transport Security Settings
    // And set include subdomains to true if needed
    let urls: [String] = [
        "http://qgis.org",
        "http://plugins.qgis.org",
        "http://plugins/qgis.org/plugins.xml",
        "http://blog.qgis.org",
        "http://hub.qgis.org",
        "http://docs.qgis.org",
        "http://changelog.qgis.org",
        "http://api.qgis.org",
        "http://users.qgis.org"
    ]
    
    // one status per url - will be prepopulated with false until we 
    // establish that each url is online
    var statuses: [Bool] = []
    
    // cell reuse id (cells that scroll out of view can be reused)
    let cellReuseIdentifier = "TextCell"
    
    @IBAction func refreshPressed(_ sender: Any) {
        
        print ("Refresh pressed");

        for url in urls {
            let urlIndex = self.urls.index(of: url)
            let scriptUrl = url
            let myUrl = NSURL(string: scriptUrl)
            let request = NSMutableURLRequest(url:myUrl! as URL)
            request.httpMethod = "GET"
            let task = URLSession.shared.dataTask(with: request as URLRequest) {
                data, response, error in

                // Check for error
                if error != nil
                {
                    //print("error=\(String(describing: error))")
                    print("Error:    \(url)")
                    self.statuses[urlIndex!] = false
                    self.tableView.reloadData()
                }
                else
                {
                    print("OK:    \(url)")
                    self.statuses[urlIndex!] = true
                    self.tableView.reloadData()
                    //print the whole page content
                    //let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                    //print("responseString = \(String(describing: responseString))")
                }
            }
            task.resume() //runs in its own thread
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        refreshButton.layer.cornerRadius = 4;
        // Set up the table - see https://stackoverflow.com/questions/33234180/uitableview-example-for-swift
        // Register the table view cell class and its reuse id
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        
        // This view controller itself will provide the delegate methods and row data for the table view.
        tableView.delegate = self
        tableView.dataSource = self
        
        // Initialise the status list to false for all urls
        for _ in urls {
            self.statuses.append(false)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // number of rows in table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.urls.count
    }
    
    // create a cell for each table view row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // create a new cell if needed or reuse an old one
        let cell:UITableViewCell = self.tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as UITableViewCell!
        
        if self.statuses[indexPath.row] {
            // set the text from the data model and mark the url as online
            cell.textLabel?.text = "✔︎" + self.urls[indexPath.row]
        }
        else {
            // set the text from the data model and mark the url as offline
            cell.textLabel?.text = "✘" + self.urls[indexPath.row]
        }
        
        return cell
    }
    
    // method to run when table view cell is tapped
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("You tapped cell number \(indexPath.row).")
    }
    
}

