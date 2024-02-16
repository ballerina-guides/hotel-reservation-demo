# Hotel Reservation Demo

This application has a front end developed using React.js and an API service implemented using Ballerina to demo a simple hotel reservation use case.

# How to Run 

1. Run Ballerina Backend.
   - Install [Ballerina](https://ballerina.io/downloads/) version 2201.8.4 if not already done.
   - Navigate to the backend directory: `cd service`
   - Run `bal run`

2. Start Front-end.
   - Install Node.js version 20.x.x.
   - Run
```
cd webapp
npm install
npm start
```

3. Visit the `http://localhost:3000/reservations`


# How to Implement Hotel Reservation API

## Prerequisites

* ballerina
* npm

## Steps

1) Clone Git Repo https://github.com/ballerina-guides/hotel-reservation-demo
2) Goto backend directory.
3) Refer to `backend/README.md` and generate the Record types for the service.
4) Add HTTP service component to implement API for the hotel reservation front end. 
   It should provide the following API paths. Please refer to README.md for more on service resources.

   1) Get available room types
   2) Create a reservation
   3) Update the reservation
   4) Get user reservations
   5) Delete the reservation

5) Improve tests and add a reservation with the following reservation.

```
{
   checkinDate: "2024-02-19T14:00:00Z", 
   checkoutDate: "2024-02-20T10:00:00Z", 
   rate: 100, 
   user: user, 
   roomType: "Family"
}

```


## TIPS: 
   
1)  Use two tables for Rooms and Reservations.
   
   ```
   table<Room> key(number) rooms;

   table<Reservation> key(id) roomReservations = table [];
   
   ```
   
2)  Use utils functions in utils.bal file.
