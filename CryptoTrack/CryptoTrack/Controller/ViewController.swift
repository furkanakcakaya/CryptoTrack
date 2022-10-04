//
//  ViewController.swift
//  CryptoTrack
//
//  Created by Furkan Akçakaya on 24.09.2022.
//

import UIKit

class ViewController: UIViewController{
    var cryptoManager = CryptoManager()

    @IBOutlet weak var currencyPicker: UIPickerView!
    @IBOutlet weak var currencyLabel: UILabel!
    @IBOutlet weak var coinLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        currencyPicker.dataSource = self
        currencyPicker.delegate = self
        cryptoManager.delegate = self
        cryptoManager.getCoinPrice(for: "TRY")
    }
}

extension ViewController: CryptoManagerDelegate{
    func didUpdateRate(_ rate: String, _ currency: String) {
        DispatchQueue.main.async {
            self.currencyLabel.text = currency
            self.coinLabel.text = rate
        }
    }
    
    func didFailWithError(_ error: Error) {
        print(error)
    }
}

extension ViewController:UIPickerViewDataSource, UIPickerViewDelegate{
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return cryptoManager.currencyArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return cryptoManager.currencyArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let selectedCurrency = cryptoManager.currencyArray[row]
        cryptoManager.getCoinPrice(for: selectedCurrency)
    }
    
}
