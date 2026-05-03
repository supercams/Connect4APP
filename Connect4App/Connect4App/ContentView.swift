import SwiftUI

enum GameMode: Int {
    case pvp = 1
    case cpu = 2
}

struct ModeButtonStyle: ButtonStyle {
    let isSelected: Bool

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.headline)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 12)
            .background(isSelected ? Color.accentColor : Color(.secondarySystemBackground))
            .foregroundColor(isSelected ? .white : .primary)
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color(.systemGray3), lineWidth: isSelected ? 0 : 1)
            )
            .opacity(configuration.isPressed ? 0.85 : 1.0)
            .animation(.easeInOut(duration: 0.15), value: isSelected)
    }
}

struct Connect4Background: View {
    var body: some View {
        GeometryReader { geo in
            let w = geo.size.width
            let h = geo.size.height

            ZStack {
                LinearGradient(
                    colors: [
                        Color(red: 0.94, green: 0.97, blue: 1.00),
                        Color(red: 0.97, green: 0.95, blue: 1.00)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()

                RoundedRectangle(cornerRadius: 28)
                    .fill(Color(red: 0.10, green: 0.36, blue: 0.86).opacity(0.10))
                    .frame(width: min(w * 0.92, 520), height: min(h * 0.62, 520))
                    .overlay(
                        RoundedRectangle(cornerRadius: 28)
                            .stroke(Color(red: 0.10, green: 0.36, blue: 0.86).opacity(0.18), lineWidth: 2)
                    )
                    .blur(radius: 0.5)
                    .offset(y: 30)

                Circle()
                    .fill(Color.red.opacity(0.12))
                    .frame(width: 180, height: 180)
                    .offset(x: -w * 0.30, y: -h * 0.22)

                Circle()
                    .fill(Color.yellow.opacity(0.14))
                    .frame(width: 220, height: 220)
                    .offset(x: w * 0.32, y: -h * 0.10)

                Circle()
                    .fill(Color.red.opacity(0.10))
                    .frame(width: 140, height: 140)
                    .offset(x: w * 0.28, y: h * 0.28)

                Circle()
                    .fill(Color.yellow.opacity(0.12))
                    .frame(width: 160, height: 160)
                    .offset(x: -w * 0.34, y: h * 0.30)

                ForEach(0..<14, id: \.self) { i in
                    Circle()
                        .fill((i % 2 == 0 ? Color.red : Color.yellow).opacity(0.18))
                        .frame(width: 10, height: 10)
                        .offset(
                            x: (CGFloat(i) - 7) * 34,
                            y: (i % 3 == 0 ? -h * 0.34 : -h * 0.30)
                        )
                }
            }
        }
    }
}

struct AttractModeOverlay: View {
    @State private var phase = false
    @State private var scan = false

    private func xPos(_ i: Int, width: CGFloat) -> CGFloat {
        let span = max(width - 60, 1)
        let raw = CGFloat((i * 97 + 23) % Int(span))
        return raw - span / 2
    }

    private func duration(_ i: Int) -> Double {
        6.0 + Double(i % 5) * 1.3
    }

    private func delay(_ i: Int) -> Double {
        Double(i % 6) * 0.55
    }

    var body: some View {
        GeometryReader { geo in
            let w = geo.size.width
            let h = geo.size.height

            ZStack {
                LinearGradient(
                    colors: [
                        Color.cyan.opacity(0.10),
                        Color.clear,
                        Color.pink.opacity(0.10)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .opacity(phase ? 1.0 : 0.55)
                .animation(.easeInOut(duration: 2.2).repeatForever(autoreverses: true), value: phase)

                ForEach(0..<14, id: \.self) { i in
                    Circle()
                        .fill((i % 2 == 0 ? Color.red : Color.yellow).opacity(0.22))
                        .frame(width: 44, height: 44)
                        .overlay(
                            Circle().stroke(Color.white.opacity(0.18), lineWidth: 2)
                        )
                        .offset(
                            x: xPos(i, width: w),
                            y: (phase ? (h * 0.70) : (-h * 0.70))
                        )
                        .rotationEffect(.degrees(phase ? Double(i) * 3.0 : -Double(i) * 3.0))
                        .animation(
                            .linear(duration: duration(i))
                                .repeatForever(autoreverses: false)
                                .delay(delay(i)),
                            value: phase
                        )
                }

                VStack(spacing: 5) {
                    ForEach(0..<120, id: \.self) { _ in
                        Rectangle()
                            .fill(Color.white.opacity(0.035))
                            .frame(height: 1)
                    }
                }
                .offset(y: scan ? 16 : -16)
                .animation(.linear(duration: 1.2).repeatForever(autoreverses: true), value: scan)
            }
            .blendMode(.screen)
            .onAppear {
                phase = true
                scan = true
            }
        }
        .ignoresSafeArea()
        .allowsHitTesting(false)
    }
}

struct AdBannerView: View {
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 14)
                .fill(.ultraThinMaterial)
                .overlay(
                    RoundedRectangle(cornerRadius: 14)
                        .stroke(Color(.systemGray3).opacity(0.6), lineWidth: 1)
                )

            HStack(spacing: 10) {
                Image(systemName: "megaphone.fill")
                    .font(.system(size: 16, weight: .semibold))
                    .opacity(0.8)

                VStack(alignment: .leading, spacing: 2) {
                    Text("Advertisement")
                        .font(.footnote).bold()
                    Text("Your ad banner goes here")
                        .font(.caption)
                        .opacity(0.85)
                }

                Spacer()

                Text("Learn more")
                    .font(.caption).bold()
                    .padding(.horizontal, 10)
                    .padding(.vertical, 6)
                    .background(Color.accentColor.opacity(0.20))
                    .cornerRadius(10)
            }
            .padding(.horizontal, 14)
        }
        .frame(height: 64)
        .padding(.horizontal, 16)
        .padding(.bottom, 8)
        .allowsHitTesting(false) // placeholder only; remove when using a real ad view
    }
}

struct ContentView: View {

