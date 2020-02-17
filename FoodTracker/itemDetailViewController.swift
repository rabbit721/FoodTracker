//
//  itemDetailViewController.swift
//  FoodTracker
//
//  Created by Catherine Cheng on 2/15/20.
//  Copyright © 2020 Katrina Jiao. All rights reserved.
//

import UIKit

class itemDetailViewController: UIViewController {
    
    var name: String = ""
    var month: String = ""
    var date: String = ""
    var year: String = ""
    var fullDate: String = ""
    var image: String = "protein"

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBOutlet weak var itemName: UITextField!
    @IBOutlet weak var itemMonth: UITextField!
    @IBOutlet weak var itemDate: UITextField!
    @IBOutlet weak var itemYear: UITextField!
    @IBOutlet weak var itemImage: UITextField!
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "doneSegue" {
            name = itemName.text!
            month = itemMonth.text!
            date = itemDate.text!
            year = itemYear.text!
            fullDate = "\(month)/\(date)/\(year)"
            image = itemImage.text!
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
