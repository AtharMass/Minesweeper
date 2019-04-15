//
//  Game.swift
//  Minesweeper@2019B
//
//  Created by Athar Mass on 04/04/2019.
//  Copyright © 2019 אתאר מסארוה. All rights reserved.
//
import Foundation
import UIKit

enum GameState {
    case GameOver
    case Won
    case Playing
    case Waiting
    
    func GetStatus() -> String{
        switch self {
        case .GameOver:
            return "GameOver";
        case .Won:
            return "Won";
        case .Playing:
            return "Playing";
        case .Waiting:
            return "Waiting";
        }
    }
}

@IBDesignable
class Game {
    
    var board = [[Cell]]();
    var minePositions = [(row: Int, col: Int)]();
    
    let boardSize: Int;
    let minesTotal: Int;
    
    var isBoardSet = false;
    var minesCells: Int;
    var gameStatus :GameState;
    
    init(boardSize: Int, minesTotal: Int) {
        self.boardSize = boardSize;
        self.minesTotal = minesTotal;
        print("-----------------------------------")
        self.minesCells = boardSize * boardSize;
        self.gameStatus = GameState.Waiting
        
        for _ in 0...boardSize-1 {
            var arr = [Cell]();
            for _ in 0...boardSize-1 {
                arr.append(Cell());
            }
            board.append(arr);
        }
    }
    
    func placeMines(emptyCells: [Int]) {
        let maxPos = (boardSize * boardSize) - 1;
        var avaliablePositions = Set<Int>(0...maxPos);
        
        for cell in emptyCells {
            avaliablePositions.remove(cell);
        }
        
        for _ in 0...minesTotal - 1 {
            guard let minePos = avaliablePositions.randomElement() else { return; };
            let mineTuple = indexTo(index: minePos);
            
            board[mineTuple.row][mineTuple.col].setAsBomb();
            
            minePositions.append(mineTuple);
            avaliablePositions.remove(minePos);
        }
    }
    
    
    public func initBoard(startCellIndex: Int) {
        var emptyCells = [Int]();
        let cellTuple = indexTo(index: startCellIndex);
        
        emptyCells += iterateOnCellAreaWithBlock(cellTuple: cellTuple, block: { (row, col)  -> Int in
            return toIndex(tuple: (row, col));
        });
        
        placeMines(emptyCells: emptyCells);
        for mine in minePositions {
            calculateMineArea(bombTuple: mine);
        }
    }
    
    
     func calculateMineArea(bombTuple: (row: Int, col: Int)) {
        let _ = iterateOnCellAreaWithBlock(cellTuple: bombTuple, block: { row, col -> (row: Int, col: Int) in
            let cell = board[row][col];
            if(cell.GetCellType() == Cell.State.HiddenValue) {
                cell.IncrementValue();
            }
            return (row, col);
        });
    }
    
    func indexTo(index: Int) -> (row: Int, col: Int) {
        return (index / boardSize, index % boardSize);
    }
    
    func toIndex(tuple: (row: Int, col: Int)) -> Int {
        return tuple.row * boardSize + tuple.col;
    }
    
    func iterateOnCellAreaWithBlock<T>(cellTuple: (row: Int, col: Int), block: (_ blockRow: Int, _ blockCol: Int) -> T) -> [T] {
        
        var genericArr = [T]();
        
        let cellLeftUpCorner = (row: cellTuple.row - 1, col: cellTuple.col - 1);
        let cellRightDownCorner = (row: cellTuple.row + 1, col: cellTuple.col + 1);
        
        for row in cellLeftUpCorner.row...cellRightDownCorner.row {
            for col in cellLeftUpCorner.col...cellRightDownCorner.col {
                if(isNotDefinedInArray(cellTuple: (row, col))) { continue; };
                
                genericArr.append(block(row, col));
            }
        }
        
        return genericArr;
    }
    
