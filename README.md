# Hair Bash

Hair Bash is a simple command-line application to manage a hair salon's appointments using a PostgreSQL database. The script allows customers to select services, input their contact information, and schedule appointments.

## Task

Create an interactive Bash program that uses PostgreSQL to track the customers and appointments for your salon.

## Features

- Display available hair salon services
- Add new customers or retrieve existing customers by phone number
- Schedule appointments for customers

## Requirements

- Bash
- PostgreSQL

## Setup

### Database Setup

1. Make sure you have PostgreSQL installed and running.
2. Create a PostgreSQL user `freecodecamp` (or any other username you prefer) with the ability to create databases and manage them.
3. Create the database `salon`:

    ```sh
    createdb salon
    ```

4. Create the necessary tables:

    ```sql
    CREATE TABLE services (
      service_id SERIAL PRIMARY KEY,
      name VARCHAR(50) NOT NULL
    );

    CREATE TABLE customers (
      customer_id SERIAL PRIMARY KEY,
      name VARCHAR(50) NOT NULL,
      phone VARCHAR(20) NOT NULL UNIQUE
    );

    CREATE TABLE appointments (
      appointment_id SERIAL PRIMARY KEY,
      customer_id INT REFERENCES customers(customer_id),
      service_id INT REFERENCES services(service_id),
      time VARCHAR(20) NOT NULL
    );

    INSERT INTO services (name) VALUES ('Cut'), ('Color'), ('Style');
    ```

### Script Setup

1. Make sure you have the script file (`hair_bash.sh`) in your desired directory.
2. Make the script executable:

    ```sh
    chmod +x hair_bash.sh
    ```

3. Run the script:

    ```sh
    ./hair_bash.sh
    ```

## Usage

Upon running the script, you will be greeted with a welcome message and a list of available services. You can select a service by entering the corresponding number.

If you are a new customer, you will be prompted to enter your name and phone number. This information will be stored in the database for future reference.

After selecting a service and entering your details, you will be asked to specify a time for your appointment. The appointment will be scheduled and confirmed.

## Script Breakdown

### Main Functions

- `MAIN`: The main function that initiates the script, displays services, gets or creates a customer, and makes an appointment.
- `DISPLAY_SERVICES`: Displays available services and prompts the user to select one.
- `GET_SERVICE`: Validates the selected service and checks if it exists in the database.
- `GET_OR_CREATE_CUSTOMER`: Retrieves a customer by phone number or creates a new customer if the phone number is not found.
- `MAKE_APPOINTMENT`: Schedules an appointment for t
