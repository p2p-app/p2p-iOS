//
//  studentListViewController.swift
//  p2p
//
//  Created by Arnav Gudibande on 10/17/16.
//  Copyright © 2016 sfhacks. All rights reserved.
//

import UIKit

class studentListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var hoursAccumulated: UILabel!
    @IBOutlet weak var studentsHelped: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = false
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "studentCell", for: indexPath) as! StudentListTableViewCell
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }

}
