import 'dart:ui';

import 'package:CWCFlutter/bloc/movie_bloc.dart';
import 'package:CWCFlutter/db/database_provider.dart';
import 'package:CWCFlutter/events/add_movie.dart';
import 'package:CWCFlutter/events/update_movie.dart';
import 'package:CWCFlutter/model/movie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MovieForm extends StatefulWidget {
  final Movie movie;
  final int movieIndex;

  MovieForm({this.movie, this.movieIndex});

  @override
  State<StatefulWidget> createState() {
    return MovieFormState();
  }
}

class MovieFormState extends State<MovieForm> {
  String _Moviename;
  String _ReleaseDate;
  String _Image;
  String _Directorname;


  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Widget _buildName() {
    return TextFormField(
      initialValue: _Moviename,
      decoration: InputDecoration(labelText: 'Name '),
      maxLength: 15,
      style: TextStyle(fontSize: 28),
      validator: (String value) {
        if (value.isEmpty) {
          return 'Name is Required';
        }

        return null;
      },
      onSaved: (String value) {
        _Moviename = value;
      },
    );
  }

  Widget _buildRelease() {
    return TextFormField(
      initialValue: _ReleaseDate,
      decoration: InputDecoration(labelText: 'Director Name '),

      style: TextStyle(fontSize: 28),
      validator: (String value) {


        if (value.isEmpty) {
          return 'Required';
        }

        return null;
      },
      onSaved: (String value) {
        _ReleaseDate = value;
      },
    );
  }
  Widget _buildImage() {
    return TextFormField(
      initialValue: _Directorname,
      decoration: InputDecoration(labelText: 'Image url'),
      style: TextStyle(fontSize: 28),
      validator: (String value) {
        if (value.isEmpty) {
          return 'URL is Required';
        }

        return null;
      },
      onSaved: (String value) {
        _Directorname = value;
      },
    );
  }
  Widget _buildDirector() {
    return TextFormField(
      initialValue: _Directorname,
      decoration: InputDecoration(labelText: 'Re-enter image url'),
      style: TextStyle(fontSize: 28),
      validator: (String value) {
        if (value.isEmpty) {
          return ' Required';
        }

        return null;
      },
      onSaved: (String value) {
        _Directorname = value;
      },
    );
  }



  @override
  void initState() {
    super.initState();
    if (widget.movie != null) {
      _Moviename = widget.movie.name;
      _ReleaseDate = widget.movie.release_date;
      _Image=widget.movie.Image;
      _Directorname=widget.movie.Director_name;


    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Movie Form")),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              _buildName(),
              _buildRelease(),
              _buildImage(),
              _buildDirector(),
              SizedBox(height: 20),
              widget.movie == null
                  ? RaisedButton(
                child: Text(
                  'Submit',
                  style: TextStyle(color: Colors.blue, fontSize: 16),
                ),
                onPressed: () {
                  if (!_formKey.currentState.validate()) {
                    return;
                  }

                  _formKey.currentState.save();

                  Movie movie = Movie(
                    name: _Moviename,
                    release_date: _ReleaseDate,
                    Image: _Image,
                    Director_name: _Directorname,

                  );

                  DatabaseProvider.db.insert(movie).then(
                        (storedMovie) =>
                        BlocProvider.of<MovieBloc>(context).add(
                          AddMovie(storedMovie),
                        ),
                  );

                  Navigator.pop(context);
                },
              )
                  : Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  RaisedButton(
                    child: Text(
                      "Update",
                      style: TextStyle(color: Colors.blue, fontSize: 16),
                    ),
                    onPressed: () {
                      if (!_formKey.currentState.validate()) {
                        print("form");
                        return;
                      }

                      _formKey.currentState.save();

                      Movie movie = Movie(
                        name: _Moviename,
                        release_date: _ReleaseDate,
                        Image: _Image,
                        Director_name: _Directorname,

                      );

                      DatabaseProvider.db.update(widget.movie).then(
                            (storedMovie) =>
                            BlocProvider.of<MovieBloc>(context).add(
                              UpdateMovie(widget.movieIndex, movie),
                            ),
                      );

                      Navigator.pop(context);
                    },
                  ),
                  RaisedButton(
                    child: Text(
                      "Cancel",
                      style: TextStyle(color: Colors.red, fontSize: 16),
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
