Connect 4 App (iOS - SwiftUI)

A fully interactive Connect 4 game built for iOS using SwiftUI, featuring both player-vs-player and player-vs-CPU gameplay with adjustable difficulty.

Features
- Player vs Player mode
- Player vs CPU mode
- Two difficulty levels:
  - Easy (random with occasional blocking)
  - Hard (strategic AI with win/block logic)
- 8x8 game board
- Win detection (horizontal, vertical, diagonal)
- Draw detection
- Interactive UI with tap-to-drop gameplay
- Dynamic game state updates

Core Concepts
- SwiftUI state management (`@State`)
- Game engine abstraction (`Connect4Engine`)
- Struct-based logic design
- Enums for game state, players, and difficulty
- 2D arrays for board representation
- Algorithmic win detection
- Basic AI decision-making

Architecture
- Connect4Engine.swift
  - Handles all game logic
  - Board state, win detection, CPU logic

- ContentView.swift
  - UI layer
  - Handles user interaction and rendering

How to Run
1. Open the project in Xcode
2. Select an iPhone simulator
3. Build and run
4. Choose game mode and play

CPU Behavior
- Easy Mode
  - Mostly random moves
  - Occasionally blocks player wins

- Hard Mode
  - Prioritizes winning moves
  - Blocks opponent winning moves
  - Prefers center columns for stronger positioning

What I Learned
- Building interactive apps with SwiftUI
- Separating logic from UI (engine vs view)
- Designing simple AI behavior
- Managing game state cleanly
- Debugging SwiftUI binding and state issues

Future Improvements
- Animations for piece drops
- Improved AI (minimax algorithm)
- Sound effects and haptics
- Score tracking system
- Online multiplayer

Author
Cameron Ybarra
