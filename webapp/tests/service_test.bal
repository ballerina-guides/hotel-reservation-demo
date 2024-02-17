import ballerina/http;
import ballerina/test;

http:Client testClient = check new ("http://localhost:9090");

configurable User user = ?;

@test:Config {}
function testReservation() returns error? {
    // Get available Rooms
    RoomType[] roomTypes = check testClient->get("/reservations/roomTypes?checkinDate=2024-02-19T14:00:00Z&checkoutDate=2024-02-20T10:00:00Z&guestCapacity=3");
    test:assertEquals(roomTypes.length(), 2, "Invalid room types length");
    test:assertEquals(roomTypes[0].name, "Family");
    test:assertEquals(roomTypes[1].name, "Suite");

    // TODO: Test new reservation request
}

