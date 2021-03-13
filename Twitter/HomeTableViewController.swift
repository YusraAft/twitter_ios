//
//  HomeTableViewController.swift
//  Twitter
//
//  Created by Mac User on 3/4/21.
//  Copyright © 2021 Dan. All rights reserved.
//

import UIKit

class HomeTableViewController: UITableViewController {

    var tweetArray = [NSDictionary]() //array of dictionaries
    var numberOfTweet: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       // refresher.addTarget(self, action: #selector(loadTweets), for: .valuechanged)
        loadTweets()
        self.tableView.rowHeight = UITableView.automaticDimension //automatically calculated
        self.tableView.estimatedRowHeight = 150 //estimated height
        
      
    }//viewdidload only runs once
    
    override func viewDidAppear(_ animated: Bool) { //this function runs every time
        super.viewDidAppear(animated)
        self.loadTweets()
    }

    //to pull tweets or call the API -> we call it when the viewloads
    func loadTweets(){
        
        let myUrl = "https://api.twitter.com/1.1/statuses/home_timeline.json"
        //remember the ""
        let myParams = ["count": 10] //this parmateris from the Twitter API documentation for th above API

        //call the api; get nuch of dicts that have the tweets and then give in our count 
        TwitterAPICaller.client?.getDictionariesRequest(url: myUrl, parameters: myParams, success: { (tweets: [NSDictionary]) in
            //we want to clean the list up and then repopualte with new
            self.tweetArray.removeAll()
            for tweet in tweets{
                self.tweetArray.append(tweet) //need self because we wrote inside a closure
            }
            self.tableView.reloadData() //always make sure that every time we call to API we repopulate our list to make sure we reload our data with that content (I think new content?)
        }, failure: { (Error) in
            print("Could not retrieve tweets!!!!!!!")
        })
    }
    
    
    @IBAction func onLogout(_ sender: Any) {
        
        TwitterAPICaller.client?.logout()
        self.dismiss(animated: true, completion: nil) //screen will dismiss itself ; login had been presented now that screen will be gone
        UserDefaults.standard.set(false, forKey: "userLoggedIn")
    }//nil meaning we dont want anything to happen once its gone
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tweetCell", for:  indexPath) as! TweetCellTableViewCell //identifier is the nickname for the prototype cell
        //! forces it to be of the type we assigned which is tweetcelltableviewcell and ecall this is what we put as the identifier using river license on the table view cell now called tweet cell
        let user = tweetArray[indexPath.row]["user"] as! NSDictionary//because name is inside the inner array with key user unlike text
        
        cell.userNameLabel.text = user["name"] as? String //now can access the key name inside user dict
        cell.tweetContent.text = tweetArray[indexPath.row]["text"] as? String
        //can also set the image but don't necessarily need to since it can be slighlty more complicated
        
        //this is how we do image in xcode or swift
        let imageUrl = URL(string: (user["profile_image_url_https"] as? String)!)
        let data = try? Data(contentsOf: imageUrl!)
        if let imageData = data {
            cell.profileImageView.image = UIImage(data: imageData)
        }
        
        cell.setFavorite(tweetArray[indexPath.row]["favorited"] as! Bool)//for using as! we know for sure that it is a boolean
        cell.tweetId = tweetArray[indexPath.row]["id"] as! Int //this will set the variable we TweetcellTableview
        return cell
    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1 //how mnay sections you want
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return tweetArray.count //how many rows per section? And like tweets
    }

 

}