    private let gameplayWallpapers: [String] = [
        "gameplayWallpaper",
        "gameplayWallpaper2",
        "gameplayWallpaper3"
    ]

    @State private var currentGameplayWallpaper: String = "gameplayWallpaper"
    
    @State private var mode: GameMode? = nil
    @State private var difficulty: Difficulty = .hard

    @State private var p1Wins = 0
    @State private var p2Wins = 0
    @State private var draws  = 0

    @State private var engine: Connect4Engine = Connect4Engine()

    @State private var inGame = false

    @State private var animMove: (row: Int, col: Int, player: Player)? = nil
    @State private var animY: CGFloat = 0
    private let cellSize: CGFloat = 34
    private let cellSpacing: CGFloat = 6

    var body: some View {
        ZStack {
            Connect4Background()

            NavigationStack {
                VStack(spacing: 16) {

                    if !inGame {
                        menuView
                    } else {
                        gameView
                    }

                    Spacer(minLength: 0)
                }
                .padding()
                .safeAreaInset(edge: .bottom) {
                    AdMobBannerView()
                        .frame(height: 50)   // standard banner height
                }
            }
        }
    }

    private var menuView: some View {
        ZStack {
            Image("mainmenuWallpaper")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
            AttractModeOverlay()
                .opacity(0.55)
            
            Color.black.opacity(0.25)
                .ignoresSafeArea()

            GeometryReader { geo in
                VStack(spacing: 14) {
                    Text("Choose game mode:")
                        .font(.headline)
                        .foregroundColor(.white)

                    HStack(spacing: 12) {
                        Button("Player vs Player") { mode = .pvp }
                            .buttonStyle(ModeButtonStyle(isSelected: mode == .pvp))

                        Button("Player vs CPU") { mode = .cpu }
                            .buttonStyle(ModeButtonStyle(isSelected: mode == .cpu))
                    }

                    if mode == .cpu {
                        Picker("Difficulty", selection: $difficulty) {
                            Text("Easy").tag(Difficulty.easy)
                            Text("Hard").tag(Difficulty.hard)
                        }
                        .pickerStyle(.segmented)
                    }

                    Button("Start Game") {
                        currentGameplayWallpaper = gameplayWallpapers.randomElement() ?? "gameplayWallpaper"
                        engine.reset()
                        animMove = nil
                        inGame = true
                    }
                    .buttonStyle(BorderedProminentButtonStyle())
                    .disabled(mode == nil)

                    scoreboardView
                }
                .padding()
                .background(.ultraThinMaterial)
                .cornerRadius(18)
                .frame(width: min(geo.size.width - 32, 420))
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                .padding()
            }
        }
    }

    private var gameView: some View {
        GeometryReader { geo in
            ZStack(alignment: .top) {
                Image(currentGameplayWallpaper)
                    .resizable()
                    .scaledToFill()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .clipped()
                    .ignoresSafeArea()

                Color.black.opacity(0.18)
                    .ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 12) {
                        scoreboardView
                        Text(statusText).font(.headline)

                        boardGrid

                        HStack(spacing: 12) {
                            Button("New Game") {
                                currentGameplayWallpaper = gameplayWallpapers.randomElement() ?? "gameplayWallpaper"
                                engine.reset()
                                animMove = nil
                            }
                                .buttonStyle(BorderedProminentButtonStyle())

                            Button("Quit to Menu") {
                                inGame = false
                                animMove = nil
                            }
                                .buttonStyle(BorderedButtonStyle())
                        }
                        .padding(.top, 6)
                    }
                    .padding(.bottom, 20)
                    .padding()
                    .background(.ultraThinMaterial)
                    .cornerRadius(18)
                    .padding(.top, geo.safeAreaInsets.top + 12)
                    .padding(.horizontal)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            }
        }
    }

