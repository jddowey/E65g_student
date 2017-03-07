import Foundation

public typealias Position = (row: Int, col: Int)

public enum CellState {
    case alive, empty, born, died
    
    var isAlive: Bool {
        switch self {
        case .alive, .born: return true
        default: return false
        }
    }
}

public struct Cell {
    var position = Position(row:0, col:0)
    var state = CellState.empty
}

public struct Grid {
    private var _cells: [[Cell]]
    
    public var rows: Int { return _cells.count }
    public var cols: Int { return _cells[0].count }
    public var positions: [Position] {
        return (0 ..< rows)
            .lazy
            .map { row in zip( [Int](repeating: row, count: self.cols), 0 ..< self.cols ) }
            .flatMap { $0 }
    }
    
    public init(_ rows: Int, _ cols: Int, cellInitializer: (Position) -> CellState = { _, _ in .empty } ) {
        _cells = [[Cell]]( repeatElement( [Cell](repeatElement(Cell(), count: rows)), count: cols) )
        positions.forEach {
            self[$0].position = $0
            self[$0].state    = cellInitializer($0)
        }
    }
    
    private func normalize(position: Position) -> Position {
        return Position(
            row: ((position.row % rows) + rows) % rows,
            col: ((position.col % cols) + cols) % cols
        )
    }

    public subscript (pos: Position) -> Cell {
        get {
            let pos = normalize(position: pos)
            return _cells[pos.row][pos.col]
        }
        set {
            let pos = normalize(position: pos)
            _cells[pos.row][pos.col] = newValue
        }
    }
    
    private static let offsets: [Position] = [
        (row: -1, col:  -1), (row: -1, col:  0), (row: -1, col:  1),
        (row:  0, col:  -1),                     (row:  0, col:  1),
        (row:  1, col:  -1), (row:  1, col:  0), (row:  1, col:  1)
    ]
    private func neighbors(of cell: Cell) -> [Cell] {
        return Grid.offsets.lazy.map {
            let position = normalize(position: Position(
                row: (cell.position.row + $0.row),
                col: (cell.position.col + $0.col)
            ))
            return self[position]
        }
    }
    
    private func nextState(of cell: Cell) -> CellState {
        switch neighbors(of: cell).filter({ $0.state.isAlive }).count {
        case 2 where cell.state.isAlive,
             3: return cell.state.isAlive ? .alive : .born
        default: return cell.state.isAlive ? .died  : .empty
        }
    }
    
    public func next() -> Grid {
        var nextGrid = Grid(rows, cols)
        positions.forEach {
            nextGrid[$0] = Cell(
                position: Position(row: $0.row, col: $0.col),
                state: self.nextState(of: self[$0])
            )
        }
        return nextGrid
    }
}

public extension Grid {
    public var description: String {
        return positions.reduce("") {
            var s = $0 + (self[$1].state.isAlive ? "*" : " ")
            if $1.col == self.cols - 1 { s += "\n" }
            return s
        }
    }
    public var living: [Position] { return positions.flatMap { return  self[$0].state.isAlive   ? $0 : nil } }
    public var dead  : [Position] { return positions.flatMap { return !self[$0].state.isAlive   ? $0 : nil } }
    public var alive : [Position] { return positions.flatMap { return  self[$0].state == .alive ? $0 : nil } }
    public var born  : [Position] { return positions.flatMap { return  self[$0].state == .born  ? $0 : nil } }
    public var died  : [Position] { return positions.flatMap { return  self[$0].state == .died  ? $0 : nil } }
    public var empty : [Position] { return positions.flatMap { return  self[$0].state == .empty ? $0 : nil } }
}

extension Grid: Sequence {
    public struct SimpleGridIterator: IteratorProtocol {
        private var grid: Grid
        
        public init(grid: Grid) {
            self.grid = grid
        }
        
        public mutating func next() -> Grid? {
            grid = grid.next()
            return grid
        }
    }
    
    public struct HistoricGridIterator: IteratorProtocol {
        private class GridHistory: Equatable {
            let positions: [Position]
            let previous:  GridHistory?
            
            static func == (lhs: GridHistory, rhs: GridHistory) -> Bool {
                guard lhs.positions.count == rhs.positions.count else { return false }
                let zipped = zip(lhs.positions, rhs.positions)
                for pair in zipped { if pair.0.row != pair.1.row || pair.0.col != pair.1.col { return false } }
                return true
            }
            
            init(_ positions: [Position], _ previous: GridHistory? = nil) {
                self.positions = positions
                self.previous = previous
            }
            
            var hasCycle: Bool {
                var prev = previous
                while prev != nil {
                    if self == prev { return true }
                    prev = prev!.previous
                }
                return false
            }
        }
        
        private var grid: Grid
        private var history: GridHistory!
        
        init(grid: Grid) {
            self.grid = grid
            self.history = GridHistory(grid.living)
        }
        
        public mutating func next() -> Grid? {
            if history.hasCycle { return nil }
            let newGrid = grid.next()
            history = GridHistory(newGrid.living, history)
            grid = newGrid
            return grid
        }
    }
    
    public func makeIterator() -> HistoricGridIterator {
        return HistoricGridIterator(grid: self)
    }
}


/*
 Testing
 */
var grid = Grid(10, 10) { _,_ in arc4random_uniform(3) == 2 ? .alive : .empty }
print ("\(grid.living.count)\n\n\(grid.description)\n\n\n\n\n\n")

func gliderInitializer(row: Int, col: Int) -> CellState {
    switch (row, col) {
    case (0, 1), (1, 2), (2, 0), (2, 1), (2, 2): return .alive
    default: return .empty
    }
}

grid = Grid(5, 5, cellInitializer: gliderInitializer)
print (grid.description)

for nextGrid in grid { print ("\(nextGrid.description)\n") }

let theEnd = "The End"

