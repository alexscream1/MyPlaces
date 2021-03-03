//
//  MainTableViewController.swift
//  MyPlaces
//
//  Created by Alexey Onoprienko on 03.03.2021.
//

import UIKit

class MainTableViewController: UITableViewController {

    
    var placesNames = ["Kyiv Maidan", "Bali", "Eiffel Tower", "Burj Khalifa", "Stanislav"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return placesNames.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        cell.textLabel?.text = placesNames[indexPath.row]
        cell.imageView?.image = UIImage(named: placesNames[indexPath.row])
        cell.imageView?.layer.cornerRadius = cell.frame.size.width /  2
        cell.imageView?.clipsToBounds = true
 
        return cell
    }
    
    // MARK: - Table view delegate
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 85
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
