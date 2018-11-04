//
//  FindPlaceViewController.swift
//  MyWeather
//
//  Created by Work on 3/11/2561 BE.
//  Copyright © 2561 LearningProject. All rights reserved.
//

import UIKit
import GooglePlaces

class FindPlaceViewController: GMSAutocompleteViewController,GMSAutocompleteViewControllerDelegate {

    
    var didSelectLocation:( (LocationModel) -> ())?

    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.delegate = self
        // Do any additional setup after loading the view.
        
        // Set a filter to return only addresses.
        let addressFilter = GMSAutocompleteFilter()
        addressFilter.type = .geocode
        self.autocompleteFilter = addressFilter
    }
    
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        
        var location :LocationModel = LocationModel()
        


        location.inPutName = place.name
        
        location.latitude = "\(place.coordinate.latitude)"
        location.longitude = "\(place.coordinate.longitude)"
        
//        if let latitude:String = "\(place.coordinate.latitude)"{
//            location.latitude = latitude
//        }
//
//        if let longitude:String = "\(place.coordinate.longitude)"{
//            location.longitude = longitude
//        }
        
        
        
        // Get the address components.
        if let addressLines = place.addressComponents {
            // Populate all of the address fields we can find.
            for field in addressLines {
                switch field.type {
                case kGMSPlaceTypeStreetNumber:
                    location.street_number = field.name
                case kGMSPlaceTypeRoute:
                    location.route = field.name
                case kGMSPlaceTypeNeighborhood:
                    location.neighborhood = field.name
                case kGMSPlaceTypeLocality:
                    location.locality = field.name
                case kGMSPlaceTypeAdministrativeAreaLevel1:
                    location.administrative_area_level_1 = field.name
                case kGMSPlaceTypeCountry:
                    location.country = field.name
                case kGMSPlaceTypePostalCode:
                    location.postal_code = field.name
                case kGMSPlaceTypePostalCodeSuffix:
                    location.postal_code_suffix = field.name
                // Print the items we aren't using.
                default:
                    print("Type: \(field.type), Name: \(field.name)")
                }
            }
        }
        
        self.dismiss(animated: true) {
            if let select = self.didSelectLocation {
                select(location)
            }
        }
        

        
        // Call custom function to populate the address form.
//        fillAddressForm()

        // Close the autocomplete widget.
//        self.dismiss(animated: true, completion: nil)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        // TODO: handle the error.
        print("Error: ", error.localizedDescription)
    }
    
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    // Show the network activity indicator.
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    // Hide the network activity indicator.
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }

}
