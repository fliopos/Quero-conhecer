//
//  MapViewController.swift
//  QueroConhecer
//
//  Created by Leonardo Almeida on 13/10/19.
//  Copyright © 2019 Leonardo Almeida. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var lbName: UILabel!
    @IBOutlet weak var lbAddress: UILabel!
    
    var places: [Place]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        for place in places {
             addToMap(place)
            lbName.text = place.name
            lbAddress.text = place.address
            searchBar.isHidden = true
        }
        
        showPlaces()
    }
    
    func addToMap(_ place: Place){
        let annotation = MKPointAnnotation()
        annotation.coordinate = place.coordinate
        annotation.title = place.name
        mapView.addAnnotation(annotation)
    }

    func showPlaces() {
        mapView.showAnnotations(mapView.annotations, animated: true)
    }

    @IBAction func showRoute(_ sender: UIButton) {
    }
    
    @IBAction func showSearchBar(_ sender: UIBarButtonItem) {
    }
    
}
