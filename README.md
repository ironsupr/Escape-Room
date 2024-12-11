# Escape Room Game in MATLAB

## Project Overview
The **Escape Room Game** is an interactive, GUI-based game implemented in MATLAB. Players navigate through a series of virtual rooms, solve puzzles, and uncover secret codes to progress and win the game. Each room presents unique challenges, requiring logical thinking and problem-solving skills.

## Features
- **Graphical User Interface (GUI):** User-friendly interface with interactive elements.
- **Countdown Timer:** Players have a total of 30 minutes to solve all puzzles.
- **Penalty System:** Incorrect answers result in additional penalty time.
- **Room Progress Tracking:** Status indicators show solved/unsolved rooms.
- **Dynamic Content:** Different images and secret codes for each room.

## How to Play
1. Launch the game by running the `EscapeRoom` function in MATLAB.
2. Click the "Start" button to begin the game.
3. Select a room from the dropdown menu.
4. Observe the question or image displayed and enter the secret code for the room.
5. Submit your answer using the "Submit" button.
6. Solve all rooms before the timer runs out to win the game.

## Game Rules
- Each room has a unique secret code that must be entered to mark the room as solved.
- Incorrect answers add penalty time to your overall countdown.
- The game ends when all rooms are solved or the timer reaches zero.

## File Structure
- **`EscapeRoom.m`**: The main script that initializes the game and handles all logic and GUI components.
- **Image Files**: Images for room challenges (ensure they are placed in an `Images` folder).
  - Room 1: `Images/1.png`
  - Room 2: `Images/2.png`
  - Room 3: `Images/3.png`
  - ... (and so on)
- **Home.png**: Introductory image displayed at the start of the game.

## Requirements
- MATLAB R2021a or newer.
- Image Processing Toolbox (optional but recommended for enhanced graphics).

## Installation
1. Clone this repository or download the `EscapeRoom.m` file.
2. Ensure all image files are stored in a directory named `Images` within the project folder.
3. Place `Home.png` in the project root directory.

## Running the Game
1. Open MATLAB and navigate to the project directory.
2. Run the command:
   ```matlab
   EscapeRoom
   ```

## Contributing
Contributions are welcome! Feel free to fork this repository, make enhancements, and submit a pull request. Suggestions for new puzzles or improved functionality are appreciated.

## License
This project is licensed under the MIT License. See the LICENSE file for more details.

## Acknowledgments
- MATLAB for providing a robust platform for GUI development.
- Contributors and players who help refine the game with their feedback.

---
Enjoy solving the puzzles and escaping the rooms!

