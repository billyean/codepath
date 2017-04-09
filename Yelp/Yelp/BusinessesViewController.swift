//
//  BusinessesViewController.swift
//  Yelp
//
//  Created by Tristan Yan on 4/07/17.
//  Copyright (c) 2015 Tristan Yan. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import DXCustomCallout_ObjC


class BusinessesViewController: UIViewController {
    
    var searchBar: UISearchBar!
    
    var businesses: [Business]!
    
    var isTableViewShowing: Bool = true
    
    var locationManager: CLLocationManager!
    
    var currentLocation: CLLocation?
    
    var deals: Bool?
    
    var sort: YelpSortMode?
    
    var radius: Double?
    
    var categories: [String]?
    
    var isMoreDataLoading = false
    
    var loadingMoreView: InfiniteScrollActivityView?
    
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
        goToLocation()
        locationManager.startUpdatingLocation()
        
        // Add SearchBar to the NavigationBar
        searchBar.sizeToFit()
        navigationItem.titleView = searchBar
        
        // Initiate InfiniteScrollActivityView
        let frame = CGRect(x: 0, y: restaurantTableView.contentSize.height, width: restaurantTableView.bounds.size.width, height: InfiniteScrollActivityView.defaultHeight)
        loadingMoreView = InfiniteScrollActivityView(frame: frame)
        loadingMoreView!.isHidden = true
        restaurantTableView.addSubview(loadingMoreView!)
        
        var insets = restaurantTableView.contentInset
        insets.bottom += InfiniteScrollActivityView.defaultHeight
        restaurantTableView.contentInset = insets
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func doSearch(_ searchText: String, offset: Int = 0) {
        doSearch(searchText, sort: sort, categories: categories, deals: deals, radius: radius, offset: offset)
    }
    
    func doSearch(_ searchText: String, sort: YelpSortMode?, categories: [String]?, deals: Bool?, radius: Double?, offset: Int = 0) {
        loadingMoreView!.startAnimating()
        var coordinateStr: String?
        
        if let userCoordinate = currentLocation?.coordinate {
            coordinateStr = "\(userCoordinate.latitude),\(userCoordinate.longitude)"
        }
        
        Business.searchWithTerm(term: searchText, sort: sort, categories: categories, deals: deals, radius: radius, coordinate:coordinateStr, offset: offset, completion: { (businesses: [Business]?, error: Error?) -> Void in
            // Update flag
            self.isMoreDataLoading = false
            
            // Stop the loading indicator
            self.loadingMoreView!.stopAnimating()
 
            if offset == 0 {
                self.businesses = businesses
            } else {
                for business in businesses! {
                    self.businesses.append(business)
                }
            }
            
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

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let filtersController = segue.destination as! FiltersViewController
        if let deals = deals {
            filtersController.filters.deal = deals
        }
        if let sort = sort {
            filtersController.filters.sort = sort
        }
        if let radius = radius {
            filtersController.filters.radius = radius
        }
        if let categories = categories {
            filtersController.filters.categories = categories
        }
        filtersController.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        doSearch(searchBar.text!, sort: sort, categories: categories, deals: deals, radius: radius)
        
        if isTableViewShowing {
            restaurantMapView.isHidden = true
        } else {
            restaurantTableView.isHidden = true
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
}

// Handle tableview
extension BusinessesViewController: UITableViewDataSource, UITableViewDelegate {
    
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
        if let imageURL = business.imageURL {
            cell.restaurantImage.setImageWith(imageURL)
        }
        cell.restaurantNameLabel.text = business.name
        cell.distanceLabel.text = business.distance
        cell.ratingImage.setImageWith(business.ratingImageURL!)
        cell.reviewsLabel.text = "\(business.reviewCount!) Reviews"
        cell.addressLabel.text = business.address
        cell.categoryLabel.text = business.categories
        return cell
    }
  
}

// Handle searchbar operations
extension BusinessesViewController: UISearchBarDelegate {
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        return true
    }
    
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        return true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.resignFirstResponder()
        doSearch("")
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        doSearch(searchBar.text!)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text == "" {
            searchBar.resignFirstResponder()
            doSearch("")
        }
    }
}

// Callback for filters change
extension BusinessesViewController: FiltersChangedDelegate {
    
    func filtersChanged(changer: FiltersViewController, filtersDidChange filters: Filters?) {
        deals = filters?.deal
        radius = filters?.radius
        
        if radius != nil {
            goToLocation()
        }
        
        categories = filters?.categories
        sort = filters?.sort
    }
}

// Map view and location service
extension BusinessesViewController: MKMapViewDelegate, CLLocationManagerDelegate {
    
    func updateAnnotations() {
        restaurantMapView.removeAnnotations(restaurantMapView.annotations)
        
        if let businesses = businesses {
            for (index, business) in businesses.enumerated() {
                let annotation = MKPointAnnotation()
                annotation.coordinate = CLLocationCoordinate2D(latitude: business.latitude!, longitude: business.longitude!)
                annotation.title = "\(index)"
                restaurantMapView.addAnnotation(annotation)
            }
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
    
    func goToLocation() {
        var span: MKCoordinateSpan?
        if let radius = radius {
           span = MKCoordinateSpanMake(radius / 1600 / 69.0, 0.1)
        } else {
           span = MKCoordinateSpanMake(1 / 69.0, 1 / 69.0)
        }
        
        let region = MKCoordinateRegionMake((currentLocation?.coordinate)!, span!)
        restaurantMapView.setRegion(region, animated: false)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last!
        let eventDate = location.timestamp
        
        if currentLocation == nil
            || eventDate.timeIntervalSinceNow.isLess(than: 15.0) && !(currentLocation?.distance(from: location).isLess(than: 50))! {
            currentLocation = location
            goToLocation()
        }
    }
}


// Handle infinite scroll
extension BusinessesViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (!isMoreDataLoading) {
            // Calculate the position of one screen length before the bottom of the results
            let scrollViewContentHeight = restaurantTableView.contentSize.height
            let scrollOffsetThreshold = scrollViewContentHeight - restaurantTableView.bounds.size.height
            
            // When the user has scrolled past the threshold, start requesting
            if(scrollView.contentOffset.y > scrollOffsetThreshold && restaurantTableView.isDragging) {
                isMoreDataLoading = true
                
                // Update position of loadingMoreView, and start loading indicator
                let frame = CGRect(x: 0, y: restaurantTableView.contentSize.height, width: restaurantTableView.bounds.size.width, height: InfiniteScrollActivityView.defaultHeight)
                loadingMoreView?.frame = frame
                
                // Code to load more results
                loadMoreData()
            }
        }
    }
    
    func loadMoreData() {
        doSearch(searchBar.text!, sort: sort, categories: categories, deals: deals, radius: radius, offset: businesses.count)
    }
}
