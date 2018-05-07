//
//  tools.swift
//  Liquidacion PV
//
//  Created by Macbook on 3/5/18.
//  Copyright © 2018 Grupo Paseo. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class ToolsPaseo {
    let webservice = "http://10.10.2.15:8000/api/v1/"
    
    func loadingView(vc: UIViewController, msg: String){
        let alert = UIAlertController(title: nil, message: msg, preferredStyle: .alert)
        
        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        loadingIndicator.startAnimating();
        
        alert.view.addSubview(loadingIndicator)
        vc.present(alert, animated: true, completion: nil)
    }
    
    
    // Method por make a http POST request to webservice and returning a JSON object
    func consultPOST(path: String, params: [String:String]?, completion:@escaping (JSON) -> Void){
        
        Alamofire.request("\(webservice)\(path)", method: .post, parameters:params).responseString {
            response in
            
            if let json = response.result.value {
                let data = JSON.init(parseJSON:json)
                completion(data)
            }
        }
        
    }
    
    // Method por make a http GET request to webservice and returning a JSON object
    func consultGET(path: String, completion:@escaping (JSON) -> Void){
        Alamofire.request("\(webservice)\(path)", method: .get).responseString {
            response in
            
            if let json = response.result.value {
                let data = JSON.init(parseJSON:json)
                completion(data)
            }
        }
        
    }
}

extension Double {
    func roundToDecimal(_ fractionDigits: Int) -> Double {
        let multiplier = pow(10, Double(fractionDigits))
        return Darwin.round(self * multiplier) / multiplier
    }
}
