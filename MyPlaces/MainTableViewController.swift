//
//  MainTableViewController.swift
//  MyPlaces
//
//  Created by Alexey Onoprienko on 03.03.2021.
//

import UIKit
import RealmSwift

class MainTableViewController: UITableViewController {

    var places: Results<PlaceModel>!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        places = realm.objects(PlaceModel.self)
    }

    
    // MARK: - Table view delegate
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let place = places[indexPath.row]
        let contextItem = UIContextualAction(style: .destructive, title: "Delete", handler: {_,_,_ in
            StorageManager.deleteObject(place)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        })
        
        let swipeAction = UISwipeActionsConfiguration(actions: [contextItem])
        
        return swipeAction
    }
    
    
    // MARK: - Table view data source

    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return places.isEmpty ? 0 : places.count
        
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CustomTableViewCell
        
        let place = places[indexPath.row]
        
        cell.placeNameLabel.text = place.name
        cell.countryNameLabel.text = place.country
        cell.cityNameLabel.text = place.city
        cell.placeImageView.image = UIImage(data: place.imageData!)
      
        
        cell.placeImageView.layer.cornerRadius = cell.placeImageView.frame.size.width / 2
        cell.placeImageView.clipsToBounds = true
        
        
        return cell
    }

    
    
    
    
     //MARK: - Navigation

     
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editPlace" {
            guard let indexPath = tableView.indexPathForSelectedRow else {return}
            let place = places[indexPath.row]
            let newPlaceVC = segue.destination as! NewPlaceTableViewController
            newPlaceVC.currentPlace = place
        }
    }
    
    
    //MARK: - Cancel action for NewPlaceVC
    
    @IBAction func unwindSegue(_ segue: UIStoryboardSegue) {
        
        guard let newPlaceVC = segue.source as? NewPlaceTableViewController else { return }
        newPlaceVC.savePlace()
        tableView.reloadData()
    }

}