    private var scoreboardView: some View {
        VStack(spacing: 4) {
            Text("SCOREBOARD")
                .font(.subheadline).bold()
            Text("Player 1 wins: \(p1Wins)   Player 2 wins: \(p2Wins)   Draws: \(draws)")
                .font(.footnote)
        }
        .padding(.vertical, 6)
    }

    private var boardGrid: some View {
        let rows = Connect4Engine.rows
        let cols = Connect4Engine.cols
        let boardW = CGFloat(cols) * cellSize + CGFloat(cols - 1) * cellSpacing
        let boardH = CGFloat(rows) * cellSize + CGFloat(rows - 1) * cellSpacing

        let board = engine.board

        return ZStack(alignment: .topLeading) {
            VStack(spacing: cellSpacing) {
                ForEach(0..<rows, id: \.self) { r in
                    HStack(spacing: cellSpacing) {
                        ForEach(0..<cols, id: \.self) { c in
                            let isAnimatingLandingCell = (animMove?.row == r && animMove?.col == c)
                            let ch = isAnimatingLandingCell ? Connect4Engine.empty : board[r][c]

                            cellView(ch)
                                .contentShape(Rectangle())
                                .onTapGesture {
                                    guard engine.result == .playing else { return }
                                    if mode == .cpu && engine.currentPlayer == .two { return }
                                    handleHumanTap(column0: c)
                                }
                        }
                    }
                }
            }

            if let m = animMove {
                Circle()
                    .fill(m.player == .one ? Color.red : Color.yellow)
                    .frame(width: cellSize, height: cellSize)
                    .overlay(Circle().stroke(Color(.systemGray3), lineWidth: 1))
                    .position(
                        x: CGFloat(m.col) * (cellSize + cellSpacing) + cellSize / 2,
                        y: animY + cellSize / 2
                    )
                    .allowsHitTesting(false)
            }
        }
        .frame(width: boardW, height: boardH, alignment: .topLeading)
        .padding(.top, 6)
    }

    private func cellView(_ ch: Character) -> some View {
        let color: Color
        if ch == Connect4Engine.p1Piece { color = .red }
        else if ch == Connect4Engine.p2Piece { color = .yellow }
        else { color = Color(.systemGray5) }

        return Circle()
            .fill(color)
            .frame(width: cellSize, height: cellSize)
            .overlay(Circle().stroke(Color(.systemGray3), lineWidth: 1))
    }

    private var statusText: String {
        switch engine.result {
        case .playing:
            let p = (engine.currentPlayer == .one) ? "Player 1" : "Player 2"
            return "Turn: \(p)"
        case .p1Win:
            return "Player 1 has won!"
        case .p2Win:
            return "Player 2 has won!"
        case .draw:
            return "Game ended by draw"
        }
    }

    private func handleHumanTap(column0: Int) {
        guard engine.result == .playing else { return }

        if mode == .pvp {
            guard let landingRow = landingRowForColumn(column0) else { return }
            let p = engine.currentPlayer

            engine.dropHuman(column0: column0)
            startDropAnimation(row: landingRow, col: column0, player: p)
            finalizeIfEnded()
            return
        }

        if mode == .cpu {
            guard engine.currentPlayer == .one else { return }
            guard let landingRow = landingRowForColumn(column0) else { return }

            engine.dropHuman(column0: column0)
            startDropAnimation(row: landingRow, col: column0, player: .one)
            finalizeIfEnded()

            if engine.result == .playing && engine.currentPlayer == .two {
                let before = engine.board
                engine.dropCPU(difficulty: difficulty)
                if let cpuMove = diffMove(before: before, after: engine.board) {
                    startDropAnimation(row: cpuMove.row, col: cpuMove.col, player: .two)
                }
                finalizeIfEnded()
            }
        }
    }

    private func landingRowForColumn(_ column0: Int) -> Int? {
        guard column0 >= 0 && column0 < Connect4Engine.cols else { return nil }
        for r in stride(from: Connect4Engine.rows - 1, through: 0, by: -1) {
            if engine.board[r][column0] == Connect4Engine.empty {
                return r
            }
        }
        return nil
    }

    private func diffMove(before: [[Character]], after: [[Character]]) -> (row: Int, col: Int)? {
        for r in 0..<Connect4Engine.rows {
            for c in 0..<Connect4Engine.cols {
                if before[r][c] != after[r][c] {
                    return (row: r, col: c)
                }
            }
        }
        return nil
    }

    private func startDropAnimation(row: Int, col: Int, player: Player) {
        animMove = (row: row, col: col, player: player)

        animY = -cellSize
        let targetY = CGFloat(row) * (cellSize + cellSpacing)

        withAnimation(.easeIn(duration: 0.28)) {
            animY = targetY
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.30) {
            if let m = animMove, m.row == row, m.col == col {
                animMove = nil
            }
        }
    }

    private func finalizeIfEnded() {
        switch engine.result {
        case .p1Win:
            p1Wins += 1
        case .p2Win:
            p2Wins += 1
        case .draw:
            draws += 1
        case .playing:
            break
        }
    }
}
