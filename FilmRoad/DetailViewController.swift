//
//  DetailViewController.swift
//  FilmRoad
//
//  Created by hello on 4/3/25.
//

import UIKit
import MapKit

class DetailViewController: UIViewController {
    var place: FilmRoadItem?
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var lblInfo: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lblPhone: UILabel!
    @IBOutlet weak var lblDesc: UITextView!
    @IBOutlet weak var lblName: UILabel!
    
    var latitudeStr = ""
    var longitudeStr = ""
    var location: [String] = []
    var naverURL = "https://search.naver.com/search.naver?where=nexearch&sm=top_hty&fbm=0&ie=utf8&query="
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        guard let place else {return}
        lblName.text = place.placeName
        lblDesc.text = place.description
        lblAddress.text = place.address
        lblTime.text = place.subDescription
        lblPhone.text = place.tel
        lblInfo.text = "update info : ".appending(place.issuedDate)
        
        location = place.coordinates.split(separator: " ").map { String($0) }

        latitudeStr = String(location[0].dropFirst().dropLast())
        longitudeStr = String(location[1].dropFirst())
        
        guard let latitude = Double(latitudeStr) else {return}
        guard let longitude = Double(longitudeStr) else {return}
        
        
        
        let location = CLLocationCoordinate2D(latitude: latitude,  longitude: longitude)
        let span = MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
        let region = MKCoordinateRegion(center: location, span: span)
        
        mapView.setRegion(region, animated: true)
        mapView.preferredConfiguration = MKStandardMapConfiguration()
        let pin = CustomAnnotation(coordinate: location, title: place.placeName, subtitle: place.mediaTitle, strURL: naverURL.appending(place.placeName).appending(" \(place.mediaTitle)"))
        mapView.addAnnotation(pin)
        mapView.delegate = self
        navigationItem.title = place.mediaTitle

    }
    
    
    
    @IBAction func actChangeMap(_ sender: Any) {
        guard let segment = sender as? UISegmentedControl else {return}
        switch segment.selectedSegmentIndex{
        case 1: mapView.preferredConfiguration = MKImageryMapConfiguration()
        case 2: mapView.preferredConfiguration = MKHybridMapConfiguration()
        default: mapView.preferredConfiguration = MKStandardMapConfiguration()
        }
    }
    
    
}


class CustomAnnotation: NSObject, MKAnnotation{
    var coordinate: CLLocationCoordinate2D

    var title: String?

    var subtitle: String?
    let strURL: String
    
    init(coordinate: CLLocationCoordinate2D, title: String? = nil, subtitle: String? = nil, strURL: String) {
        self.coordinate = coordinate
        self.title = title
        self.subtitle = subtitle
        self.strURL = strURL
    }
}



extension DetailViewController: MKMapViewDelegate{
    func mapView(_ mapView: MKMapView, viewFor annotation: any MKAnnotation) -> MKAnnotationView? {
        guard let annotation = annotation as? CustomAnnotation else {return nil}
        
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "pin")
        if annotationView == nil {
            annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: "pin")
            let btn = UIButton(type: .detailDisclosure)
            annotationView?.rightCalloutAccessoryView = btn
            annotationView?.canShowCallout = true
        }
        annotationView?.annotation = annotation
        
        return annotationView
    }
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        guard let annotation = view.annotation as? CustomAnnotation else{return}
        
        print(annotation.title ?? "")
        print(annotation.strURL)
        
        
        guard let targetVC = storyboard?.instantiateViewController(identifier: "web") as? WebViewController else {return}
        
        targetVC.url = URL(string: annotation.strURL)
        self.navigationController?.pushViewController(targetVC, animated: true)
    }
}
