class Bookingmodel {
  final int bookingId;
  final int roomId;
  final String user;
  final DateTime chackIn;
  final DateTime chackout;
  final double totalPrice;
  // ignore: non_constant_identifier_names
  final int num_persons;

  const Bookingmodel(
      {required this.bookingId,
      required this.roomId,
      required this.chackIn,
      required this.chackout,
      // ignore: non_constant_identifier_names
      required this.num_persons,
      required this.totalPrice,
      required this.user,
      
      });
}
