//
//  MapViewController.swift
//  MyPlaces
//
//  Created by Alexey Onoprienko on 06.03.2021.
//

import UIKit
import MapKit

protocol MapViewControllerDelegate {
    func getAddress(_ address: String?)
}

class MapViewController: UIViewController {

    
    var mapVCDelegate: MapViewControllerDelegate?
    var place = PlaceModel()
    let annotationIdentifier = "annotation"
    let locationManager = CLLocationManager()
    let regionInMeters: Double = 1000
    var receivedSegueIdentifier = ""
    var selectedAddress = ""
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var saveAdressButton: UIButton!
    @IBOutlet weak var pinImageView: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        setupMapView()
        checkLocationServices()
    }
    
    // Close map button
    @IBAction func closeMapButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    // Button for returning to current position
    @IBAction func currentPositionButton() {
        showCurrentPosition()
    }
    
    
    @IBAction func saveButtonPressed(_ sender: Any) {
        mapVCDelegate?.getAddress(selectedAddress)
        dismiss(animated: true)
    }
    
    
    
    private func setupMapView() {
        if receivedSegueIdentifier == "showPlace" {
            setupPlacemark()
            pinImageView.isHidden = true
            saveAdressButton.isHidden = true
        }
    }
    
    // Function to show current position
    private func showCurrentPosition() {
        if let location = locationManager.location?.coordinate {
            let region = MKCoordinateRegion(center: location,
                                            latitudinalMeters: regionInMeters,
                                            longitudinalMeters: regionInMeters)
            mapView.setRegion(region, animated: true)
        }
    }
    
    // Get center point of map
    private func getCenterLocation(_ mapView: MKMapView) -> CLLocation {
        
        let latitude = mapView.centerCoordinate.latitude
        let longtitude = mapView.centerCoordinate.longitude
        
        return CLLocation(latitude: latitude, longitude: longtitude)
    }
    
    // Check if location services enabled
    private func checkLocationServices() {
        if CLLocationManager.locationServicesEnabled() {
            setupLocationManager()
            checkLocationAuthorization()
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.disabledServicesAlert(title: "Location services are disable", message: "Activate: Settings -> Privacy -> Location Service -> Turn On")
            }
            
        }
    }
    
    
    // Setup accuracy of Location Manager
    private func setupLocationManager() {
        //highest accuracy
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.delegate = self
    }
    
    
    // Check location authorization
    private func checkLocationAuthorization() {
        switch locationManager.authorizationStatus {
        case .authorizedWhenInUse:
            mapView.showsUserLocation = true
            if receivedSegueIdentifier == "showPosition" { showCurrentPosition() }
            break
        case .authorizedAlways :
            break
        case .denied:
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.disabledServicesAlert(title: "Your location is not available", message: "Go: Settings -> MyPlaces -> Location")
            }
            break
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            break
        case .restricted:
            break
        @unknown default:
            print("New case is available")
        }
    }
    
    // Alert when location services disabled
    private func disabledServicesAlert(title: String?, message: String?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okayAction = UIAlertAction(title: "Okay", style: .default)
        alert.addAction(okayAction)
        self.present(alert, animated: true, completion: nil)
        
    }
    
    private func setupPlacemark() {
        
        // Check if location exists
        guard let location = place.location else { return }
        
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(location) { (placemarks, error) in
            
            // Check for errors
            if let error = error {
                print(error)
                return
            }
            
            // Check if placemarks exist
            guard let placemarks = placemarks else { return }
            
            // We should have only one placemark, because we use our location
            let placemark = placemarks.first
            
            // Create annotation to describe our point on map
            let annotation = MKPointAnnotation()
            annotation.title = self.place.name
            
            // Position of marker
            guard let placemarkLocation = placemark?.location else { return }
            annotation.coordinate = placemarkLocation.coordinate
            
            
            self.mapView.showAnnotations([annotation], animated: true)
            self.mapView.selectAnnotation(annotation, animated: true)
        }
        
    }
    
}

// MARK: - Map view delegate

extension MapViewController: MKMapViewDelegate {
    

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        // Check that annotation is not MKUserLocation
        guard !(annotation is MKUserLocation) else { return nil }
        
        // Create annotation view
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: annotationIdentifier) as? MKPinAnnotationView
        
        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: annotationIdentifier)
            // Show annotation like banner
            annotationView?.canShowCallout = true
        }
        
        // Add image of place to annotation banner
        if let imageData = place.imageData {
            let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
            imageView.layer.cornerRadius = 10
            imageView.clipsToBounds = true
            imageView.image = UIImage(data: imageData)
            annotationView?.rightCalloutAccessoryView = imageView
        }
        return annotationView
    }
    
    // Get adress by chosen location
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        
        let center = getCenterLocation(mapView)
        let geocoder = CLGeocoder()
        
        geocoder.reverseGeocodeLocation(center) { (placemarks, error) in
            
            if let error = error {
                print(error)
                return
            }
            
            guard let placemarks = placemarks else { return }
            
            let placemark = placemarks.first
            let city = placemark?.locality
            let streetName = placemark?.thoroughfare
            let buildingNumber = placemark?.subThoroughfare
            
            DispatchQueue.main.async {
                
                if city != nil, streetName != nil, buildingNumber != nil {
                    self.selectedAddress = "\(city!), \(streetName!) \(buildingNumber!)"
                } else if city != nil, streetName != nil {
                    self.selectedAddress = "\(city!), \(streetName!)"
                } else if city != nil {
                    self.selectedAddress = "\(city!)"
                }
                
            }
        }
    }
    
}

// MARK: - CLLocationManagerDelegate
extension MapViewController: CLLocationManagerDelegate {
    // Update authorization
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkLocationAuthorization()
    }
}
