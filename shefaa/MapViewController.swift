//
//  MapViewController.swift
//  shefaa
//
//  Created by Nour  on 3/25/17.
//  Copyright © 2017 Nour . All rights reserved.
//

import UIKit
import GoogleMaps

class MapViewController: UIViewController {
    

    override func viewDidLoad() {
        super.viewDidLoad()

        let camera = GMSCameraPosition.camera(withLatitude: -33.86, longitude: 151.20, zoom: 6.0)
        let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        view = mapView
    }



}
