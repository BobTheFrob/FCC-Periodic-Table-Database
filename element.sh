#!/bin/bash
# The element with atomic number 1 is Hydrogen (H). 
# It's a nonmetal, with a mass of 1.008 amu. 
# Hydrogen has a melting point of -259.1 celsius and a boiling point of -252.9 celsius.
PSQL="psql -X --username=freecodecamp --dbname=periodic_table -t --no-align -c"
if [[ -z $1 ]]
 then
  echo Please provide an element as an argument.
  else
    if [[ $1 =~ ^[0-9]+$ ]]
      then
        ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE atomic_number=$1")
        if [[ -n $ATOMIC_NUMBER ]]
          then
            SYMBOL=$($PSQL "SELECT symbol FROM elements WHERE atomic_number=$ATOMIC_NUMBER")
            NAME=$($PSQL "SELECT name FROM elements WHERE atomic_number=$ATOMIC_NUMBER")
        fi
      elif [[ $1 =~ ^[A-Z][a-z]{1}?$ ]]
        then
          SYMBOL=$($PSQL "SELECT symbol FROM elements WHERE symbol='$1'")
          ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE symbol='$SYMBOL'")
          NAME=$($PSQL "SELECT name FROM elements WHERE symbol='$SYMBOL'")
      elif [[ $1 =~ ^[A-Z][a-z]+$ ]]
        then
          NAME=$($PSQL "SELECT name FROM elements WHERE name='$1'")
          ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE name='$NAME'")
          SYMBOL=$($PSQL "SELECT symbol FROM elements WHERE name='$NAME'")
    fi
    if [[ -z $ATOMIC_NUMBER || -z $SYMBOL || -z $NAME ]]
      then
        echo I could not find that element in the database.
      else
        TYPE_ID=$($PSQL "SELECT type_id FROM properties WHERE atomic_number=$ATOMIC_NUMBER")
        TYPE=$($PSQL "SELECT type FROM types WHERE type_id=$TYPE_ID")
        ATOMIC_MASS=$($PSQL "SELECT atomic_mass FROM properties WHERE atomic_number=$ATOMIC_NUMBER")
        MELTING_POINT_CELSIUS=$($PSQL "SELECT melting_point_celsius FROM properties WHERE atomic_number=$ATOMIC_NUMBER")
        BOILING_POINT_CELSIUS=$($PSQL "SELECT boiling_point_celsius FROM properties WHERE atomic_number=$ATOMIC_NUMBER")
        echo -e "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT_CELSIUS celsius and a boiling point of $BOILING_POINT_CELSIUS celsius." 
    fi
fi