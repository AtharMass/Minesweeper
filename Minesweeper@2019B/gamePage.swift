//
//  GamePage.swift
//  Minesweeper@2019B
//
//  Created by Athar Mass on 02/04/2019.
//  Copyright © 2019 אתאר מסארוה. All rights reserved.
//

import UIKit

class GamePage: UIViewController ,UICollectionViewDelegate,UICollectionViewDataSource{
    
    
    @IBOutlet weak var playerName: UILabel!
    @IBOutlet weak var faceLogoButton : UIButton!
    @IBOutlet weak var mineLeft: UILabel!
    @IBOutlet weak var gameBoardView: UICollectionView!
    @IBOutlet weak  var timer_count: UILabel!
    
    struct GameVariables {
        static var num :Int = 0
        static var totalMines :Int = 0
        static var gameStatus : String = "Waiting"
    }
    
    var gameTimer: Timer!
    var count:Int = 0
    var game: Game = Game(boardSize: 5, minesTotal: 5)
    
    var bombPositions = [Int]()
    var boardSize = 5
    var bombCount = 5
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        playerName.text = "Hello, "+ViewController.MyVariables.nameOfPlayer
        print("Player name: \(ViewController.MyVariables.nameOfPlayer)")
        print("Game Difficulty: \(ViewController.MyVariables.levelDifficulty)")
        
        //Set total mines in each game according to level difficulty
        boardInfo()
        self.boardSize = GameVariables.num ;
        self.bombCount = GameVariables.totalMines;
        mineLeft.text = String(GameVariables.totalMines)
        
        //Resize Cells
        if GameVariables.num == 5 {
            setBoard(s_width :60)
        }else{
            setBoard(s_width :30)
        }

        game = Game(boardSize: boardSize, minesTotal: bombCount);
        
