import ballerina/http;

type ReservationNotFound record {|
    *http:NotFound;
    string body;
|};

public type Reservation record {|
    readonly int id;
    Room room;
    string checkinDate;
    string checkoutDate;
    User user;
|};

public type Room record {|
    readonly int number;
    RoomType 'type;
|};


public type RoomType record {
    int id;
    string name;
    int guestCapacity;
    decimal price;
};

public type ReservationRequest record {
    string checkinDate;
    string checkoutDate;
    string roomType;
    User user;
    decimal rate;
};

public type User record {
    string id;
    string name;
    string email;
    string mobileNumber;
};

public type UpdateReservationRequest record {
    string checkinDate;
    string checkoutDate;
};





