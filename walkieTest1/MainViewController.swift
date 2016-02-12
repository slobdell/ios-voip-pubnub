//
//  MainViewController.swift
//  walkieTest1
//
//  Created by Scott Lobdell on 7/6/15.
//  Copyright (c) 2015 Scott Lobdell. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    let tinCanX = TinCanX()
    let role:String = "a"


    required init(coder aDecoder: NSCoder!) {


        PNLog.disableLogLevel(PNLogLevel.PNStatusLogLevel)
        // required to override other init function
        tinCanX.enableListening()
        tinCanX.initiateTrip("arbitrary_uuid", role: role)
        super.init(coder: aDecoder)
    }

    override init(nibName nibNameOrNil: String!, bundle nibBundleOrNil: NSBundle!) {
        // Initialize variables.
        tinCanX.enableListening()
        tinCanX.initiateTrip("arbitrary_uuid", role: role)
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)

    }

    @IBOutlet weak var talkButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()


        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func touchDown(sender: AnyObject) {
        talkButton.backgroundColor = UIColor.greenColor()
        tinCanX.startReadingMicrophone()


    }
    @IBAction func touchRelease(sender: AnyObject) {
        tinCanX.stopReadingMicrophone()
        talkButton.backgroundColor = UIColor.redColor()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
