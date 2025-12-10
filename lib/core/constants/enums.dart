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

enum RentalStatus{
  pending,
  approved,
  active,
  completed,
  cancelled,
}