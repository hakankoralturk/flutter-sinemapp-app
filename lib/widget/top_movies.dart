import 'package:movieapp/bloc/get_movies_bloc.dart';
import 'package:movieapp/model/movie.dart';
import 'package:movieapp/model/movie_data.dart';
import 'package:movieapp/screen/detail_screen.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:movieapp/theme/default.dart' as Theme;
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class TopMovies extends StatefulWidget {
  @override
  _TopMoviesState createState() => _TopMoviesState();
}

class _TopMoviesState extends State<TopMovies> {
  @override
  void initState() {
    super.initState();
    moviesBloc..getMovies();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 10, top: 20),
          child: Text(
            "En Çok Puan Alan Filmler".toUpperCase(),
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Theme.Colors.titleColor,
              fontSize: 12,
            ),
          ),
        ),
        SizedBox(height: 5),
        StreamBuilder<MovieData>(
          stream: moviesBloc.subject.stream,
          builder: (context, AsyncSnapshot<MovieData> snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data.error != null &&
                  snapshot.data.error.length > 0) {
                return _errorWidget(snapshot.data.error);
              }
              return _moviesWidget(snapshot.data);
            } else if (snapshot.hasError) {
              return _errorWidget(snapshot.data.error);
            } else {
              return _loadingWidget();
            }
          },
        ),
      ],
    );
  }

  Widget _loadingWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Text"),
          SizedBox(
            height: 25,
            width: 25,
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              strokeWidth: 4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _errorWidget(String error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Error occured: $error"),
        ],
      ),
    );
  }

  Widget _moviesWidget(MovieData data) {
    List<Movie> movies = data.movies;
    if (movies.length == 0) {
      return Container(
        child: Text("No Movies"),
      );
    } else
      return Container(
        height: 270,
        padding: EdgeInsets.only(left: 10),
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: movies.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: EdgeInsets.only(
                top: 10,
                bottom: 10,
                right: 10,
              ),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          MovieDetailScreen(movie: movies[index]),
                    ),
                  );
                },
                child: Column(
                  children: [
                    movies[index].poster == null
                        ? Container(
                            width: 120,
                            height: 180,
                            decoration: BoxDecoration(
                              color: Theme.Colors.secondaryColor,
                              borderRadius: BorderRadius.circular(2),
                              shape: BoxShape.rectangle,
                            ),
                            child: Column(
                              children: [
                                Icon(EvaIcons.filmOutline,
                                    color: Colors.white, size: 50),
                              ],
                            ),
                          )
                        : Container(
                            width: 120,
                            height: 180,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(2),
                              shape: BoxShape.rectangle,
                              image: DecorationImage(
                                image: NetworkImage(
                                    "https://image.tmdb.org/t/p/w200/" +
                                        movies[index].poster),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      width: 100,
                      height: 30,
                      alignment: Alignment.center,
                      child: Text(
                        movies[index].title,
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          height: 1.4,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Row(
                      children: [
                        Text(
                          movies[index].rating.toString(),
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        RatingBar(
                          itemSize: 8,
                          initialRating: movies[index].rating / 2,
                          minRating: 1,
                          direction: Axis.horizontal,
                          allowHalfRating: true,
                          itemCount: 5,
                          itemPadding: EdgeInsets.symmetric(horizontal: 2),
                          itemBuilder: (context, _) => Icon(
                            EvaIcons.star,
                            color: Theme.Colors.secondaryColor,
                          ),
                          onRatingUpdate: (rating) {
                            print(rating);
                          },
                        ),
                      ],
                    )
                  ],
                ),
              ),
            );
          },
        ),
      );
  }
}
