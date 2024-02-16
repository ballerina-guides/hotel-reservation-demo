import ballerina/log;
import ballerina/time;

import wso2/choreo.sendemail;
import wso2/choreo.sendsms;

sendsms:Client smsClient = check new ();
sendemail:Client emailClient = check new ();

function getAvailableRoomTypes(string checkinDate, string checkoutDate, int guestCapacity) returns RoomType[]|error {
    table<Room> key(number) allocatedRooms = check getAllocatedRooms(checkinDate, checkoutDate);
    return from Room r in rooms
        where r.'type.guestCapacity >= guestCapacity && !allocatedRooms.hasKey(r.number)
        let var t = r.'type
        group by t
        select t;
}

function getAvailableRoom(string checkinDate, string checkoutDate, string roomType) returns Room?|error {
    table<Room> key(number) allocatedRooms = check getAllocatedRooms(checkinDate, checkoutDate);
    foreach Room r in rooms {
        if r.'type.name == roomType && !allocatedRooms.hasKey(r.number) {
            return r;
        }
    }
    return;
}

function getAllocatedRooms(string checkinDate, string checkoutDate) returns table<Room> key(number)|error {
    time:Utc userCheckinUTC = check time:utcFromString(checkinDate);
    time:Utc userCheckoutUTC = check time:utcFromString(checkoutDate);
    return table key(number) from Reservation r in roomReservations
        let time:Utc rCheckin = check time:utcFromString(r.checkinDate)
        let time:Utc rCheckout = check time:utcFromString(r.checkoutDate)
        where userCheckinUTC <= rCheckin && userCheckoutUTC >= rCheckout
        select r.room;
}

function sendNotificationForReservation(Reservation reservation, string action) {
    string message = getSmsContent(reservation);
    string emailSubject = getEmailSubject(reservation, action);
    string emailBody = getEmailContent(reservation);
    string|error sendEmal = trap emailClient->sendEmail(reservation.user.email, emailSubject, emailBody);
    if (sendEmal is error) {
        log:printError("Error sending Email: ", sendEmal);
    }
    string|error sendSms = trap smsClient->sendSms(reservation.user.mobileNumber, message);
    if (sendSms is error) {
        log:printError("Error sending SMS: ", sendSms);
    }
}

function getEmailSubject(Reservation reservation, string action) returns string => string `Reservation ${action}: ${reservation.id}`;

function getEmailContent(Reservation reservation) returns string =>
    let Room room = reservation.room in
    string `Dear ${reservation.user.name},

    We are pleased to confirm your reservation at our hotel.

    Reservation Details
        Reservation Number: ${reservation.id}
        Reservation Checkin Date: ${reservation.checkinDate}
        Reservation Checkout Date: ${reservation.checkoutDate}

    Room Details
        Number: ${room.number}
        Type: ${room.'type.name}
        
    Thanks,
    Reservation Team`;

function getSmsContent(Reservation reservation) returns string =>
        string `We are pleased to confirm your reservation at our hotel with Reservation Number: ${reservation.id}`;
