#! /bin/bash

PSQL="psql -X --username=freecodecamp --dbname=salon --tuples-only -c"

echo -e "\n~~~~~ Salon ~~~~~\n"

MAIN_MENU() {
  
  
  echo -e "\n1) cut\n2) wash\n3) color\n4) dry"
  read SERVICE_ID_SELECTED

  case $SERVICE_ID_SELECTED in
    1 | 2 | 3 | 4) APPOINTMENT_MENU $SERVICE_ID_SELECTED ;;
    
    *) MAIN_MENU "Please enter a valid option." ;;
  esac
  
}


EXIT() {
  echo -e "\nThank you for stopping in.\n"
}

APPOINTMENT_MENU(){

SERVICE_ID_SELECTED=$1

echo -e "\nWhat's your phone number?"
read CUSTOMER_PHONE


if [[ -z $($PSQL "SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE'") ]]
then
  ADD_CUSTOMER_MENU $CUSTOMER_PHONE
fi

CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE'")

echo -e "\nWhat time would you like to make an appointment?"
read SERVICE_TIME

ADD_APPOINTMNET_RESULT=$($PSQL "INSERT INTO appointments(customer_id,service_id,time) VALUES($CUSTOMER_ID,$SERVICE_ID_SELECTED,'$SERVICE_TIME')")

BOOKED=$($PSQL "SELECT customers.name, services.name FROM customers JOIN appointments USING(customer_id) JOIN services USING(service_id) 
          WHERE appointments.customer_id=$CUSTOMER_ID AND appointments.service_id=$SERVICE_ID_SELECTED AND appointments.time='$SERVICE_TIME'")

echo "$BOOKED" | while read NAME_BOOKED BAR SERVICE_BOOKED
do
echo "I have put you down for a $SERVICE_BOOKED at $SERVICE_TIME, $NAME_BOOKED."
done

}


ADD_CUSTOMER_MENU(){

echo -e "\nWhat's your name?"
read CUSTOMER_NAME

# insert new customer
INSERT_CUSTOMER_RESULT=$($PSQL "INSERT INTO customers(name, phone) VALUES('$CUSTOMER_NAME', '$1')") 

}

MAIN_MENU
