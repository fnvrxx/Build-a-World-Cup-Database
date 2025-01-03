#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
echo $($PSQL "TRUNCATE TABLE games, teams")
# read  game.csv file using cat and while loop to read row by row
cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  # INSERT TEAMS TABLE DATA
  if [[ $WINNER != "winner" ]]
  then
    #get team
    TEAM_NAME=$($PSQL "SELECT name FROM teams WHERE name='$WINNER'")
    #if team name is not found,include the new team to the table
    if [[ -z $TEAM_NAME ]]
    then
      #inder new team
      INSERT_TEAM_NAME=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")
      # if team was inserted
      if [[ $INSERT_TEAM_NAME == "INSERT 0 1" ]]
      then
        echo Inserted team $WINNER
      fi
    fi
  fi

  #GET OPPONENET TEAM NAME
  #exclude column names row
  if [[ $OPPONENT != "opponent" ]]
  then
    # get team name
    TEAM_OPP=$($PSQL "SELECT name FROM teams WHERE name='$OPPONENT'")
    #if team name is not found we need to include the new team 
    if [[ -z $TEAM_OPP ]]
    then
      INSERT_TEAM_OOP=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")
      # if it works to insert
      if [[ $INSERT_TEAM_OOP == "INSERT 0 1" ]]
      then
        echo Inserted team Opponent $OPPONENT
      fi
    fi
  fi
#INSERT GAMES TABLE DATA

  if [[ YEAR != "year" ]]
  then
    #get winner_id
    WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
    #get opponent_id
    OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
    #insert new games row
    INSERT_GAME=$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES ($YEAR, '$ROUND', $WINNER_ID, $OPPONENT_ID, $WINNER_GOALS, $OPPONENT_GOALS)") 
      if [[ $INSERT_GAME == "INSER 0 1" ]]
      then
        echo New game added: $YEAR, $ROUND, $WINNER_ID VS $OPPONENT_ID, score $WINNER_GOALS : $OPPONENT_GOALS
      fi
  fi
done
