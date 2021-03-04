//
//  MainTableViewController.swift
//  MyPlaces
//
//  Created by Alexey Onoprienko on 03.03.2021.
//

import UIKit

class MainTableViewController: UITableViewController {

    var places = [
        PlaceModel(name: "Maidan", country: "Ukraine", city: "Kyiv", image: nil, placeImage: "Maidan"),
        PlaceModel(name: "Bali", country: "Indonesia", city: "Bali", image: nil, placeImage: "Bali"),
        PlaceModel(name: "Eiffel Tower", country: "France", city: "Paris", image: nil, placeImage: "Eiffel Tower"),
        PlaceModel(name: "Burj Khalifa", country: "UAE", city: "Dubai", image: nil, placeImage: "Burj Khalifa"),
        PlaceModel(name: "Stanislav", country: "Ukraine", city: "Kherson", image: nil, placeImage: "Stanislav")
    ]
    
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
        return places.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CustomTableViewCell
        
        let place = places[indexPath.row]
        
        cell.placeNameLabel.text = place.name
        cell.countryNameLabel.text = place.country
        cell.cityNameLabel.text = place.city
        
        if place.image == nil {
            cell.placeImageView.image = UIImage(named: place.placeImage!)
        } else {
            cell.placeImageView.image = place.image
        }
        
        cell.placeImageView.layer.cornerRadius = cell.placeImageView.frame.size.width / 2
        cell.placeImageView.clipsToBounds = true
        
        
        return cell
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    //MARK: - Cancel action for NewPlaceVC
    
    @IBAction func unwindSegue(_ segue: UIStoryboardSegue) {
        
        guard let newPlaceVC = segue.source as? NewPlaceTableViewController else { return }
        newPlaceVC.saveNewPlace()
        places.append(newPlaceVC.newPlace!)
        tableView.reloadData()
    }

}
