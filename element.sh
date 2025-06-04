#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=periodic_table --tuples-only --no-align -c"

# Verifica se o argumento foi fornecido
if [[ -z $1 ]]
then
  echo "Please provide an element as an argument."
  exit
fi

# Verifica se o argumento é um número (atomic_number) / verificação de argumento numérico
if [[ $1 =~ ^[0-9]+$ ]]
then
  ELEMENT_INFO=$($PSQL "SELECT atomic_number, name, symbol, type, atomic_mass, melting_point_celsius, boiling_point_celsius FROM elements INNER JOIN properties USING(atomic_number) INNER JOIN types USING(type_id) WHERE atomic_number = $1")
# Se não for número, verifica se é símbolo ou nome
else
  ELEMENT_INFO=$($PSQL "SELECT atomic_number, name, symbol, type, atomic_mass, melting_point_celsius, boiling_point_celsius FROM elements INNER JOIN properties USING(atomic_number) INNER JOIN types USING(type_id) WHERE symbol = INITCAP('$1') OR name = INITCAP('$1')")
fi

# Verifica se encontrou algum resultado
if [[ -z $ELEMENT_INFO ]]
then
  echo "I could not find that element in the database."
# Lê os valores do resultado
else
# IFS significa Internal Field Separator.
  IFS="|" read -r ATOMIC_NUMBER NAME SYMBOL TYPE MASS MELTING BOILING <<< "$ELEMENT_INFO"
# Frase
  echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELTING celsius and a boiling point of $BOILING celsius."
fi
