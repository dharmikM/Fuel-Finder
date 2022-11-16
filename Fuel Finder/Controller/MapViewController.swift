//
//  MapViewController.swift
//  FuelFinder
//
//  Created by D M.
//

import UIKit
import CoreLocation
import MapKit
import Combine

class MapViewController: UIViewController,CLLocationManagerDelegate {
    
    
    //MARK: Outlets
    //----------------
    @IBOutlet weak var fuelMapView: MKMapView!
    

    //MARK: Properties
    //----------------
    var locationMananger:CLLocationManager!
    private let gasPriceFetcher = GasPriceFetcher.getInstance()
    var gasStationData: [GasPrice] = [GasPrice]()
    private var cancellables : Set<AnyCancellable> = []
    
    
    //MARK: Functions
    //----------------
    private func receiveChanges(){
        self.gasPriceFetcher.$gasPriceData.receive(on: RunLoop.main).sink{(updatedLaunchObjects) in
            self.gasStationData.removeAll()
            self.gasStationData.append(contentsOf: updatedLaunchObjects)
            self.fuelMapView.isScrollEnabled = false
            self.fuelMapView.reloadInputViews()
        }
        .store(in: &cancellables)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true
        navigationItem.hidesBackButton = true
        tabBarController?.tabBar.isHidden = false
    }
    
 
    
    override func viewDidLoad() {
        super.viewDidLoad()

        locationMananger = CLLocationManager()
        locationMananger.delegate = self
        self.receiveChanges()
        self.gasPriceFetcher.priceDataRecivedFromAPI()
        locationMananger.requestWhenInUseAuthorization()
        locationMananger.startUpdatingLocation()
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let locationOfUser = locations.first{
                   let latitudeOfLocation = locationOfUser.coordinate.latitude
                   let longitudeOfLocation = locationOfUser.coordinate.longitude
                   
                   let updatedlocation = CLLocationCoordinate2D(latitude: latitudeOfLocation, longitude: longitudeOfLocation)
                   
                   let visibleLocationSet = MKCoordinateRegion(center: updatedlocation, span: MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2))
                   
                   let pointOfInterestRequest = MKLocalPointsOfInterestRequest(center: updatedlocation, radius: 10000.0)
                   let setPOICategory = [MKPointOfInterestCategory.gasStation]
                   self.fuelMapView.pointOfInterestFilter = .init(including: setPOICategory)
                   pointOfInterestRequest.pointOfInterestFilter = .init(including: setPOICategory)
       
       
                   let search = MKLocalSearch(request: pointOfInterestRequest)
                          search.start { (searchResult , error ) in
       
                              guard let searchResult = searchResult else {
                                  return
                              }
                              for getMapItemdata in searchResult.mapItems {
                                  for gasStationDataValues in self.gasStationData {
                                      let annotation = MKPointAnnotation()
                                      
                                      if (gasStationDataValues.id == getMapItemdata.phoneNumber) {
                                          annotation.coordinate = getMapItemdata.placemark.coordinate
                                          annotation.title = getMapItemdata.name
                                          annotation.subtitle = "Normal Gas: \(gasStationDataValues.normalGas) Premium Gas: \(gasStationDataValues.premiumGas)"
                                            
                                          
                                                                               
                                                DispatchQueue.main.async {
                                                        self.fuelMapView.addAnnotation(annotation)
                                                    
                                                    
                                                            }
                                                        }
                                  }
                                      
                                      
                                   
                                      
                               
                                  
                              }
       
                          }
                   self.fuelMapView.setRegion(visibleLocationSet, animated: true)

               }
    
    }
    

 

}
