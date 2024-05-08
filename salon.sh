#! /bin/bash

########## Intro ##########

echo " __ __   ____  ____  ____       ____    ____  _____ __ __ ";
echo "|  |  | /    ||    ||    \     |    \  /    |/ ___/|  |  |";
echo "|  |  ||  o  | |  | |  D  )    |  o  )|  o  (   \_ |  |  |";
echo "|  _  ||     | |  | |    /     |     ||     |\__  ||  _  |";
echo "|  |  ||  _  | |  | |    \     |  O  ||  _  |/  \ ||  |  |";
echo "|  |  ||  |  | |  | |  .  \    |     ||  |  |\    ||  |  |";
echo "|__|__||__|__||____||__|\_|    |_____||__|__| \___||__|__|";
echo "                                                          ";

echo -e "Welcome to Hair Bash, how can I help you?\n"

########## Setup ##########

# Define PostgreSQL connection settings:
PSQL="psql -X --username=freecodecamp --dbname=salon --tuples-only --no-align -c"



########## Functions ##########
EXIT_SCRIPT() {
  echo "Exiting Hair Bash. Goodbye!"
  exit 0
}

GET_SERVICE() {
  # Prompt user to select a service
  read SERVICE_ID_SELECTED

  # Validate input
  if [[ ! "$SERVICE_ID_SELECTED" =~ ^[0-9]+$ ]]; then
    echo -e "\nI could not find that service. What would you like today?\n"
    DISPLAY_SERVICES
  fi

  # Check if the user selected the "Exit" option
  if [[ "$SERVICE_ID_SELECTED" == "4" ]]; then
    EXIT_SCRIPT
  fi
  
  # Check if selected service exists
  SELECTED_SERVICE=$($PSQL "SELECT service_id FROM services WHERE service_id = $SERVICE_ID_SELECTED")

  # If service doesn't exist
  if [[ -z $SELECTED_SERVICE ]]; then
    echo -e "\nI could not find that service. What would you like today?\n"
    DISPLAY_SERVICES
  fi
}

DISPLAY_SERVICES() {
  # Fetch services from the database
  SERVICES=$($PSQL "SELECT service_id, name FROM services;")

  # Display services
  echo "$SERVICES" | while IFS='|' read SERVICE_ID NAME
  do
    echo -e "$SERVICE_ID) $NAME"
  done
  # Print the "Exit" option
  echo "4) Exit"

  GET_SERVICE
}

GET_OR_CREATE_CUSTOMER() {
  # get customer by phone number or create new customer
echo -e "\nWhat's your phone number?"
read CUSTOMER_PHONE
CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone = '$CUSTOMER_PHONE'")

# if no phone number found -> ask name -> create new customer
if [[ -z $CUSTOMER_ID  ]]
then
  echo -e "\nI don't have a record for that phone number. What's your name?"
  read CUSTOMER_NAME
  # create customer in db
  INSERT_NEW_CUSTOMER_RESULT=$($PSQL "INSERT INTO customers (name, phone) VALUES('$CUSTOMER_NAME', '$CUSTOMER_PHONE')")
  # check if inserted correctly and give feedback to user
  if [[ "$INSERT_NEW_CUSTOMER_RESULT" == "INSERT 0 1" ]]; then
    echo "Customer inserted successfully."
    # get customer id for new created customer
    CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone = '$CUSTOMER_PHONE'")
  else
    echo "Error inserting customer."
    # handle the error here, if needed
  fi
fi
}

MAKE_APPOINTMENT() {
  # Get Customer and Service name
  CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE customer_id = $CUSTOMER_ID")
  SERVICE_NAME=$($PSQL "SELECT name FROM services WHERE service_id = $SERVICE_ID_SELECTED")

  # Ask for time for appointment
  echo -e "\nWhat time would you like your $SERVICE_NAME, $CUSTOMER_NAME" 
  read SERVICE_TIME
  echo -e "I have put you down for a $SERVICE_NAME at $SERVICE_TIME, $CUSTOMER_NAME. "

  # Insert Appointment
  INSERT_APPOINTMENT_RESULT=$($PSQL "INSERT INTO appointments (customer_id, service_id, time) VALUES ($CUSTOMER_ID, $SERVICE_ID_SELECTED, '$SERVICE_TIME')")
}



########## Main Menu function ##########
MAIN() {

# print the first argument provided to main function (if any)
if [[ $1 ]]
then 
  echo -e "$1"
fi

# Display Services
DISPLAY_SERVICES

# Get or create customer
GET_OR_CREATE_CUSTOMER

# Make Appointment
MAKE_APPOINTMENT

}

MAIN

# TODO
# Exit services
