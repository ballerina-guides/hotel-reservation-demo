import ballerina/http;
import ballerina/io;

final table<Room> key(number) rooms;
table<Reservation> key(id) roomReservations = table [];
public configurable string room_details_file = ?;


function init() returns error? {
    json roomsJson = check io:fileReadJson(room_details_file);
    rooms = check roomsJson.cloneWithType();
}


service /reservations on new http:Listener(9090) {

    resource function get roomTypes(string checkinDate, string checkoutDate, int guestCapacity) returns RoomType[]|error {
        return getAvailableRoomTypes(checkinDate, checkoutDate, guestCapacity);
    }

    resource function post .(ReservationRequest reservationRequest) returns Reservation|ReservationNotFound|error {
        Room? room = check getAvailableRoom(reservationRequest.checkinDate, reservationRequest.checkoutDate, reservationRequest.roomType);
        if (room is ()) {
            return {body: "No rooms available for the given dates"};
        }
        Reservation reservation = {
            id: roomReservations.length() + 1,
            checkinDate: reservationRequest.checkinDate,
            checkoutDate: reservationRequest.checkoutDate,
            room: room,
            user: reservationRequest.user
        };
        roomReservations.put(reservation);
        sendNotificationForReservation(reservation, "Confirmed");
        return reservation;

    }

    resource function put [int reservation_id](UpdateReservationRequest payload) returns Reservation|ReservationNotFound|error {
        Reservation? reservation = roomReservations[reservation_id];
        if (reservation is ()) {
            return {body: "Reservation not found"};
        }
        Room? room = check getAvailableRoom(payload.checkinDate, payload.checkoutDate, reservation.room.'type.name);
        if (room is ()) {
            return {body: "No rooms available for the given dates"};
        }
        reservation.room = room;
        reservation.checkinDate = payload.checkinDate;
        reservation.checkoutDate = payload.checkoutDate;
        sendNotificationForReservation(reservation, "Updated");
        return reservation;
    }

    resource function delete [int reservation_id]() returns http:Ok|ReservationNotFound {
        if (roomReservations.hasKey(reservation_id)) {
            _ = roomReservations.remove(reservation_id);
            return http:OK;
        } else {
            ReservationNotFound rError = {body: "Reservation not found"};
            return rError;
        }
    }

    resource function get users/[string userId]() returns Reservation[] {
        return from Reservation r in roomReservations
            where r.user.id == userId
            select r;
    }
}


