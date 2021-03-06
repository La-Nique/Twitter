//
//  TweetViewController.swift
//  Twitter
//
//  Created by ピタソン・ラニク on 3/1/21.
//  Copyright © 2021 Dan. All rights reserved.
//

import UIKit

class TweetViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        tweetTextView.becomeFirstResponder() // places a cursor in text box area

        // Do any additional setup after loading the view.
    }
    
    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBOutlet weak var tweetTextView: UITextView!
    
//    var body: UITextView {
//        TextField(tweetTextView)
//            .textFieldStyle(RoundedBorderTextFieldStyle())
//    }
    
    @IBAction func tweet(_ sender: Any) {
        if(!tweetTextView.text.isEmpty){ // if not empty
            TwitterAPICaller.client?.postTweet(tweetString: tweetTextView.text,
                success: {self.dismiss(animated: true, completion: nil)} ,
                failure: {(error) in print ("Error posting tweet\(error)")
                    self.dismiss(animated: true, completion: nil)
                })
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
