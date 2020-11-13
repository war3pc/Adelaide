//
//  VenesViewController.swift
//  AdelaideFringe
//
//  Created by kevin on 2020/11/11.
//

import UIKit
import MapKit


class ADEVenueViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    var locations = [ADELocation]()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        getNenueData()
        mapView.delegate = self

    }
}

extension ADEVenueViewController {

    
    fileprivate func getNenueData() {
        guard let url = URL(string: "http://partiklezoo.com/fringer/?action=venues") else { return }
        LoadingIndicatorView.show()
        let dataTask = URLSession.shared.dataTask(with: url) { (data, urlResponse, error) in
            DispatchQueue.main.async {
                LoadingIndicatorView.hide()
                if error != nil { return }
                if let data = data, let array = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? Array<Dictionary<String, String>> {
                    self.locations.removeAll()
                    for dictionary in array {
                        let location = ADELocation()
                        location.setValuesForKeys(dictionary)
                        self.locations.append(location)
                    }
                    if let last = self.locations.last {
                        let center = CLLocationCoordinate2D(latitude: last.latitude, longitude: last.longitude)
                        let span = MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02)
                        self.mapView.region = MKCoordinateRegion(center: center, span: span)
                    }
                    for locaction in self.locations {
                        self.mapSetting(location: locaction)
                    }
                }
            }

        }
        dataTask.resume()

    }
}


extension ADEVenueViewController: MKMapViewDelegate {
    func mapSetting(location: ADELocation) {
        let center =  CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
     
        let annotation = MKPointAnnotation()
        annotation.coordinate = center
        annotation.title = location.name
        annotation.subtitle = ""
        mapView.addAnnotation(annotation)

    }

    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {

        let circleRenderer = MKCircleRenderer(overlay: overlay)
        circleRenderer.strokeColor = UIColor(red: 74/255, green: 144/255, blue: 226/255, alpha: 0.5)
        circleRenderer.fillColor = UIColor(red: 74/255, green: 144/255, blue: 226/255, alpha: 0.5)
        return circleRenderer
    }

}

