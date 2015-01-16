//
//  CameraMapViewController.swift
//  Sample
//
//  Created by Muneeb Samuels on 2015/01/15.
//  Copyright (c) 2015 Codebus.io (Pty) Ltd. All rights reserved.
//

import UIKit

class CameraMapViewController: UIViewController, CLLocationManagerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let locationManager = CLLocationManager()
        locationManager.delegate = self
        
        locationManager.startUpdatingLocation()
        
        var camera = GMSCameraPosition.cameraWithLatitude(-33.933319551433456,
            longitude:18.41806411743164, zoom:8.5, bearing:30, viewingAngle:40)
        
        var mapView = GMSMapView.mapWithFrame(CGRectZero, camera:camera)
        mapView.myLocationEnabled = true
        
        self.view = mapView
    }
}
