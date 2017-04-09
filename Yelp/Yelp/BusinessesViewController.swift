//
//  BusinessesViewController.swift
//  Yelp
//
//  Created by Timothy Lee on 4/23/15.
//  Copyright (c) 2015 Timothy Lee. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import DXCustomCallout_ObjC

class BusinessesViewController: UIViewController, UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate, MKMapViewDelegate, CLLocationManagerDelegate {
    
    var searchBar: UISearchBar!
    
    var businesses: [Business]!
    
    var filters: Filters!
    
    var isTableViewShowing: Bool = true
    
    var locationManager: CLLocationManager!
    
    var currentLocation: CLLocation?
    
    @IBOutlet weak var restaurantMapView: MKMapView!
    
    @IBOutlet weak var restaurantTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        searchBar = UISearchBar()
        searchBar.placeholder = "Restaurants"
        searchBar.delegate = self
        restaurantTableView.dataSource = self
        restaurantTableView.delegate = self
        restaurantMapView.delegate = self

        
        restaurantTableView.estimatedRowHeight = 100
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.distanceFilter = 10
        locationManager.requestWhenInUseAuthorization()
        currentLocation = locationManager.location
        goToLocation(location: currentLocation!)
        locationManager.startUpdatingLocation()

        filters = Filters()
        
        // Add SearchBar to the NavigationBar
        searchBar.sizeToFit()
        navigationItem.titleView = searchBar
        
        // Perform the first search when the view controller first loads
        doSearch("")

        /* Example of Yelp search with more search options specified
         Business.searchWithTerm("Restaurants", sort: .Distance, categories: ["asianfusion", "burgers"], deals: true) { (businesses: [Business]!, error: NSError!) -> Void in
         self.businesses = businesses
         
         for business in businesses {
         print(business.name!)
         print(business.address!)
         }
         }
         */

        if isTableViewShowing {
            restaurantMapView.isHidden = true
        } else {
            restaurantTableView.isHidden = true
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if businesses != nil {
            return businesses.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = restaurantTableView.dequeueReusableCell(withIdentifier: "RestaurantTableViewCell", for: indexPath) as! RestaurantTableViewCell
        let business = businesses[indexPath.row]
        cell.restaurantImage.setImageWith(business.imageURL!)
        cell.restaurantNameLabel.text = business.name
        cell.distanceLabel.text = business.distance
        cell.ratingImage.setImageWith(business.ratingImageURL!)
        cell.reviewsLabel.text = "\(business.reviewCount!) Reviews"
        cell.addressLabel.text = business.address
        cell.categoryLabel.text = business.categories
        return cell
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        return true
    }
    
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        return true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.resignFirstResponder()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        doSearch(searchBar.text!, sort: nil, categories: nil, deals: nil)
    }
    
    func doSearch(_ searchText: String) {
        doSearch(searchText, sort: nil, categories: nil, deals: nil)
    }
    
    func doSearch(_ searchText: String, sort: YelpSortMode?, categories: [String]?, deals: Bool?) {
        var coordinateStr: String?
        
        if let userCoordinate = currentLocation?.coordinate {
            coordinateStr = "\(userCoordinate.latitude),\(userCoordinate.longitude)"
        }
        Business.searchWithTerm(term: searchText, sort: sort, categories: categories, deals: deals, coordinate:coordinateStr , completion: { (businesses: [Business]?, error: Error?) -> Void in
            
            self.businesses = businesses
            if let businesses = businesses {
                for business in businesses {
                    print(business.name!)
                    print(business.address!)
                }
            }
            self.restaurantTableView.reloadData()
            self.updateAnnotations()
            
        }
        )
    }
    
    func updateAnnotations() {
        restaurantMapView.removeAnnotations(restaurantMapView.annotations)
        
        for (index, business) in businesses.enumerated() {
            let annotation = MKPointAnnotation()
            annotation.coordinate = CLLocationCoordinate2D(latitude: business.latitude!, longitude: business.longitude!)
            annotation.title = "\(index)"
            restaurantMapView.addAnnotation(annotation)
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let identifier = "customAnnotationView"

        if let index = Int(annotation.title!!) {
            var annotationView = restaurantMapView.dequeueReusableAnnotationView(withIdentifier: identifier)
            let business = businesses[index]
            // custom pin annotation
            if (annotationView == nil) {
                
                let pinView = UIImageView(image: UIImage(named: "pin"))
                let businessAnnView = Bundle.main.loadNibNamed("BusinessPopView", owner: self, options: nil)?.first as! BusinessPopView
                businessAnnView.nameLabel.text = business.name
                businessAnnView.distanceLabel.text = business.distance
                businessAnnView.ratingImageView.setImageWith(business.ratingImageURL!)
                businessAnnView.reviewLabel.text = "\(business.reviewCount!) Reviews"
                businessAnnView.addressLabel.text = business.address
                businessAnnView.categoryLabel.text = business.categories
                let settings = DXAnnotationSettings()
                settings.calloutOffset = 10.0
                settings.calloutCornerRadius = 6
                settings.calloutBorderColor = UIColor.lightGray
                settings.calloutBorderWidth = 1
                settings.animationDuration = 0.3
                annotationView = DXAnnotationView(annotation: annotation, reuseIdentifier: identifier, pinView: pinView, calloutView: businessAnnView, settings: settings)
            } else {
                annotationView!.annotation = annotation
            }
            return annotationView
        } else {
            let currentPosAnnotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            return currentPosAnnotationView
        }
        
    }
    
    @IBAction func switchView(_ sender: Any) {
        isTableViewShowing = !isTableViewShowing
        let button = sender as! UIBarButtonItem
        if isTableViewShowing {
            button.title = "Map"
            restaurantMapView.isHidden = true
            restaurantTableView.isHidden = false
        } else {
            button.title = "List"
            restaurantTableView.isHidden = true
            restaurantMapView.isHidden = false
        }
    }
    
    func goToLocation(location: CLLocation) {
        let span = MKCoordinateSpanMake(0.02, 0.02)
        let region = MKCoordinateRegionMake(location.coordinate, span)
        restaurantMapView.setRegion(region, animated: false)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let targetViewController = segue.destination as! FiltersViewController
        targetViewController.filters = filters
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last!
        let eventDate = location.timestamp
        
        if currentLocation == nil
            || eventDate.timeIntervalSinceNow.isLess(than: 15.0) && !(currentLocation?.distance(from: location).isLess(than: 50))! {
            currentLocation = location
            goToLocation(location: location)
        }
    }
}
