//
//  FridgeViewController.swift
//  FoodTracker
//
//  Created by Catherine Cheng on 2/15/20.
//  Copyright © 2020 Katrina Jiao. All rights reserved.
//

import UIKit

struct Headline {
    var name : String
    var date : String
    var image : String
}

class HeadlineTableViewCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var iconView: UIImageView!
    
}

class FridgeViewController: UITableViewController {
    var items = [Headline]()
    var newItem = Headline(name: "", date: "", image: "")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        items = [Headline(name: "Eggs", date: "01/01", image: "diary"),
        Headline(name: "Grapefruits", date: "01/02", image: "fruits"),
        Headline(name: "Spinach", date: "01/03", image: "veggie")]
        
        items.sort(by: {$0.date < $1.date})

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return items.count
    }

    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "itemCell", for: indexPath) as! HeadlineTableViewCell

        let headline = items[indexPath.row]
            cell.nameLabel?.text = headline.name
            cell.dateLabel?.text = headline.date
            cell.iconView?.image = UIImage(named: headline.image)

        return cell
    }
    
    @IBAction func cancel(segue:UIStoryboardSegue) {
      
    }

    @IBAction func done(segue:UIStoryboardSegue) {
        let itemDetailVC = segue.source as! itemDetailViewController
        newItem.name = itemDetailVC.name
        newItem.date = itemDetailVC.fullDate
        newItem.image = itemDetailVC.image
            
        items.append(newItem)
        //print(newItem.name, newItem.date, newItem.image)
        tableView.reloadData()
    }
    
    

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
