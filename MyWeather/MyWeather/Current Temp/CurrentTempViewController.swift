//
//  CurrentTempViewController.swift
//  places-address-form
//
//  Created by Work on 3/11/2561 BE.
//  Copyright © 2561 William French. All rights reserved.
//

import UIKit


class CurrentTempViewController: MainViewController {
    lazy var viewModel: CurrentTempViewModel = {
        return CurrentTempViewModel()
    }()
    @IBOutlet weak var btnTempType: UIButton!
    @IBOutlet weak var btnInputName: UIButton!
    @IBOutlet weak var lbLocationDescription: UILabel!
    @IBOutlet weak var lbTemperature: UILabel!
    @IBOutlet weak var lbHumidity: UILabel!
    @IBOutlet weak var lbLocationDescritption: UILabel!
    @IBOutlet weak var bbtnWholeDay: UIBarButtonItem!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        viewModel.updateLoadingStatus = { [weak self] () in
            DispatchQueue.main.async {
                self?.updateUI()
            }
        }
        
        viewModel.updateCurrentTemp = { [weak self] () in
            DispatchQueue.main.async {
                self?.updateUI()
            }
        }
        
        
        viewModel.updateLocation  = { [weak self] () in
            DispatchQueue.main.async {
                self?.updateUI()
                
                guard let aLocation = self?.viewModel.location else {
                    return
                }
                self?.viewModel.requetCurrentTempAtLocation(aLocation: aLocation)
            }
        }

    
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func gotoForecast(_ sender: Any) {

        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let vc = storyboard.instantiateViewController(withIdentifier: "ForecastAllDayViewController") as? ForecastAllDayViewController {
            
//            let navigationController = UINavigationController(rootViewController: vc)
//            DispatchQueue.main.async {
//                self.present(navigationController, animated: true, completion: {
//
//                })
//            }
            vc.viewModel.location = self.viewModel.location
            self.navigationController?.pushViewController(vc, animated: true)
            
        }
        
        
    }
    
    @IBAction func toggleTempType(_ sender: Any) {
        viewModel.toggleTypeOfTemp(typeOfTemp: viewModel.getTypeOfTemp())
    }
    
    @IBAction func autocompleteClicked(_ sender: UIButton) {
        let autocompleteController = FindPlaceViewController()
        autocompleteController.didSelectLocation = { [weak self] aLocation in
            DispatchQueue.main.async {
                self?.viewModel.location = aLocation
            }
        }
        present(autocompleteController, animated: true, completion: nil)
    }
    
    
    override func updateUI() {
        if viewModel.isLoading {
            self.startIndicator()
        }else {
            self.stopIndicator()
        }
        self.lbHumidity.text = viewModel.getHumidityStr()
        self.lbTemperature.text = viewModel.getTemperatureStr()
        
        self.btnInputName.setTitle(viewModel.getInputLocationTitle(), for: .normal)
        self.btnInputName.backgroundColor = .clear
        self.btnInputName.layer.cornerRadius = 10
        self.btnInputName.layer.borderWidth = 1
        self.btnInputName.layer.borderColor = UIColor.black.cgColor
        
        self.lbLocationDescription.text = viewModel.getLocationDetail()
        
        self.btnTempType.setAttributedTitle(viewModel.getTitleTypeOfTemp(typeOfTemp: viewModel.getTypeOfTemp()), for: .normal)
        
        self.bbtnWholeDay.isEnabled = (viewModel.location.inPutName.count > 0)
    }
}