    func isNotDefinedInArray(cellTuple: (row: Int, col: Int)) -> Bool {
        return cellTuple.row < 0 || cellTuple.row >= boardSize
            || cellTuple.col < 0 || cellTuple.col >= boardSize;
    }
    
    func printBoard() {
        for subArr in board {
            for cell in subArr {
                let cellValue = cell.GetCellValue();
                let str = String(format: "%02d", cellValue);
                print(str, " ", terminator: "");
            }
            print();
        }
    }
    
    public func touchCell(cellIndexPath: IndexPath) ->  (modifiedCells: [IndexPath], gameStatus: String)  {
        
        self.gameStatus = GameState.Playing
        let cellIndex = toIndex(tuple: (cellIndexPath.section, cellIndexPath.item));
        
        if minesCells == minesTotal  {
           self.gameStatus = GameState.Won
        }
        
        if(!isBoardSet) {
            isBoardSet = true;
            initBoard(startCellIndex: cellIndex);
        }
        
        let modifiedCells: [IndexPath];
        if(isMine(cellIndex: cellIndex)){
            modifiedCells = openAll();
            self.gameStatus = GameState.GameOver
        }
        else {
            modifiedCells = openCell(cellIndex: cellIndex);
        }
        
        return (modifiedCells, self.gameStatus.GetStatus());
    }
    
    func markCellAsFlag(cellIndexPath: IndexPath) -> (modifiedCells: [IndexPath], placedFlags: Int) {
        var modifiedCells = [IndexPath]();
        var placedFlags = 0;
        
        let cellIndex = toIndex(tuple: (cellIndexPath.section, cellIndexPath.item));
        let cellTuple = indexTo(index: cellIndex);
        let cell = board[cellTuple.row][cellTuple.col];
        
        if(!cell.IsCellOpen()) {
            if(cell.GetCellType() == Cell.State.Flag) {
                cell.cancelFlagMark();
                placedFlags = -1;
            }
            else {
                cell.setAsFlag();
                placedFlags = 1;
            }
            modifiedCells.append(cellIndexPath);
        }
        
        return (modifiedCells, placedFlags);
    }
    func openCell(cellIndex: Int) -> [IndexPath] {
        let cellTuple = indexTo(index: cellIndex);
        var indexPathArr = [IndexPath]();
        
 
        let cell = board[cellTuple.row][cellTuple.col];
        let cellType = cell.GetCellType();

        switch cellType {
        case Cell.State.HiddenValue:
            
            cell.OpenCell();
            minesCells -= 1;
            indexPathArr.append(IndexPath(item: cellTuple.col, section: cellTuple.row));
           
            
            if(cell.GetCellValue() > 0) {
                return indexPathArr;
            }
            else {
                let blockIndexPathArr =
                    iterateOnCellAreaWithBlock(cellTuple: cellTuple, block: { row, col -> [IndexPath] in
                        let tempTuple = (row, col);
                        return openCell(cellIndex: toIndex(tuple: tempTuple));
                    });
                for indexPathSubArr in blockIndexPathArr {
                    for indexPath in indexPathSubArr {
                        indexPathArr.append(indexPath);
                    }
                }
            }
            return indexPathArr;
        default:
            return indexPathArr;
        }
    }
    
    func openAll() -> [IndexPath]{
        var indexPathArr = [IndexPath]();
        for (section, cellSubArr) in board.enumerated() {
            for (item, cell) in cellSubArr.enumerated() {
                cell.OpenCell();
                indexPathArr.append(IndexPath(item: item, section: section));
            }
        }
        return indexPathArr;
    }
    
    func isMine(cellIndex: Int) -> Bool {
        let cellTuple = indexTo(index: cellIndex);
        let cellData = board[cellTuple.row][cellTuple.col];
        
        return cellData.GetCellType() == Cell.State.HiddenBomb ? true : false;
    }
    
    public func getCellDataAt(indexPath: IndexPath) -> Cell {
        return board[indexPath.section][indexPath.item];
    }
}
