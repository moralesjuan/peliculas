import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:peliculas/src/models/pelicula_model.dart';

class PeliculasProvider {
  String _apiKey = '41e298c8cd9b8268f45960b00e73824f';
  String _url = 'api.themoviedb.org';
  String _lenguage = 'en-US';

  int _popularesPage = 0;

  List<Pelicula> _populares = new List();

  final _popularesStream = StreamController();

  void disposeStreams() {
    _popularesStream?.close();
  }

  Future<List<Pelicula>> _procesarRespuesta(Uri url) async {
    final resp = await http.get(url);
    final decodedData = json.decode(resp.body);

    final peliculas = new Peliculas.fromJsonList(decodedData['results']);

    return peliculas.items;
  }

  Future<List<Pelicula>> getEnCines() async {
    final url = Uri.https(_url, '3/movie/now_playing',
        {'api_key': _apiKey, 'language': _lenguage});

    return await _procesarRespuesta(url);
  }

  Future<List<Pelicula>> getPopulares() async {
    _popularesPage++;
    final url = Uri.https(
        _url, '3/movie/popular', {'api_key': _apiKey, 'language': _lenguage});

    return await _procesarRespuesta(url);
  }
}
