# Pigeonhole

Contributors:</br>  
Ashwin Char akc95@cornell.edu</br>
Arjun Mehta ahm247@cornell.edu</br>
Abhinav Goyal ag894@cornell.edu</br>

## Overview
Pigeonhole is a graphics based game similar to the children's game Battleship. The game was implemented using OCaml and a graphics library called raylib. In the game 2 players compete against one another by initially placing 10 holes each on a grid board. The players also have the option to randomize the placment of thier holes. After each player has placed their holes, each player will alternate shooting birds at each other's grid, trying to uncover the squares with a hole underneath. If a hole is uncovered, then the player who shot the bird gains how the number of points the bird is worth. Each bird has a different point value, and there is a limited number of each bird. The game ends once a player has discovered all 10 holes on thier opponent's grid. Whoever has more points when the game ends is declared the winner.

## Detailed Instructions
<img src = "https://user-images.githubusercontent.com/35634836/210024143-df05b74a-daca-45e6-995b-66b156a0cbe3.png" width="500" height="500"> </img>

## Gameplay
![Pigeonhole__Ubuntu__2022-12-29_19-28-05_AdobeExpress](https://user-images.githubusercontent.com/35634836/210024102-f5767a9d-e9ec-4214-bc76-4b7301b5d2a0.gif)

## How To Play
1. Download or clone the files from this repository
2. Navigate to the directory where the files are located
3. Opam install the required libraries specified in installs.txt
4. Launch the game: 
```
$ make play
```
5. Enjoy Pigeonhole!!!
