#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=game-t --no-align -c"

RANDOM_VALUE= echo $((RANDOM % 1000 + 1 ))
GUESS_COUNT=0

echo "Enter your username:"
read USERNAME

