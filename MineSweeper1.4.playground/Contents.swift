//: # MineSweeper - Text based game

import Cocoa

var studentname = "Darius Little"

class Cell {
    var nBombs = 0 // number of bombs in the cells around this cell
    var open = false // true indicates that the content of the cell is visible
    var bomb = false // true indicates that the cell has a bomb
    var neighbors = [Cell]() // we are not using this yet
    var counting = false
    
    init() {
        
    }
    
    func countBombs() {
        if !counting {
            nBombs = 0
            for neighbor in neighbors {
                if neighbor.bomb {
                    nBombs += 1
                }
                counting = true
                neighbor.countBombs()
            }
            //counting = false
        }
    }
    
    func openCell() -> Bool {
        if !open {
            open = true
            if nBombs == 0 && bomb != true {
                for neighbor in neighbors {
                    neighbor.openCell()
                }
            }
        }
        return bomb
    }
    
    func addNeighbor(neighbor: Cell) {
        if self !== neighbor {
            neighbors.append(neighbor)
        }
    }
    
    func description() -> String {
        return open ? (bomb ? "[X]" : (nBombs == 0 ? "[ ]" : "[" + nBombs.description + "]")) : "\u{25A2}"
    }
}

//: ## Main declarations

class Board {
    var width = 5
    var height = 7
    var board = [[Cell]]()
    
    init(newWidth: Int, newHeight: Int) {
        width = newWidth
        height = newHeight
        for row in 0..<width {
            let r = [Cell]()
            board.append(r)
            for _ in 0..<height {
                let c = Cell()
                board[row].append(c)
            }
        }
        var bombsLeft = width * height/10
        while bombsLeft > 0 {
            let rPoint = Int(arc4random_uniform(UInt32(height)))
            let cPoint = Int(arc4random_uniform(UInt32(width)))
            if board[cPoint][rPoint].bomb == false {
                board[cPoint][rPoint].bomb = true
                bombsLeft -= 1
            }
        }
        connectNeighbors()
        countBombs()
    }
    
    func openCell(row: Int, col: Int) -> Bool{
        var result : Bool = false
        if withinBounds(cRow: row, cCol: col) {
            result = board[col][row].openCell()
        }
        return result
    }
    
    func withinBounds(cRow: Int, cCol: Int) -> Bool {
        if cRow >= 0 && cRow < height && cCol >= 0 && cCol < width {
            return true
        } else {
            return false
        }
    }
    
    func printBoard() {
        for row in 0..<height {
            for column in 0..<width {
                print(board[column][row].description(), terminator:" ")
            }
            print("")
        }

    }
    
    func connectNeighbors() {
        for row in 0..<height {
            for column in 0..<width {
                if board[column][row].bomb == false {
                    for rd in -1...1 {
                        for cd in -1...1 {
                            let cRow = row + rd
                            let cColumn = column + cd
                            if withinBounds(cRow: cRow, cCol: cColumn) {
                                board[column][row].addNeighbor(neighbor: board[cColumn][cRow])
                            }
                        }
                    }
                }
            }
        }
    }

    func countBombs() {
        board[0][0].countBombs()
        /*
        for row in 0..<height {
            for column in 0..<width {
                if board[column][row].bomb == false {
                    board[column][row].countBombs()
                }
            }
        }
 */
    }
}

let ms = Board(newWidth: 10, newHeight: 7)
ms.printBoard()
print("-----")
ms.openCell(row: 1, col: 1)
ms.printBoard()
print("-----")
ms.openCell(row: 3, col: 4)
ms.printBoard()
print("-----")




