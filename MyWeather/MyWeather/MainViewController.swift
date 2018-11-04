//
//  MainViewController.swift
//  places-address-form
//
//  Created by Work on 3/11/2561 BE.
//  Copyright © 2561 William French. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    

    var actLoading: UIActivityIndicatorView = UIActivityIndicatorView()
    override func viewDidLoad() {
        super.viewDidLoad()

        

        self.createLoadingIndicator()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.updateUI()
    }

    // MARK: - public method
    
    public func createLoadingIndicator() {
        actLoading.style = .gray
        actLoading.center = self.view.center
        actLoading.hidesWhenStopped = true
        self.view.addSubview(actLoading)
    }

    public func startIndicator() {
        actLoading.startAnimating()
        UIApplication.shared.beginIgnoringInteractionEvents()
    }
    
    public func stopIndicator() {
        actLoading.stopAnimating()
        UIApplication.shared.endIgnoringInteractionEvents()
    }
    

    public func updateUI() {
        
    }

    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
