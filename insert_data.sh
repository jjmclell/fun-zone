#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do

  if [[ $YEAR != 'year' ]]
  then
   UNIQUE_TEST1="$($PSQL "SELECT COUNT(name) FROM teams WHERE name = '$WINNER';")" #counts occurences of winning team name in teams table
   UNIQUE_TEST2="$($PSQL "SELECT COUNT(name) FROM teams WHERE name = '$OPPONENT';")" #counts occurences of losing team name in teams table

   if [[ $UNIQUE_TEST1 == 0 ]] #if winning team name is not in teams table...
   then
     echo "$($PSQL "INSERT INTO teams (name) VALUES ('$WINNER');")" #put it in
   fi

   if [[ $UNIQUE_TEST2 == 0 ]] #if losing team name is not in teams table...
   then
     echo "$($PSQL "INSERT INTO teams (name) VALUES ('$OPPONENT');")" #put it in
   fi

   WINNER_ID="$($PSQL "SELECT team_id FROM teams WHERE name = '$WINNER';")" #look up team_id for winner
   OPPONENT_ID="$($PSQL "SELECT team_id FROM teams WHERE name = '$OPPONENT';")" #look up team_id for loser
   echo "$($PSQL "INSERT INTO games (year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES ($YEAR, '$ROUND', $WINNER_ID, $OPPONENT_ID, $WINNER_GOALS, $OPPONENT_GOALS);")"
  fi
done