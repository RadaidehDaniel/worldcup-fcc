#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

echo $($PSQL "TRUNCATE TABLE teams, games")

# Loop over the csv file
cat games.csv | 
while IFS=',' read YEAR ROUND WINNER OPPONENT WGOALS OGOALS;
do
  # Do not loop over the titles of the csv file
  if [[ $YEAR != "year" ]]
  then
    # insert the winners and the opponents to the teams table
    SELECT_W_TEAM_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
    if [[ -z $SELECT_W_TEAM_ID ]]
    then
      echo $($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")
      SELECT_W_TEAM_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
    fi

    SELECT_O_TEAM_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
    if [[ -z $SELECT_O_TEAM_ID ]]
    then
      echo $($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")
      SELECT_O_TEAM_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
    fi
    # insert the game data to games table
    echo $($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES($YEAR, '$ROUND', $SELECT_W_TEAM_ID, $SELECT_O_TEAM_ID,$WGOALS, $OGOALS)")
  fi
done
