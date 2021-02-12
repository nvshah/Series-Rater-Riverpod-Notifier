import 'package:meta/meta.dart';

class Series {
  final String name;
  final double ratings;

  Series({
    @required this.name,
    @required this.ratings,
  });
  
  //? For Value Equality instead refrential equality
  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is Series &&
        o.name == name &&
        o.ratings == ratings;
  }

  @override
  int get hashCode => name.hashCode ^ ratings.hashCode;
}