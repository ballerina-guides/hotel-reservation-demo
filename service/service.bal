import ballerina/io;

final table<Room> key(number) rooms;
table<Reservation> key(id) roomReservations = table [];
public configurable string room_details_file = ?;

function init() returns error? {
    json roomsJson = check io:fileReadJson(room_details_file);
    rooms = check roomsJson.cloneWithType();
}
