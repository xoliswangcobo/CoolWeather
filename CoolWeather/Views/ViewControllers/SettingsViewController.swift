//
//  SettingsViewController.swift
//  CoolWeather
//
//  Created by Xoliswa on 2020/08/10.
//  Copyright © 2020 Xoliswa. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var settings: SettingsStore!
    
    @IBOutlet weak var forecast:UITextField!
    @IBOutlet weak var historical:UITextField!
    
    // UIPickers
    @IBOutlet var forecastDaysPicker: UIPickerView!
    @IBOutlet var historicalDaysPicker: UIPickerView!
    
    var completion:(() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUIPickers()
        
        self.forecast.text = String(self.settings.forecastDays)
        self.historical.text = String(self.settings.historyDays)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.bag.dispose()
    }
    
    func setupUIPickers() {
        self.forecastDaysPicker = UIPickerView()
        self.forecastDaysPicker.delegate = self
        self.forecastDaysPicker.dataSource = self
        self.forecastDaysPicker.selectRow(self.settings.forecastDays-1, inComponent: 0, animated: false)
        self.forecast.inputView = self.forecastDaysPicker
        
        self.historicalDaysPicker = UIPickerView()
        self.historicalDaysPicker.delegate = self
        self.historicalDaysPicker.dataSource = self
        self.historicalDaysPicker.selectRow(self.settings.historyDays-1, inComponent: 0, animated: false)
        self.historical.inputView = self.historicalDaysPicker
    }

    @IBAction func close(sender: UIBarButtonItem) {
        self.dismiss(animated: true) {
            self.completion?()
        }
    }
    
    // UIPicker
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == self.forecastDaysPicker {
            return self.settings.forecastDaysLimit
        }
        
        if pickerView == self.historicalDaysPicker {
            return self.settings.historyDaysLimit
        }
        
        return 0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(row+1)"
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == self.forecastDaysPicker {
            self.settings.forecastDays = row+1
            self.forecast.text = String(self.settings.forecastDays)
        }
        
        if pickerView == self.historicalDaysPicker {
            self.settings.historyDays = row+1
            self.historical.text = String(self.settings.historyDays)
        }
    }
}
