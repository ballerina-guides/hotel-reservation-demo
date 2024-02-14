# Hotel Reservation Demo

This application has front end developed using React.js and API service implemented using ballerina to demo simple hotel reservation usecase.


# How to Run 

1. Run Ballerina Backend.
   - Install [Ballerina](https://ballerina.io/downloads/) version 2201.8.4 if not already done.
   - Navigate to the backend directory: `cd back-end`
   - Run `bal run`

2. Start Front-end.
   - Install Node.js version 20.x.x.
   - Run
```
cd front-end
npm install
npm start
```

3. Visit the `http://localhost:3000/reservations`


# How to Implemet Hotel Reservation API

## Prerequisites

* ballerina
* npm

## Steps

1) Clone Git Repo https://github.com/ballerina-guides/hotel-reservation-demo
2) Goto backend directory
3) Create a Ballerina Project with name `bal new .`
4) Refer `backend/README.md` and generate the Record types for the service.
5) Write init function to load rooms using json in the `resources/rooms.json`.
6) Write a service for implement API for hotel reservation front end. 
   It should provide following API paths. Refer README.md for more on service resources.

   1) Get available room types
   2) Create a reservation
   3) Update the reservation
   4) Get user reservations
   5) Delete the reservation

7) Write a simple test for get roomTypes, add a reservation, update reservations, see user reservations and delete reservations.


## TIPS: 
1) Use configurable variable to store the rooms.json file path and use init method to load it from file. 
   We can use `io:fileReadJson` and `cloneWithType` to load the rooms from json.

2) Use types.bal, service.bal, utils.bal organize the code.
3) Use io package to read json from file.

```
    json roomsJson = check io:fileReadJson(room_details_file);
    rooms = check roomsJson.cloneWithType();
```

1)  and `cloneWithType` to method to convert to arrays of rooms.
2) 
3)  Use two tables for Rooms and Reservations.
   
   ```
   table<Room> key(number) rooms;

   table<Reservation> key(id) roomReservations = table [];
   
   ```
   
4)  use `time:utcFromString` for convert time to utc.
5)  Following code can be used to send notifications.
   
```
   import wso2/choreo.sendemail;
   import wso2/choreo.sendsms;

   function sendNotificationForReservation(Reservation reservation, string action) {
      
      string message = string `We are pleased to confirm your reservation.`;
      string emailSubject = string `Reservation ${action}: ${reservation.id}`;
      string emailBody = string `Dear ${reservation.user.name},${"\n"}${"\n"}We are pleased to confirm your reservation at our hotel.${"\n"}${"\n"}Thanks, ${"\n"}Reservation Team`;
      string|error sendEmal = trap emailClient->sendEmail(reservation.user.email, emailSubject, emailBody);
      if (sendEmal is error) {
         log:printError("Error sending Email: ", sendEmal);
      }
      string|error sendSms = trap smsClient->sendSms(reservation.user.mobileNumber, message);
      if (sendSms is error) {
         log:printError("Error sending SMS: ", sendSms);
      }
   }

```
