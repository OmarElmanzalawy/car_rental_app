enum UserType {
  customer,
  seller,
  admin,
}

enum GearBox{
  automatic,
  manual,
}

enum FuelType{
  petrol,
  electric,
  hybrid,
  naturalGas;

  String get value {
    switch (this) {
      case petrol:
        return 'petrol';
      case electric:
        return 'electric';
      case hybrid:
        return 'hybrid';
      case naturalGas:
        return 'natural gas';
    }
  }
}


enum MessageType{
  text,
  bookingRequest,
  info;

  String get value{
    switch (this) {
      case text:
        return 'text';
      case bookingRequest:
        return 'booking_request';
      case info:
        return 'info';
    }
  }
}

enum RentalStatus{
  pending,
  approved,
  active,
  completed,
  canceled,
}