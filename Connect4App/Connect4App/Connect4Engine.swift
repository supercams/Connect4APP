import Foundation

enum Player: Equatable {
    case one
    case two

    var next: Player { self == .one ? .two : .one }
}

enum GameResult: Equatable {
    case playing
    case p1Win
    case p2Win
    case draw
}

enum Difficulty: Equatable {
    case easy
    case hard
}

struct Connect4Engine {

    
    static let rows: Int = 8
    static let cols: Int = 8
    static let winCount: Int = 4

    static let empty: Character = "-"          // EMPTY_SQUARE
    static let p1Piece: Character = "x"        // PLAYER_ONE_PIECE
    static let p2Piece: Character = "o"        // PLAYER_TWO_PIECE

    
    private(set) var board: [[Character]]
    private(set) var currentPlayer: Player = .one
    private(set) var result: GameResult = .playing

    init() {
        self.board = Self.buildBoard()
    }

    mutating func reset() {
        board = Self.buildBoard()
        currentPlayer = .one
        result = .playing
    }

    private func playMark(_ player: Player) -> Character {
        return (player == .one) ? Self.p1Piece : Self.p2Piece
    }

    private func otherPlayer(_ p: Player) -> Player {
        return p.next
    }

    private func onBoard(_ r: Int, _ c: Int) -> Bool {
        return r >= 0 && r < Self.rows && c >= 0 && c < Self.cols
    }

    static func buildBoard() -> [[Character]] {
        return Array(repeating: Array(repeating: empty, count: cols), count: rows)
    }

    func boardToString() -> String {
        board.map { String($0) }.joined(separator: "\n")
    }

    @discardableResult
    mutating func dropPiece(_ player: Player, column0: Int) -> Bool {
        guard column0 >= 0 && column0 < Self.cols else { return false }

        for r in stride(from: Self.rows - 1, through: 0, by: -1) {
            if board[r][column0] == Self.empty {
                board[r][column0] = playMark(player)
                return true
            }
        }
        return false
    }

    mutating func dropPiece(_ player: Player, column1: Int) -> Bool {
        return dropPiece(player, column0: column1 - 1)
    }

    private func checkDirections(player: Player, startR: Int, startC: Int, dr: Int, dc: Int, board: [[Character]]) -> Bool {
        let piece = playMark(player)

        for i in 0..<Self.winCount {
            let rr = startR + i * dr
            let cc = startC + i * dc

            if !onBoard(rr, cc) { return false }
            if board[rr][cc] != piece { return false }
        }
        return true
    }

    private func isWin(player: Player, board: [[Character]]) -> Bool {
        for r in 0..<Self.rows {
            for c in 0..<Self.cols {
                if checkDirections(player: player, startR: r, startC: c, dr: 0, dc: 1, board: board) { return true }
                if checkDirections(player: player, startR: r, startC: c, dr: 1, dc: 0, board: board) { return true }
                if checkDirections(player: player, startR: r, startC: c, dr: 1, dc: 1, board: board) { return true }
                if checkDirections(player: player, startR: r, startC: c, dr: 1, dc: -1, board: board) { return true }
            }
        }
        return false
    }

    private func isDraw(board: [[Character]]) -> Bool {
        for r in 0..<Self.rows {
            for c in 0..<Self.cols {
                if board[r][c] == Self.empty { return false }
            }
        }
        if isWin(player: .one, board: board) { return false }
        if isWin(player: .two, board: board) { return false }
        return true
    }

    private func isColCool(column1: Int, board: [[Character]]) -> Bool {
        guard column1 >= 1 && column1 <= Self.cols else { return false }
        let col0 = column1 - 1
        return board[0][col0] == Self.empty
    }

    private func copyBoard(_ b: [[Character]]) -> [[Character]] { b }

    private func findImWinColumn(player: Player, board: [[Character]]) -> Int {
        for col1 in 1...Self.cols {
            if !isColCool(column1: col1, board: board) { continue }

            var temp = copyBoard(board)
            _ = dropPiece(player, column0: col1 - 1, into: &temp)

            if isWin(player: player, board: temp) { return col1 }
        }
        return -1
    }

    private func dropPiece(_ player: Player, column0: Int, into b: inout [[Character]]) -> Bool {
        guard column0 >= 0 && column0 < Self.cols else { return false }

        for r in stride(from: Self.rows - 1, through: 0, by: -1) {
            if b[r][column0] == Self.empty {
                b[r][column0] = playMark(player)
                return true
            }
        }
        return false
    }

    private func getCpuColumnHard(board: [[Character]]) -> Int {
        let cpu: Player = .two
        let human: Player = .one

        let winCol = findImWinColumn(player: cpu, board: board)
        if winCol != -1 { return winCol }

        let blockCol = findImWinColumn(player: human, board: board)
        if blockCol != -1 { return blockCol }

        let center = Self.cols / 2
        let preferred: [Int] = [
            center,
            center + 1,
            center - 1,
            center + 2,
            center - 2,
            center + 3,
            center - 3,
            center + 4
        ]

        for col1 in preferred {
            if col1 >= 1 && col1 <= Self.cols && isColCool(column1: col1, board: board) {
                return col1
            }
        }

        for col1 in 1...Self.cols {
            if isColCool(column1: col1, board: board) { return col1 }
        }

        return 1
    }

    private func getCpuColumnEasy(board: [[Character]], blockChancePercent: Int = 25) -> Int {
        let human: Player = .one

        let blockCol = findImWinColumn(player: human, board: board)
        if blockCol != -1 {
            let roll = Int.random(in: 0..<100)
            if roll < blockChancePercent { return blockCol }
        }

        for _ in 0..<1000 {
            let col1 = Int.random(in: 1...Self.cols)
            if isColCool(column1: col1, board: board) { return col1 }
        }

        for col1 in 1...Self.cols {
            if isColCool(column1: col1, board: board) { return col1 }
        }

        return 1
    }

    
    mutating func dropHuman(column0: Int) {
        guard result == .playing else { return }

        let p = currentPlayer
        if dropPiece(p, column0: column0) {
            advanceAfterMove(justMoved: p)
        }
    }

    mutating func dropCPU(difficulty: Difficulty) {
        guard result == .playing else { return }
        guard currentPlayer == .two else { return }

        let col1: Int = (difficulty == .hard)
            ? getCpuColumnHard(board: board)
            : getCpuColumnEasy(board: board, blockChancePercent: 25)

        _ = dropPiece(.two, column1: col1)
        advanceAfterMove(justMoved: .two)
    }

    private mutating func advanceAfterMove(justMoved: Player) {
        if isWin(player: justMoved, board: board) {
            result = (justMoved == .one) ? .p1Win : .p2Win
            return
        }
        if isDraw(board: board) {
            result = .draw
            return
        }
        currentPlayer = otherPlayer(justMoved)
    }
}
