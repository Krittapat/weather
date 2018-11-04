//
//  ForecastAllDayViewController.swift
//  MyWeather
//
//  Created by Work on 4/11/2561 BE.
//  Copyright © 2561 LearningProject. All rights reserved.
//

import UIKit

class ForecastAllDayViewController: MainViewController, UITableViewDataSource, UITableViewDelegate {

    lazy var viewModel: ForecastAllDayViewModel = {
        return ForecastAllDayViewModel()
    }()
    @IBOutlet weak var tvForcast: UITableView!
    @IBOutlet weak var btnTempType: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.updateLoadingStatus = { [weak self] () in
            DispatchQueue.main.async {
                self?.updateUI()
            }
        }
        
        // Do any additional setup after loading the view.
        self.viewModel.requetForcasrTempAtLocation(aLocation: viewModel.location)
    }
    
    @IBAction func toggleTempType(_ sender: Any) {
        viewModel.toggleTypeOfTemp(typeOfTemp: viewModel.getTypeOfTemp())
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    override func updateUI() {
        if viewModel.isLoading {
            self.startIndicator()
        }else {
            self.stopIndicator()
        }
        
        self.tvForcast.reloadData()
        self.btnTempType.setAttributedTitle(viewModel.getTitleTypeOfTemp(typeOfTemp: viewModel.getTypeOfTemp()), for: .normal)
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.tableLists!.count

    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath) as! ForcastTableViewCell
        cell.lbTime.text = viewModel.getTime(indexPath: indexPath)
        cell.lbDate.text = viewModel.getDate(indexPath: indexPath)
        
        cell.lbTemperature.text = viewModel.getTemp(indexPath: indexPath)
        cell.lbHumidity.text = viewModel.getHumidity(indexPath: indexPath)

        
        return cell
    }

}
