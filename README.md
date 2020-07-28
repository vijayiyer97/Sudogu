# Sudogu
An iOS app to generate, and to computationally or naturally solve sudoku puzzles.

## Features

### Current
- Gesture interactable sudoku board
    - Single tap selects cell
    - Double tap toggles cell focused zoom
    - Pinch atenuates zoom
    - Drag scrolls through board (vertically and horizontally)
- Tactile buttons with haptic and audible feedback
- Support for various actions
    - Toggle between write modes

### Planned
- Support for various actions
    - Undo previous edits to the board
    - Generate, solve, and reset sudoku boards
- Support for save states
    - Saves progress and board state when the application resigns control
- Assist mode
    - Notifies users of errors
    - Gives hints for moves
    - Automatically deduces cell candidates from the board state
- Settings modify global app state
    - Difficulty sets internal difficulty for generating sudoku puzzles
    - Assist mode toggles assist mode state
    - Dimension modifiers affect the size of the sudoku board dynamically
- State change observers
    - Notify when sudoku is sucessfully completed
    - Notify when sudoku write mode is changed
