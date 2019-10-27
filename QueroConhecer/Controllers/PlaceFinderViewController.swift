//
//  PlaceFinderViewController.swift
//  QueroConhecer
//
//  Created by Leonardo Almeida on 13/10/19.
//  Copyright © 2019 Leonardo Almeida. All rights reserved.
//

import UIKit
import MapKit

protocol PlaceFinderDelegate: class {
    func addPlace(_ place: Place)
    }

class PlaceFinderViewController: UIViewController {

    enum PlaceFinderMessageType {
        case error(String)
        case confirmation(String)
    }
    
    @IBOutlet weak var tfCity: UITextField!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var aiLoading: UIActivityIndicatorView!
    @IBOutlet weak var viLoad: UIView!
    
    var place: Place!
    weak var delegate: PlaceFinderDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let gesture = UILongPressGestureRecognizer(target: self, action: #selector(getLocation(_:)))
        gesture.minimumPressDuration = 2.0
        mapView.addGestureRecognizer(gesture)
    }
    
    @objc func getLocation(_ gesture: UILongPressGestureRecognizer){
        if gesture.state == .began {
            load(show: true)
            let point = gesture.location(in: mapView)
            let coordinate = mapView.convert(point, toCoordinateFrom: mapView)
            let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
            CLGeocoder().reverseGeocodeLocation(location) { (placemarks, error) in
                self.load(show: false)
                self.errorValidate(error, placemarks)
            }
        }
    }
    
    @IBAction func findCity(_ sender: UIButton) {
        tfCity.resignFirstResponder()
        let address = tfCity.text!
        load(show: true)
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(address) { (placemarks, error) in
            self.load(show: false)
                self.errorValidate(error, placemarks)
        }
    }
    
    func errorValidate(_ error: Error?, _ placemarks: [CLPlacemark]?){
        if error == nil {
            if let placemark = placemarks?.first! {
                 self.savePlace(with: placemark)
            }
        } else {
            let sError = String(error!.localizedDescription)
            if sError.contains("8") {
                self.showMessage(type: .error("Não foi encontrado nenhum local com esse nome"))
            } else if sError.contains("2") {
                self.showMessage(type: .error("Perda de conectividade"))
            } else {
                self.showMessage(type: .error("Erro desconhecido"))
            }
        }
    }
    
    
    func savePlace(with placemark: CLPlacemark?) -> Bool {
        guard let placemark = placemark , let coordinate = placemark.location?.coordinate else {
             return false
        }
        let name = placemark.name ?? placemark.country ?? "Desconhecido"
        let address = Place.getFormattedAdrress(with: placemark)
        place = Place(name: name, latitude: coordinate.latitude, longitudade: coordinate.longitude, address: address)
        
        let region = MKCoordinateRegion(center: coordinate, latitudinalMeters: 3500, longitudinalMeters: 3500)
        mapView.setRegion(region, animated: true)
        
        self.showMessage(type: .confirmation(place.name))
        
        return true
    }

    func showMessage(type: PlaceFinderMessageType) {
        let title: String, message: String
        var hasConfirmation: Bool = false
        
        switch type {
            case .confirmation(let name):
                title = "Local encontrado"
                message = "Deseja adicionar \(name)?"
                hasConfirmation = true
            
                print("\(name)")
            case .error(let errorMessage):
                title = "Erro"
                message = errorMessage
        }
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
        
        if hasConfirmation {
                let confirmAction = UIAlertAction(title: "OK", style: .default, handler: { (action) in
                    self.delegate?.addPlace(self.place)
                    self.dismiss(animated: true, completion: nil)
            })
            
            alert.addAction(confirmAction)
            alert.addAction(cancelAction)
        } else {
            alert.addAction(cancelAction)
        }
        present(alert, animated: true, completion: nil)
    }
    

    func load(show: Bool) {
        viLoad.isHidden = !show
        if show {
            aiLoading.startAnimating()
        } else {
            aiLoading.stopAnimating()
        }
    }
    
    @IBAction func close(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }

}
