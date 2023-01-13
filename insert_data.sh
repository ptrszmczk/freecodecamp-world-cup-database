#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
echo $($PSQL "TRUNCATE teams RESTART IDENTITY CASCADE")

cat games.csv | while IFS="," read -r YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  if [[ $YEAR != "year" ]]
  then
    TEAM_WINNER_ID=$($PSQL "select team_id from teams where name='$WINNER'")
    TEAM_OPPONENT_ID=$($PSQL "select team_id from teams where name='$OPPONENT'")

    if [[ -z $TEAM_WINNER_ID ]]
    then
      INSERT_TEAM_RESULT_WINNER=$($PSQL "insert into teams(name) values('$WINNER')")
    fi

    if [[ -z $TEAM_OPPONENT_ID ]]
    then
      INSERT_TEAM_RESULT_OPPONENT=$($PSQL "insert into teams(name) values('$OPPONENT')")
    fi

    GET_WINNER_ID=$($PSQL "select team_id from teams where name='$WINNER'")
    GET_OPPONENT_ID=$($PSQL "select team_id from teams where name='$OPPONENT'")

    INSERT_GAME_RESULT=$($PSQL "insert into games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) values($YEAR, '$ROUND', $GET_WINNER_ID, $GET_OPPONENT_ID, $WINNER_GOALS, $OPPONENT_GOALS)")
  fi
done