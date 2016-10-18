//
//  StudentDetailViewController.swift
//  p2p
//
//  Created by Arnav Gudibande on 10/17/16.
//  Copyright © 2016 sfhacks. All rights reserved.
//

import UIKit
import MapKit

class StudentDetailViewController: UIViewController {

    @IBOutlet weak var studentName: UILabel!
    @IBOutlet weak var studentLocation: UILabel!
    @IBOutlet weak var studentHours: UILabel!
    @IBOutlet weak var studentSubject: UILabel!
    @IBOutlet weak var studentPicture: UIImageView!
    @IBOutlet weak var studentMapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func didAcceptRequest(_ sender: AnyObject) {
    }

    @IBAction func didDeclineRequest(_ sender: AnyObject) {
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
