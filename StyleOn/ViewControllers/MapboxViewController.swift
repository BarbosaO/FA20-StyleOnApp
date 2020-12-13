//
//  MapboxViewController.swift
//  StyleOn
//
//  Created by LAP on 9/30/20.
//  Copyright © 2020 Ramses Machado. All rights reserved.
//

import SwiftUI
import Firebase
import Mapbox
import MapboxMobileEvents
import CoreLocation


class MapboxViewController: UIViewController, MGLMapViewDelegate {

    let locationManager = CLLocationManager()
    var posts = [UserPosts]()
    
    var mapView: MGLMapView?
    var preciseButton: UIButton?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.getAuthorization()
        self.observe()
        
    }

    
    

    func mapView(_ mapView: MGLMapView, didFinishLoading style: MGLStyle) {

        // Create point to represent where the symbol should be placed
        let point = MGLPointAnnotation()
        point.coordinate = mapView.centerCoordinate

        // Create a data source to hold the point data
        let shapeSource = MGLShapeSource(identifier: "marker-source", shape: point, options: nil)

        // Create a style layer for the symbol
        let shapeLayer = MGLSymbolStyleLayer(identifier: "marker-style", source: shapeSource)

        // Add the image to the style's sprite
//            if let image = UIImage(named: "house-icon") {
//                style.setImage(image, forName: "home-symbol")
//            }
        
        if let image = UIImage(named: "house-icon") {
            style.setImage(image, forName: "home-symbol")
        }

        // Tell the layer to use the image in the sprite
        shapeLayer.iconImageName = NSExpression(forConstantValue: "home-symbol")

        // Add the source and style layer to the map
        style.addSource(shapeSource)
        style.addLayer(shapeLayer)
    }
    
    
    func loadPostsByArea() -> [String: Any]{
        
        var dict:[String: Any]!
        
        
        return dict
        
    }
    
    func observe() {
        let postsRef = Firestore.firestore().collection("post")

        postsRef.addSnapshotListener{ snapshot, error in

            var tempPosts = [UserPosts]()
            
            for child in snapshot!.documents {
                if  let data = child.data() as? [String:Any],
                    let first_name = data["AuthorDisplayName"] as? String,
                    let postTitle = data["Title"] as? String,
                    let post_address = data["Address"] as? String,
                    let postDescription = data["Description"] as? String,
                    let coordinates = data["Coordinates"] as? [String: Any],
                    let postUrl = data["PostUrl"] as? String,
                    let url = URL(string:postUrl)
                {

                        // Store variables from DB into post
                    let post = UserPosts(
                        author: first_name,
                        postTitle: postTitle,
                        postDescription: postDescription,
                        postUrl: url,
                        postAddress: post_address,
                        coordinates:coordinates
                    )

                    tempPosts.append(post)
                }
            }

            self.posts = tempPosts
            self.loadMap()

        }
    }
    
    func loadMap(){
        
        let mapView = MGLMapView(frame: view.bounds)
//        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mapView.delegate = self

        mapView.showsUserLocation = true
        // Set the map’s center coordinate and zoom level.
        let userLoc = mapView.userLocation!
        userLoc.title = "Hello"
        userLoc.subtitle = "I am here!"

        let userLat = userLoc.coordinate.latitude
        let userLon = userLoc.coordinate.longitude
        
        print("Current Lat: " + String( userLat ))
        print("Current Long: " + String( userLon ))
        
//        41.8864, longitude: -87.7135),
        mapView.setCenter(CLLocationCoordinate2D(latitude: 41.8864, longitude: -87.7135), zoomLevel: 15, animated: true)
        
        for child in self.posts {
            
            let postCoord = child.coordinates as [String: Any]
            let postTitle = child.postTitle as String
            
            print(postTitle)
            
            if postCoord.isEmpty {
                continue
            }
            
            let lat = postCoord["lat"] as? String
            let long = postCoord["long"] as? String
            
            print("Lat: " + lat!)
            print("Long: " + long!)
            
            let latDegrees = Double( lat! ) ?? 0.0
            let longDegrees = Double( long! ) ?? 0.0

            // Add a point annotation
            let annotation = MGLPointAnnotation()
            annotation.coordinate = CLLocationCoordinate2D(latitude: latDegrees, longitude: longDegrees )
            annotation.title = postTitle
//                annotation.subtitle = "The biggest park in New York City!"
            
            mapView.addAnnotation(annotation)
            mapView.selectAnnotation(annotation, animated: false, completionHandler: nil)
            
        }
        
        view.addSubview(mapView)
        let button = UIButton(frame: CGRect(x: 10, y: 10, width: 100, height: 50))
         button.setTitle("Back", for: .normal)
         button.backgroundColor = .white
        button.setTitleColor(UIColor.systemTeal, for: .normal)
         button.addTarget(self, action: #selector(self.buttonTapped), for: .touchUpInside)
         view.addSubview(button)
        
    }
    
    func getAuthorization(){
        
        //getting User's permission if not granted yet
        let authorizationStatus = CLLocationManager.authorizationStatus()
        
        if authorizationStatus == .notDetermined {
         
            locationManager.requestWhenInUseAuthorization()
            print("Authorized: Granted while in Use")
            return
        }
        
        //report if geolocation not granted
        if authorizationStatus == .denied || authorizationStatus == .restricted {
            
            print("Authorized: Denied")
            return
        }
        
        if authorizationStatus == .authorizedWhenInUse {
            print("Authorized: While in Use")
        }
        
        if authorizationStatus == .authorizedAlways {
            print("Authorized: Always")
        }
         
    }
    
    @objc func buttonTapped(sender: UIButton!) {
        self.dismiss(animated: true, completion: nil);
   }

}
