//
//  Cell.swift
//  Minesweeper@2019B
//
//  Created by Athar Mass on 03/04/2019.
//  Copyright © 2019 אתאר מסארוה. All rights reserved.
//

import Foundation
import UIKit


class Cell {
    enum State {
        case HiddenValue
        case Discovered
        case Flag
        case HiddenBomb
        case Mine
    }
   
    private var cellType: State = State.HiddenValue;
    private var cellValue: Int = 0;
    private var isCellOpen = false;
    
    public func setAsBomb() {
        self.cellType = State.HiddenBomb;
        self.cellValue = -1;
    }
    
    public func IncrementValue() {
        self.cellValue += 1;
    }
    
    public func OpenCell() {
        switch cellType {
        case .HiddenValue:
            self.cellType = State.Discovered;
        case .HiddenBomb:
            self.cellType = State.Mine;
        default:
            break;
        }
        self.isCellOpen = true;
    }
    
    public func GetCellType() -> State {
        return self.cellType;
    }
    
    public func GetCellValue() -> Int {
        return self.cellValue;
    }
    
    public func IsCellOpen() -> Bool {
        return self.isCellOpen;
    }
    
    public func cancelFlagMark() {
        if (cellValue != -1) {
            cellType = State.HiddenValue;
        }
        else {
            cellType = State.HiddenBomb;
        }
    }
    public func setAsFlag() {
        self.cellType = State.Flag;
    }
    
  
}
