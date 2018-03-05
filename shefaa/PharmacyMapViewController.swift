//
//  ViewController.swift
//  GMapsDemo
//
//  Created by Gabriel Theodoropoulos on 29/3/15.
//  Copyright (c) 2015 Appcoda. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import BTNavigationDropdownMenu
import Alamofire
import SwiftyJSON
import SCLAlertView
import Material



class PharmacyMapViewController: UIViewController, CLLocationManagerDelegate, GMSMapViewDelegate {
    
    var viewMap: GMSMapView!
    var lblInfo: UILabel!
    
    let progressHUD = ProgressHUD(text: "")
    
    var resultsViewController: GMSAutocompleteResultsViewController?
    var searchController: UISearchController?
    var resultView: UITextView?
    
    var doctors:[Pharmacy]!
    var filtered:[Pharmacy]!
    var lat:Double!
    
    var long:Double!
    var mylat:Double!
    var mylong:Double!
    
    var locationManager = CLLocationManager()
    
    var didFindMyLocation = false
    
    var mapTasks = MapTasks()
    
    var locationMarker: GMSMarker!
    
    var originMarker: GMSMarker!
    
    var destinationMarker: GMSMarker!
    
    var routePolyline: GMSPolyline!
    
    var markersArray: Array<GMSMarker> = []
    
    var waypointsArray: Array<String> = []
    
    var travelMode = TravelModes.driving
    
    
    
