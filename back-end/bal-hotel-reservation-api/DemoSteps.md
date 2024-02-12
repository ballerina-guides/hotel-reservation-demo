# How to Implement the Hotel Reservation API

1) Create a Ballerina Project with name `hotel-reservation-api`
2) Refer README.md and generate the Record Types for the service.
3) Write init function to load rooms using json in the resources/rooms.json.
4) Write a service for implement API for hotel reservation front end. 
   It should provide following API paths. Refer README.md for more on service resources.

   1) Get available room types
   2) Create a reservation
   3) Update the reservation
   4) Get user reservations
   5) Delete the reservation

5) Write a simple test for get roomTypes, add a reservation, update reservations, see user reservations and delete reservations.


TIPS: 
1) Use configurable variable to store the rooms.json file path.
2) Use init.bal, types.bal, service.bal, utils.bal organize the code.
3) Use two tables for Rooms and Reservations.
   
   ```
   table<Room> key(number) rooms;

   table<Reservation> key(id) roomReservations = table [];
   
   ```
   
4) Following code can be used to send notifications.
   
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
5) 
