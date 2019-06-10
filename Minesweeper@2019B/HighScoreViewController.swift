//
//  HighScoreViewController.swift
//  Minesweeper@2019B
//
//  Created by Athar Mass on 22/05/2019.
//  Copyright © 2019 אתאר מסארוה. All rights reserved.
//

import UIKit
import MapKit
import FirebaseDatabase

class HighScoreViewController: UIViewController ,UITableViewDataSource,UITableViewDelegate{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listScore.count;
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HighScoreCell", for: indexPath) as! HighScoreCell;
                let cellData = listScore[indexPath.row];
                cell.name.text = cellData.GetName();
                cell.score.text = "\(cellData.GetScore())";
                cell.lat.text = String(format: "%.2f", cellData.GetLat());
                cell.lng.text = String(format: "%.2f", cellData.GetLng());
                cell.difficulty.text = cellData.GetDifficult();
        
                return cell;
    }
    
    
    
    var database: DatabaseReference! = Database.database().reference();
    @IBOutlet weak var map: MKMapView!
    @IBOutlet weak var tableScores: UITableView!
    @IBOutlet var viewCont: UIView!
    
    var listScore = [HigScoreData]();
    var cellData: HigScoreData = HigScoreData(name: "", score: 0, lat: 0, lng: 0, difficulty: "");
    var scores = [HigScoreData]()
    var counter = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("------- Displaying High Score -------")
        tableScores.delegate = self
        tableScores.dataSource = self
        
        self.database.child("users").queryOrdered(byChild: "score").observeSingleEvent(of: DataEventType.value, with: { (snapshot) in
            for child in snapshot.children {
                self.scores = []
                guard let temp = child as? DataSnapshot else { continue };
                guard let tempDictionary = temp.value as? NSDictionary else { continue };
                guard let score = tempDictionary.value(forKey: "score") as? Int else { continue };
                guard let latitudinal = tempDictionary.value(forKey: "lat") as? Double else { continue };
                guard let longitudinal = tempDictionary.value(forKey: "lng") as? Double else { continue };
                guard let difficulty = tempDictionary.value(forKey: "difficulty") as? String else { continue };
                
                self.cellData = HigScoreData(name: temp.key, score: score, lat: latitudinal, lng: longitudinal, difficulty: difficulty);
                
                self.scores.insert(self.cellData, at: 0)
        
                if(self.counter<10){
                    self.listScore.append(self.cellData)
                    self.map.addAnnotation(self.cellData);
                    self.counter = self.counter + 1
                }
                
            }
            self.tableScores.reloadData();
            self.centerMapOnLocation(location: CLLocation(latitude: self.listScore[0].GetLat(), longitude: self.listScore[0].GetLng()));
        })
    }
    
    @IBAction func refreshPage(_ sender: Any) {
        self.listScore = []
        self.scores = []
        counter = 0
        self.database.child("users").queryOrdered(byChild: "score").observeSingleEvent(of: DataEventType.value, with: { (snapshot) in
            for child in snapshot.children {
                self.scores = []
                guard let temp = child as? DataSnapshot else { continue };
                guard let tempDictionary = temp.value as? NSDictionary else { continue };
                guard let score = tempDictionary.value(forKey: "score") as? Int else { continue };
                guard let latitudinal = tempDictionary.value(forKey: "lat") as? Double else { continue };
                guard let longitudinal = tempDictionary.value(forKey: "lng") as? Double else { continue };
                guard let difficulty = tempDictionary.value(forKey: "difficulty") as? String else { continue };
                
                self.cellData = HigScoreData(name: temp.key, score: score, lat: latitudinal, lng: longitudinal, difficulty: difficulty);
                
                self.scores.insert(self.cellData, at: 0)
                
                if(self.counter<10){
                    self.listScore.append(self.cellData)
                    self.map.addAnnotation(self.cellData);
                    self.counter = self.counter + 1
                }
                
            }
            self.tableScores.reloadData();
            self.centerMapOnLocation(location: CLLocation(latitude: self.listScore[0].GetLat(), longitude: self.listScore[0].GetLng()));
        })
    }
    func centerMapOnLocation(location: CLLocation) {
        let regionRadius: CLLocationDistance = 10000;
        let coordinateRegion = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius);
        
        self.map.setRegion(coordinateRegion, animated: true)
    }

}