    //    var subView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.prepareView()
        self.load()
        loadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        let camera: GMSCameraPosition = GMSCameraPosition.camera(withLatitude: 33.5138073, longitude: 36.2765279, zoom: 10.0)
        viewMap.camera = camera
        viewMap.delegate = self
        viewMap.settings.myLocationButton = true
        //viewMap.addObserver(self, forKeyPath: "myLocation", options: NSKeyValueObservingOptions.new, context: nil)
        viewMap.addObserver(self, forKeyPath: "myLocation", options: .new, context: nil)
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        viewMap.removeObserver(self, forKeyPath: "myLocation", context: nil)
    }
    
    
    
    func prepareView() {
        viewMap = GMSMapView()
        
        self.title = NSLocalizedString("Find a Pharmacy", comment: "")
        self.navigationItem.titleLabel.textColor = .white
        view.addSubview(viewMap)
        
        _ = viewMap.anchor8(view, topattribute: .top, topConstant: 0, leftview: view, leftattribute: .leading, leftConstant: 0, bottomview: view, bottomattribute: .bottom, bottomConstant: 0, rightview: view, rightattribute: .trailing, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        self.view.addSubview(progressHUD)
        _ = progressHUD.anchor(view.topAnchor, left: view.leadingAnchor, bottom: view.bottomAnchor, right: view.trailingAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        progressHUD.hide()
        
        view.backgroundColor = Color.white
    }
    
    
    
    
    func loadData(){
        print("load")
        progressHUD.show()
        let url = Globals.mainUrl + "/api/search_medicine_service" + Globals.api.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        print(url)
        Alamofire.request(url).responseJSON { response in
            
            if let JSON = response.result.value {
                print("JSON: \(JSON)")
                let res = Pharmacy.modelsFromDictionaryArray(array: JSON as! NSArray)
                self.doctors = res
                self.filtered = self.doctors
                
                self.setOutLetsMarkers()
            }
            self.progressHUD.hide()
        }
        
        
    }
    
    
    func setOutLetsMarkers(){
        var markersArray:[GMSMarker] = [GMSMarker]()
        viewMap.clear()
        
        if let mylat = mylat,let mylong = mylong{
            let marker = GMSMarker(position: CLLocationCoordinate2DMake(mylat, mylong))
            marker.map = viewMap
            marker.icon = GMSMarker.markerImage(with: UIColor.blue)
            markersArray.append(marker)
        }
        for i in 0..<filtered.count {
            let out = filtered[i]
            var splat = 0.0
            var splong = 0.0
            
            if let lat = out.latitude {
                splat = Double(lat)!
            }
            
            if let long = out.longitude
            {
                splong = Double(long)!
                
            }
            
            let marker = GMSMarker(position: CLLocationCoordinate2DMake(splat, splong))
            marker.map = viewMap
            marker.icon = GMSMarker.markerImage(with: UIColor.red)
            
            markersArray.append(marker)
            
            if(splat != 0.0 && splong != 0.0)
            {
                
                
                markersArray[i].map = viewMap
                
                markersArray[i].userData = out
                
                markersArray[i].title = out.pharmacy_name
              
                
            }
            
            
        }
        
        
        
        
    }

    
    
    func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {
        
        let doctor = marker.userData as! Pharmacy
        let vc = PharmacyProfileViewController()
        vc.pharmacy = doctor
        vc.title = doctor.pharmacy_name!
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    func load(){
        
        
        resultsViewController = GMSAutocompleteResultsViewController()
        resultsViewController?.delegate = self
        
        searchController = UISearchController(searchResultsController: resultsViewController)
        searchController?.searchResultsUpdater = resultsViewController
        
        let subView = UIView(frame: CGRect(x: 0, y: 65.0, width: view.frame.width, height: 45.0))
        
        subView.addSubview((searchController?.searchBar)!)
        view.addSubview(subView)
        lblInfo = UILabel()
        lblInfo.text = NSLocalizedString("Allow Shefaa to see your location from settings", comment: "")
        lblInfo.textColor = .red
        view.addSubview(lblInfo)
        lblInfo.isHidden = true
        _ = lblInfo.anchor8(subView, topattribute: .bottom, topConstant: 0, leftview: view, leftattribute: .leading, leftConstant: 0, bottomview: nil, bottomattribute: nil, bottomConstant: 0, rightview: view, rightattribute: .trailing, rightConstant: 0, widthConstant: 0, heightConstant: 30)
        searchController?.searchBar.sizeToFit()
        searchController?.hidesNavigationBarDuringPresentation = false
        
        definesPresentationContext = true
        
        navigationController?.navigationBar.isTranslucent = false
        searchController?.hidesNavigationBarDuringPresentation = false
        
        
        self.extendedLayoutIncludesOpaqueBars = true
        self.edgesForExtendedLayout = .top
    }
    
    
    
    private func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            locationManager.requestAlwaysAuthorization()
            break
        case .authorizedWhenInUse:
            locationManager.startUpdatingLocation()
            lblInfo.isHidden = true
            break
        case .authorizedAlways:
            locationManager.startUpdatingLocation()
            lblInfo.isHidden = true
            break
        case .restricted:
            lblInfo.isHidden = false
            // restricted by e.g. parental controls. User can't enable Location Services
            break
        case .denied:
            lblInfo.isHidden = false
            showAlertWithMessage(message: "please allow Shefaa to determine your location")
            break
        }
    }
    
    
    func locationManager(_ manager: CLLocationManager,      didUpdateLocations locations: [CLLocation]) {
        
        let location = locationManager.location?.coordinate
        
        cameraMoveToLocation(toLocation: location)
        
    }
    var first = true
    
    func cameraMoveToLocation(toLocation: CLLocationCoordinate2D?) {
        if(first){
            if toLocation != nil {
                viewMap.camera = GMSCameraPosition.camera(withTarget: toLocation!, zoom: 10)
                viewMap.settings.myLocationButton = true
                setupLocationMarker(coordinate: toLocation! , snippet: "You")
                self.mylat = toLocation?.latitude
                self.mylong = toLocation?.longitude
                self.lat = self.mylat
                self.long = self.mylong
                first = false
            }
            
        }
    }
    
    
    
    
    
    func showAlertWithMessage(message: String) {
        let alertController = UIAlertController(title: "Shefaa", message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        let closeAction = UIAlertAction(title: "Close", style: UIAlertActionStyle.cancel) { (alertAction) -> Void in
            
        }
        
        alertController.addAction(closeAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    
    func setupLocationMarker(coordinate: CLLocationCoordinate2D,snippet:String = "The best place on earth",disc:String = "") {
        if locationMarker != nil {
            locationMarker.map = nil
        }
        
        locationMarker = GMSMarker(position: coordinate)
        locationMarker.map = viewMap
        
        locationMarker.title = mapTasks.fetchedFormattedAddress
        locationMarker.appearAnimation = GMSMarkerAnimation.pop
        locationMarker.icon = GMSMarker.markerImage(with: UIColor.blue)
        locationMarker.opacity = 0.75
        
        locationMarker.isFlat = true
        locationMarker.snippet = snippet
        locationMarker.title = disc
    }
    
    
    func configureMapAndMarkersForRoute() {
        viewMap.camera = GMSCameraPosition.camera(withTarget: mapTasks.originCoordinate, zoom: 9.0)
        
        originMarker = GMSMarker(position: self.mapTasks.originCoordinate)
        originMarker.map = self.viewMap
        originMarker.icon = GMSMarker.markerImage(with: UIColor.green)
        originMarker.title = self.mapTasks.originAddress
        
        destinationMarker = GMSMarker(position: self.mapTasks.destinationCoordinate)
        destinationMarker.map = self.viewMap
        destinationMarker.icon = GMSMarker.markerImage(with: UIColor.red)
        destinationMarker.title = self.mapTasks.destinationAddress
        
        
        if waypointsArray.count > 0 {
            for waypoint in waypointsArray {
                let lat: Double = (waypoint.components(separatedBy: ",")[0] as NSString).doubleValue
                let lng: Double = (waypoint.components(separatedBy: ",")[1] as NSString).doubleValue
                
                let marker = GMSMarker(position: CLLocationCoordinate2DMake(lat, lng))
                marker.map = viewMap
                marker.icon = GMSMarker.markerImage(with: UIColor.blue)
                
                markersArray.append(marker)
            }
        }
    }
    
    
    func drawRoute() {
        let route = mapTasks.overviewPolyline["points"] as! String
        
        let path: GMSPath = GMSPath(fromEncodedPath: route)!
        routePolyline = GMSPolyline(path: path)
        routePolyline.map = viewMap
    }
    
    
    func displayRouteInfo() {
        lblInfo.text = mapTasks.totalDistance + "\n" + mapTasks.totalDuration
    }
    
    
    func clearRoute() {
        originMarker.map = nil
        destinationMarker.map = nil
        routePolyline.map = nil
        
        originMarker = nil
        destinationMarker = nil
        routePolyline = nil
        
        if markersArray.count > 0 {
            for marker in markersArray {
                marker.map = nil
            }
            
            markersArray.removeAll(keepingCapacity: false)
        }
    }
    
    
    
    func recreateRoute() {
        if let _ = routePolyline {
            clearRoute()
            
            mapTasks.getDirections(origin: mapTasks.originCoordinate, destination: mapTasks.destinationCoordinate, waypoints: waypointsArray, travelMode: travelMode, completionHandler: { (status, success) -> Void in
                
                if success {
                    self.configureMapAndMarkersForRoute()
                    self.drawRoute()
                    self.displayRouteInfo()
                }
                else {
                    
                }
            })
        }
    }
    
    
    // MARK: GMSMapViewDelegate method implementation
    
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        if let _ = routePolyline {
            let positionString = String(format: "%f", coordinate.latitude) + "," + String(format: "%f", coordinate.longitude)
            waypointsArray.append(positionString)
            
            recreateRoute()
        }
    }
    
    
    
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if !didFindMyLocation {
            let myLocation: CLLocation = change![NSKeyValueChangeKey.newKey] as! CLLocation
            
            viewMap.camera = GMSCameraPosition.camera(withTarget: myLocation.coordinate, zoom: 10.0)
            viewMap.settings.myLocationButton = true
            setupLocationMarker(coordinate: myLocation.coordinate, snippet: "You")
            self.mylat = myLocation.coordinate.latitude
            self.mylong = myLocation.coordinate.longitude
            self.lat = self.mylat
            self.long = self.mylong
            
            didFindMyLocation = true
        }
        if ((object as AnyObject).isFinished == true )
        {
            
            (object as AnyObject).removeObserver(self, forKeyPath: keyPath!)
            
        }
    }
    
    
    
    
    func filterDoctors(_ location:CLLocation){
        
        filtered = doctors.filter { result in
            
            let doctor =  result
            
            let lat  = Double(doctor.latitude!)!
            let long = Double(doctor.longitude!)!
            
            let coordinate = CLLocation(latitude: lat , longitude: long)
            let distance = location.distance(from: coordinate) / 1000
            
            return ( distance < 20 )
        }
        
    }
    
    
}




extension PharmacyMapViewController: GMSAutocompleteResultsViewControllerDelegate {
    
    public func resultsController(_ resultsController: GMSAutocompleteResultsViewController, didFailAutocompleteWithError error: Error) {
        print("Error")
    }
    
    
    
    func resultsController(_ resultsController: GMSAutocompleteResultsViewController,
                           didAutocompleteWith place: GMSPlace) {
        
        
        searchController?.isActive = false
        
        self.lat = place.coordinate.latitude
        self.long = place.coordinate.longitude
        let location = CLLocation(latitude: place.coordinate.latitude, longitude: place.coordinate.longitude)
        filterDoctors(location)
        setOutLetsMarkers()
        
        let coordinate = CLLocationCoordinate2D(latitude: place.coordinate.latitude, longitude: place.coordinate.longitude)
        self.viewMap.camera = GMSCameraPosition.camera(withTarget: coordinate, zoom: 15)
        
        self.setupLocationMarker(coordinate: coordinate,snippet: place.name)
    }
    
    
    
    func resultsController(resultsController: GMSAutocompleteResultsViewController,
                           didFailAutocompleteWithError error: NSError){
        // TODO: handle the error.
        print("Error: ", error.description)
    }
    
    // Turn the network activity indicator on and off again.
    
    
    func didRequestAutocompletePredictionsForResultsController(resultsController: GMSAutocompleteResultsViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    
    func didUpdateAutocompletePredictionsForResultsController(resultsController: GMSAutocompleteResultsViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
    
    
}
