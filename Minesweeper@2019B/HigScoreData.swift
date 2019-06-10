//
//  HigScoreData.swift
//  Minesweeper@2019B
//
//  Created by Athar Mass on 06/06/2019.
//  Copyright © 2019 אתאר מסארוה. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class HigScoreData: NSObject, MKAnnotation {
    
    private var name: String;
    private var difficulty: String;
    private var score: Int;
    private var lat: Double;
    private var lng: Double;
    var coordinate: CLLocationCoordinate2D
    
    init(name: String, score: Int, lat: Double, lng: Double,difficulty: String) {
        self.name = name;
        self.score = score;
        self.lat = lat;
        self.lng = lng;
        self.difficulty = difficulty;
        self.coordinate = CLLocationCoordinate2D(latitude: self.lat, longitude: self.lng);
    }
    public func SetDifficulty(difficulty: String) {
        self.difficulty = difficulty;
    }
    public func SetName(name: String) {
        self.name = name;
    }
    
    public func SetScore(score: Int) {
        self.score = score;
    }
    
    public func SetLat(lat: Double) {
        self.lat = lat;
        SetCoordinate();
    }
    
    public func SetLng(lng: Double) {
        self.lng = lng;
        SetCoordinate();
    }
    
    private func SetCoordinate() {
        self.coordinate = CLLocationCoordinate2D(latitude: self.lat, longitude: self.lng);
    }
    
    public func GetName() -> String {
        return self.name;
    }
    
    public func GetScore() -> Int {
        return self.score;
    }
    public func GetDifficult() -> String {
        return self.difficulty;
    }
    public func GetLat() -> Double {
        return self.lat;
    }
    
    public func GetLng() -> Double {
        return self.lng;
    }
    
    public func GetDictionary() -> [String : Any] {
        return ["score" : self.score,
                "lat" : self.lat,
                "lng" : self.lng,
                "difficulty" : self.difficulty]
    }
    
    var title: String? {
        return self.name
    }
    
    
}