        //Timer
        self.gameTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(countUpAction), userInfo: nil, repeats: true)

        //Hide Keyboard when click any where
        self.hideKeyboardWhenTappedAround()
    }
    
    //Function to hide keyboard
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer =     UITapGestureRecognizer(target: self, action:    #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    //Timer Func count up
    @objc
    func countUpAction(){
        count += 1
        timer_count.text = "Timer:\(count)"
        
    }
    //Function that init board according to level difficulty
    func setBoard(s_width :Int){
        let cellSize = CGSize(width:s_width , height:s_width)
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical //.horizontal
        layout.itemSize = cellSize
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.minimumLineSpacing = 0.0
        layout.minimumInteritemSpacing = 0.0
        gameBoardView.setCollectionViewLayout(layout, animated: true)
        
        gameBoardView.reloadData()
        
    }
    //set cells per rows according to level difficulty
    func boardInfo(){
        if ViewController.MyVariables.levelDifficulty == "Easy"{
            GameVariables.totalMines = 5
             GameVariables.num = 5
        }else{
            if ViewController.MyVariables.levelDifficulty == "Medium"{
                GameVariables.totalMines = 20
                 GameVariables.num = 10
            }else{
                 if ViewController.MyVariables.levelDifficulty == "Hard"{
                    GameVariables.totalMines = 30
                    GameVariables.num = 10
                }
            }
        }
    }
    @IBAction func startNewGame(_ sender: UILongPressGestureRecognizer) {
        //Reset Game
        game = Game(boardSize: boardSize, minesTotal: bombCount);
        //Reset Timer
        count = 0
        gameTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(countUpAction), userInfo: nil, repeats: true)
        //
       self.viewDidLoad()
        if GameVariables.num == 5 {
            setBoard(s_width :60)
        }else{
            setBoard(s_width :30)
        }
        gameBoardView.reloadData()
       
    }
    
    
    @IBAction func longPress(_ sender: UILongPressGestureRecognizer) {
        if(sender.state == UIGestureRecognizer.State.began) {
           
            let touchPoint = sender.location(in: gameBoardView);
            guard let indexPath = gameBoardView.indexPathForItem(at: touchPoint) else { return; };
            if(self.bombCount > 0){
                let pressedCell = game.markCellAsFlag(cellIndexPath: indexPath);
                
                self.bombCount -= pressedCell.placedFlags;
                mineLeft.text = String( self.bombCount);
                
                dataChanged(collectionView: gameBoardView, indexPathArr: pressedCell.modifiedCells);
            }
        }
    }
    
    func endGame() {
        self.gameTimer.invalidate();
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(3), execute: {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "EndGame") as! EndGameView
            self.present(vc, animated: true, completion: nil)
    
        });
    }
    func dataChanged(collectionView: UICollectionView, indexPathArr: [IndexPath]) {
        collectionView.reloadItems(at: indexPathArr);
    }
   func numberOfSections(in collectionView: UICollectionView) -> Int {
        return  GameVariables.num
    }
    func collectionView( _ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return GameVariables.num
    }
    
    func collectionView( _ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = gameBoardView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)as! CollectionViewCell

        if GameVariables.num == 5 {
            cell.setupCell(size_changed: 60)
        }else{
           cell.setupCell(size_changed :30)
        }
        
        let cellData = game.getCellDataAt(indexPath: indexPath);
        let cellValue = cellData.GetCellValue();
        let cellType = cellData.GetCellType();
        
        switch cellType {
            
        case Cell.State.Flag:
            if(cell.imageView.image != nil) {
                 cell.imageView.image = UIImage(named: "btnflag");
            }
            
        case Cell.State.Mine:
            if(cell.imageView.image != nil) {
                cell.imageView.image = UIImage(named: "button_bomb_exp");
            }

        case Cell.State.Discovered:
            if(cellValue == 0){
                if(cell.imageView.image != nil) {
                   cell.imageView.image = UIImage(named: "button_blank");
                }
               
            }
            else {
                switch cellValue{
                case 1:
                    if(cell.imageView.image != nil) {
                        cell.imageView.image = UIImage(named: "button1");
                    }
                case 2:
                    if(cell.imageView.image != nil) {
                        cell.imageView.image = UIImage(named: "button_2");
                    }
                case 3:
                    if(cell.imageView.image != nil) {
                        cell.imageView.image = UIImage(named: "button_3");
                    }
                case 4:
                    if(cell.imageView.image != nil) {
                        cell.imageView.image = UIImage(named: "button_4");
                    }
                case 5:
                    if(cell.imageView.image != nil) {
                        cell.imageView.image = UIImage(named: "button_5");
                    }
                case 6:
                    if(cell.imageView.image != nil) {
                        cell.imageView.image = UIImage(named: "button_6");
                    }
                case 7:
                    if(cell.imageView.image != nil) {
                        cell.imageView.image = UIImage(named: "button_7");
                    }
                case 8:
                    if(cell.imageView.image != nil) {
                        cell.imageView.image = UIImage(named: "button_8");
                    }
                default:
                    break;
                }
            }
            
        default:
            break;
        }
        return cell;
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let pressedCell = game.touchCell(cellIndexPath: indexPath);
        
        dataChanged(collectionView: collectionView, indexPathArr: pressedCell.modifiedCells);
        
       if(pressedCell.gameStatus == "GameOver") {
            GameVariables.gameStatus = "GameOver"
            faceLogoButton.setBackgroundImage(UIImage(named: "cry"), for: UIControl.State.normal)
            //.imageView!.image = UIImage(named: "cry")
            endGame();
        }
       else{
            if(pressedCell.gameStatus == "Won") {
                GameVariables.gameStatus = "Won"
                faceLogoButton.setBackgroundImage(UIImage(named: "glass"), for: UIControl.State.normal)
                endGame();
            }
            else{
                if(pressedCell.gameStatus == "Playing"){
                     GameVariables.gameStatus = "Playing"
                }
            }
        }
        gameBoardView.reloadData()
    }
 
    
}
