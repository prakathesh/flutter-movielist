import 'package:CWCFlutter/db/database_provider.dart';
import 'package:CWCFlutter/events/delete_movie.dart';
import 'package:CWCFlutter/events/set_movies.dart';
import 'package:CWCFlutter/movie_form.dart';
import 'package:CWCFlutter/model/movie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/movie_bloc.dart';

class MovieList extends StatefulWidget {
  static String id='movie_list';
  const MovieList({Key key}) : super(key: key);

  @override
  _MovieListState createState() => _MovieListState();
}

class _MovieListState extends State<MovieList> {
  @override
  void initState() {
    super.initState();
    DatabaseProvider.db.getMovies().then(
          (movieList) {
        BlocProvider.of<MovieBloc>(context).add(SetMovies(movieList));
      },
    );
  }

  showFoodDialog(BuildContext context, Movie movie, int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(movie.name),
        content: Text("ID ${movie.id}"),
        actions: <Widget>[
          FlatButton(
            onPressed: () => Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => MovieForm(movie: movie, movieIndex: index),
              ),
            ),
            child: Text("Update"),
          ),
          FlatButton(
            onPressed: () => DatabaseProvider.db.delete(movie.id).then((_) {
              BlocProvider.of<MovieBloc>(context).add(
                DeleteMovie(index),
              );
              Navigator.pop(context);
            }),
            child: Text("Delete"),
          ),
          FlatButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancel"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Movie List"),
        leading: Image.asset(
          'assets/images/appbar.jpg',
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(8),
        color: Colors.grey,
        child: BlocConsumer<MovieBloc, List<Movie>>(
          builder: (context, movieList) {
            return ListView.builder(
              itemBuilder: (BuildContext context, int index) {
                print("movieList: $movieList");

                Movie movie = movieList[index];
                return Card(
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage("${movie.Director_name}"),
                      radius: 30,
                    ),
                    contentPadding: EdgeInsets.all(16),
                    title: Text(movie.name, style: TextStyle(fontSize: 26)),
                    subtitle: Text(
                      "Director Name: ${movie.release_date}",
                      style: TextStyle(fontSize: 20),
                    ),
                    onTap: () => showFoodDialog(context, movie, index),
                  ),
                );
              },
              itemCount: movieList.length,
            );
          },
          listener: (BuildContext context, movieList) {},
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (BuildContext context) => MovieForm()),
        ),
      ),
    );
  }
}
