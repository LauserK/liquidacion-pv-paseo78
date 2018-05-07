//
//  ViewController.swift
//  Liquidacion PV
//
//  Created by Macbook on 28/4/18.
//  Copyright © 2018 Grupo Paseo. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    @IBOutlet weak var StationTerminalNumberPicker: UIPickerView!
    @IBOutlet weak var LoteNumberInput: UITextField!
    @IBOutlet weak var SerialNumberPicker: UIPickerView!
    @IBOutlet weak var TDDInput: UITextField!
    @IBOutlet weak var TDCInput: UITextField!
    @IBOutlet weak var TotalInput: UITextField!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var arriba: NSLayoutConstraint!
    
    @IBOutlet weak var abajo: NSLayoutConstraint!
    var stations = [Station]()
    var devices = [Device]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Observer for quantity inputs
        self.TDDInput.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        self.TDCInput.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        // Connect data PickerView
        self.StationTerminalNumberPicker.delegate = self
        self.StationTerminalNumberPicker.dataSource = self
        self.SerialNumberPicker.delegate = self
        self.SerialNumberPicker.dataSource = self
        
        Station().getAll() { stations in
            /*
                Set data to Station Picker (StationTerminalNumberPicker)
             */
            self.stations = stations
            self.StationTerminalNumberPicker.reloadAllComponents()
        }
        
    }

    
    @IBAction func SendButtonClick(_ sender: Any) {
        Session().getByStation(station_number: 10){ data in
            let user_total_tdd = Double(self.TDDInput.text ?? "0.0") ?? 0.00
            let user_total_tdc = Double(self.TDCInput.text ?? "0.0") ?? 0.00
            let user_total     = user_total_tdd + user_total_tdc
            
            let system_total = (data.total_tdd ?? 0.00) + (data.total_tdc ?? 0.00)
            
            let total_ndc = data.total_ndc ?? 0.00
            
            if (user_total == (system_total - total_ndc) ){
                // create the alert
                let alert = UIAlertController(title: "¡PROCESADO!", message: "¡Se han reportado los datos correctamente!", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                // show the alert
                self.present(alert, animated: true, completion: nil)
                
            } else {
                // create the alert
                let alert = UIAlertController(title: "¡PROBLEMA!", message: "¡Se han encontrado incongruencias en los datos, se procede a reportar comprobantes!", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.destructive, handler: nil))
                // show the alert
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    func textFieldDidChange(_ textField: UITextField) {
        let tdd = Double(self.TDDInput.text!) ?? 0.00
        let tdc = Double(self.TDCInput.text!) ?? 0.00
        self.TotalInput.text = "Bs. \(tdd + tdc)"
        
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0{
                self.abajo.constant = -250
                self.arriba.constant = -250
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            self.abajo.constant = 0
            self.arriba.constant = 25
        }
    }
    
    // Cuando damos tap en el view se quita el teclado
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
        if self.view.frame.origin.y != 0{
            self.abajo.constant = 0
            self.arriba.constant = 0
        }
    }
    
    // Picker methods
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // Seteamos el row a 1
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        if (pickerView == StationTerminalNumberPicker){
            return self.stations.count
        } else if(pickerView == SerialNumberPicker) {
            return self.devices.count
        }
        
        return 1
    }
    
    // Seteamos los arreglos(data) a los picker
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if (pickerView == StationTerminalNumberPicker){
            return "Caja: \(self.stations[row].ID!)"
        } else if (pickerView == SerialNumberPicker) {
            return "PV: \(self.devices[row].ID!) - \(self.devices[row].serial_number!)"
        }
        return ""
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if(pickerView == StationTerminalNumberPicker){
            let station = self.stations[row]
            
            Device().getByStation(station_number: station.ID!){ devices in
                self.devices = devices
                self.SerialNumberPicker.reloadAllComponents()
            }
        
        }
    
    }


}

