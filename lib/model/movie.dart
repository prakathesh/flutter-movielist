import 'package:CWCFlutter/db/database_provider.dart';

class Movie {
  int id;
  String name;
  String release_date;
  String Image;
  String Director_name;


  Movie({this.id, this.name, this.release_date,this.Image,this.Director_name});

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      DatabaseProvider.COLUMN_NAME: name,
      DatabaseProvider.COLUMN_RELEASEDATE: release_date,





    };

    if (id != null) {
      map[DatabaseProvider.COLUMN_ID] = id;
    }

    return map;
  }

  Movie.fromMap(Map<String, dynamic> map) {
    id = map[DatabaseProvider.COLUMN_ID];
    name = map[DatabaseProvider.COLUMN_NAME];
    release_date = map[DatabaseProvider.COLUMN_RELEASEDATE];
    Image=map[DatabaseProvider.COLUMN_Image];
    Director_name=map[DatabaseProvider.COLUMN_DirectorName];


  }
}
