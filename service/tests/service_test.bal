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

    // Create a reservation
    anydata reservationRequest = {checkinDate: "2024-02-19T14:00:00Z", checkoutDate: "2024-02-20T10:00:00Z", rate: 100, user: user, roomType: "Family"};
    Reservation reservation = check testClient->post("/reservations", reservationRequest);
    test:assertEquals(reservation.room.number, 303);

    // Update a reservation
    UpdateReservationRequest updateReservationRequest = {checkinDate: "2024-02-20T14:00:00Z", checkoutDate: "2024-02-21T10:00:00Z"};
    reservation = check testClient->put("/reservations/" + reservation.id.toString(), updateReservationRequest);
    test:assertEquals(reservation.room.number, 303);

    // Get Users reservations
    Reservation[] reservations = check testClient->get("/reservations/users/123");
    test:assertEquals(reservations.length(), 1);
    test:assertEquals(reservations[0].room.number, 303);

    // Delete a reservation
    http:Response delete = check testClient->delete("/reservations/" + reservation.id.toString());
    test:assertEquals(delete.statusCode, 200);

    // Get Users reservations again
    reservations = check testClient->get("/reservations/users/123");
    test:assertEquals(reservations.length(), 0);
}

@test:Config {}
function testMultipleReservations() returns error? {

    anydata reservationRequest;
    Reservation[] reservations = [];
    // Create 3 reservations
    foreach int i in 0 ... 2 {
        reservationRequest = {checkoutDate: "2024-02-20T10:00:00Z", rate: 100, checkinDate: "2024-02-19T14:00:00Z", user: user, roomType: "Suite"};
        reservations[i] = check testClient->post("/reservations", reservationRequest);
        test:assertEquals(reservations[i].id, i + 1);
    }

    // Create addtional reservation and get No rooms available message
    reservationRequest = {checkoutDate: "2024-02-20T10:00:00Z", rate: 100, checkinDate: "2024-02-19T14:00:00Z", user: user, roomType: "Suite"};
    Reservation|http:ClientError response = testClient->post("/reservations", reservationRequest);
    test:assertTrue(response is http:ClientError);

    // Delete 3 reservations
    foreach var item in reservations {
        http:Response delete = check testClient->delete("/reservations/" + item.id.toString());
        test:assertEquals(delete.statusCode, 200);
    }
}
