//
//  HomeTableViewController.swift
//  Twitter
//
//  Created by ピタソン・ラニク on 2/26/21.
//  Copyright © 2021 Dan. All rights reserved.
//

import UIKit

class HomeTableViewController: UITableViewController {

    var tweetArray = [NSDictionary]() // var means is a variable that can change as opposed to let
    var numberOfTweet: Int! // will be an integer 
    
    let myRefreshControl = UIRefreshControl()
    
    override func viewDidLoad() { // when the screen loads do this:
        super.viewDidLoad()
        loadTweets()
        
        // "self" is the screen itself.
        myRefreshControl.addTarget(self, action: #selector(loadTweets), for: .valueChanged) // this is an action to a reaction.
        tableView.refreshControl = myRefreshControl
    }
    
    @objc func loadTweets(){
        
        numberOfTweet = 20
        
        let myURL = "https://api.twitter.com/1.1/statuses/home_timeline.json"
        
        let myParams = ["count": numberOfTweet] // only give me x amount of tweets
        
        TwitterAPICaller.client?.getDictionariesRequest(url: myURL, parameters: myParams, success: { (tweets: [NSDictionary]) in
            self.tweetArray.removeAll() // clear my list
            for tweet in tweets {
                self.tweetArray.append(tweet) // refresh my list
            }
            // then update my list/table:
            self.tableView.reloadData() // whenever we make a call to the API, we make sure to reload the content of our data with that content.
            self.myRefreshControl.endRefreshing() // stops the refresh icon
            
        }, failure: {(Error) in  print("Could not retreive tweets! Oh no!! D:")})
        
    }
    
    func loadMoreTweets() { //infinte scrolling code
        let myUrl = "https://api.twitter.com/1.1/statuses/home_timeline.json"
        
        numberOfTweet = numberOfTweet + 20 // add 20 more.
        let myParams = ["count": numberOfTweet]
        
        TwitterAPICaller.client?.getDictionariesRequest(url: myUrl, parameters: myParams, success: { (tweets: [NSDictionary]) in
            self.tweetArray.removeAll() // clear my list
            for tweet in tweets {
                self.tweetArray.append(tweet) // refresh my list
            }
            // then update my list/table:
            self.tableView.reloadData() // whenever we make a call to the API, we make sure to reload the content of our data with that content.
            //self.myRefreshControl.endRefreshing() // stops the refresh icon
            
        }, failure: {(Error) in  print("Could not retreive tweets! Oh no!! D:")})
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row + 1 == tweetArray.count{ // when user gets to the end of the page
            loadMoreTweets() // load more tweets!
        }
    }
    
    @IBAction func onLogout(_ sender: Any) {
        TwitterAPICaller.client?.logout()
        self.dismiss(animated: true, completion: nil) // dismissing screen. nil means we don't want anything to happen when the logout button is called. true, meaning to animate us logged out and bring us back to our home screen.
        UserDefaults.standard.set(false, forKey: "userLoggedIn") // we want to use the same forKey.
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tweetCell", for: indexPath) as! TweetCellTableViewCell
        
        //cell.userNameLabel.text = "Some name" // this would replace john doe with this string
        //cell.tweetContent.text = "Something else" // would replace tweet contents with this string
        
        let user = tweetArray[indexPath.row]["user"] as! NSDictionary
        
        cell.userNameLabel.text = user["name"] as? String
        cell.tweetContent.text = tweetArray[indexPath.row]["text"] as? String // text is from API website look at JSON
        
        // this is how to set the image:
        let imageUrl = URL(string: (user["profile_image_url_https"] as? String)!)
        let data = try? Data(contentsOf: imageUrl!)
        
        if let imageData = data{
            cell.profileImageView.image = UIImage(data: imageData)
        }
        
        return cell
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int { // the number of sections in app
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { // the number of rows in app
        return tweetArray.count // however many tweets
    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
