# Pigeonhole

Contributors:</br>  
Ashwin Char akc95@cornell.edu</br>
Arjun Mehta ahm247@cornell.edu</br>
Abhinav Goyal ag894@cornell.edu</br>

## Overview
Pigeonhole is a graphics based game similar to the children's game Battleship. The game was implemented using OCaml and a graphics library called raylib. In the game 2 players compete against one another by initially placing 10 holes each on a grid board. The players also have the option to randomize the placement of their holes. After each player has placed their holes, each player will alternate shooting birds at each other's grid, trying to uncover the squares with a hole underneath. If a hole is uncovered, then the player who shot the bird gains how the number of points the bird is worth. Each bird has a different point value, and there is a limited number of each bird. The game ends once a player has discovered all 10 holes on their opponent's grid. Whoever has more points when the game ends is declared the winner.

## Detailed Instructions
<img src="https://user-images.githubusercontent.com/35634836/210024143-df05b74a-daca-45e6-995b-66b156a0cbe3.png" width="500" height="500"></img>

## Gameplay
![3d6618c618c81b1d21a83d8d2bafb100e291ec63](https://user-images.githubusercontent.com/35634836/210026300-b224fb92-e2fe-4ebc-ba80-19362a295818.gif)

## How To Play
1. Download or clone the files from this repository
2. Navigate to the directory where the files are located
3. Opam install the required libraries specified in installs.txt
4. Launch the game: 
```
$ make play
```
5. Enjoy Pigeonhole!!!
