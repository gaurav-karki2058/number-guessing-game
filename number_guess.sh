#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=game-t --no-align -c"

RANDOM_VALUE= echo $((RANDOM % 1000 + 1 ))
GUESS_COUNT=0

echo "Enter your username:"
read USERNAME

USER_EXISTS_RESULT=$($PSQL"select username,games_played,best_game from users where username = '$USERNAME';")

if [[ -z $USER_EXISTS_RESULT ]]
then
  INSERT_NEW_USER=$($PSQL"insert into users(username) values('$USERNAME')")
  echo "Welcome, $USERNAME! It looks like this is your first time here."
else
  IFS='|' read -r USERNAME GAMES_PLAYED BEST_GAME <<< $USER_EXISTS_RESULT
  echo  "Welcome back, $USERNAME! You have played $GAMES_PLAYED games, and your best game took $BEST_GAME guesses."
fi