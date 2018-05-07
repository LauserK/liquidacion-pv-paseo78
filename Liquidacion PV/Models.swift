//
//  Models.swift
//  Liquidacion PV
//
//  Created by Macbook on 2/5/18.
//  Copyright © 2018 Grupo Paseo. All rights reserved.
//

import Foundation
import SwiftyJSON

class User {

}

class Station {
    var ID: Int?
    var serial_number: String?
    
    func getAll(completion:@escaping ([Station]) -> Void){
        /*
            Get a list of all stations
            
            RETURNS
            --------
            Array [Station]
         */
        var stations = [Station]()
        
        ToolsPaseo().consultGET(path: "ventas/stations/") { data in
            
            for (_, subJson):(String, JSON) in data["data"] {
                let station = Station()
                station.ID = subJson["numero"].int!
                station.serial_number = subJson["serial"].string!
                stations.append(station)
            }
            
            completion(stations)
        }
    }
}

class Device {
    var ID: Int?
    var serial_number: String?
    
    func getByStation(station_number: Int, completion:@escaping ([Device]) -> Void){
        /*
         Get a list of all devices associate to a station
         
         RETURNS
         --------
         Array [Device]
         */
        
        var devices = [Device]()
        
        ToolsPaseo().consultGET(path: "ventas/stations/\(station_number)/devices") { data in
            for (_, subJson):(String, JSON) in data["data"] {
                let device = Device()
                device.ID = subJson["numero"].int!
                device.serial_number = subJson["serial"].string!
                devices.append(device)
            }

            completion(devices)
        }
        
    }
}

class Ticket {
    var card_number: String?
    var auth_number: String?
    var amount: String?
    var bill_number: String?
}

class Report {
    var station_number: String?
    var lote_number: String?
    var serial_number: String?
    var total_tdd: String?
    var total_tdc: String?
    var total_tdc_tdd: String?
    var user: User?
}

class Session {
    var ID: String?
    var total_tdd: Double?
    var total_tdc: Double?
    var total_tdc_tdd: Double?
    var total_ndc: Double?
    var user: User?
    
    
    func getByStation(station_number: Int, completion:@escaping (Session) -> Void){
        /*
         Get a list of all devices associate to a station
         
         RETURNS
         --------
         Session Object
         
         */
        
        ToolsPaseo().consultGET(path: "ventas/stations/\(station_number)/session") { data in
            let session = Session()
            session.total_tdd = Double(data["data"][0]["tdd"].string!) ?? 0.00
            session.total_tdc = Double(data["data"][0]["tdc"].string!) ?? 0.00
            session.total_ndc = Double(data["data"][0]["notas_creditos"].string!) ?? 0.00
            completion(session)
        }
        
    }
}
