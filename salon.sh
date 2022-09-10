#!/bin/bash

PSQL="psql -X --username=freecodecamp --dbname=salon --tuples-only -c"

  echo -e "\n~~~~~~ My Salon ~~~~~~\n"
  echo -e "Welcome to My Salon, how can I help you?\n"

MAIN_MENU() {
  
  #$($PSQL "TRUNCATE TABLE customers, appointments")

  echo -e "1) Hairstyle\n2) Color\n3) Mens cut\n4) Womens cut\n5) Perm\n6) Trim"
  read SERVICE_ID_SELECTED

  if [[ ! $SERVICE_ID_SELECTED =~ ^[1-6]$ ]]
  then
    echo -e "\nI could not find that service. What would you like today?"
    MAIN_MENU 
  else
    #rename variable
    SERVICE_NAME_CONFIRMED=$($PSQL "SELECT name FROM services WHERE service_id = $SERVICE_ID_SELECTED;")
    echo $SERVICE_NAME_CONFIRMED
    echo -e "\nWhat's your phone number?"
    read CUSTOMER_PHONE

    CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone = '$CUSTOMER_PHONE';")
    
    if [[ -z $CUSTOMER_NAME ]]
    then
      echo -e "\nI don't have a record for that phone number, what's your name?"
      read CUSTOMER_NAME
      NEW_CUSTOMER_INSERT=$($PSQL "INSERT INTO customers(name, phone) VALUES('$CUSTOMER_NAME', '$CUSTOMER_PHONE');")
      GET_APPOINTMENT
    else
      GET_APPOINTMENT
    fi
  fi
}

GET_APPOINTMENT() {
  echo "What time would you like your color, $CUSTOMER_NAME?"
  read SERVICE_TIME

  SERVICE_TIME_RESULT=$($PSQL "INSERT INTO appointments(time) VALUES('$SERVICE_TIME');")
  echo "I have put you down for a$SERVICE_NAME_CONFIRMED at $SERVICE_TIME, $CUSTOMER_NAME."
}

MAIN_MENU
