#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=game -t --no-align -c"

SECRET_NUMBER=$((RANDOM % 1000 + 1))
GUESS_COUNT=0
TOTAL_GAMES_PLAYED=0
USER_BEST_GAME=0

echo "Enter your username:"
read USERNAME

USER_EXISTS_RESULT=$($PSQL "SELECT username, games_played, best_game FROM users WHERE username = '$USERNAME';")

if [[ -z $USER_EXISTS_RESULT ]]
then
  # New user
  INSERT_NEW_USER=$($PSQL "INSERT INTO users(username) VALUES('$USERNAME')")
  echo "Welcome, $USERNAME! It looks like this is your first time here."
else
  # Existing user
  IFS='|' read -r USERNAME GAMES_PLAYED BEST_GAME <<< "$USER_EXISTS_RESULT"
  USER_BEST_GAME=$BEST_GAME
  TOTAL_GAMES_PLAYED=$GAMES_PLAYED
  echo "Welcome back, $USERNAME! You have played $GAMES_PLAYED games, and your best game took $BEST_GAME guesses."
fi

GUESS_GAME(){
  if [[ -z $1 ]]
  then
    echo "Guess the secret number between 1 and 1000:"
  else
    echo "$1"
  fi

  read USER_GUESS

  if [[ $USER_GUESS =~ ^[0-9]+$ ]]
  then
    if [[ $USER_GUESS -gt $SECRET_NUMBER ]]
    then
      ((GUESS_COUNT++))
      GUESS_GAME "It's lower than that, guess again:"
    elif [[ $USER_GUESS -lt $SECRET_NUMBER ]]
    then
      ((GUESS_COUNT++))
      GUESS_GAME "It's higher than that, guess again:"
    else
      ((GUESS_COUNT++))
      echo "You guessed it in $GUESS_COUNT tries. The secret number was $SECRET_NUMBER. Nice job!"
    fi
  else
    echo "That is not an integer, guess again:"
    GUESS_GAME
  fi
}

GUESS_GAME
