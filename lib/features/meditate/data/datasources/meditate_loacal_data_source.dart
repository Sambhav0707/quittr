import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:quittr/features/meditate/data/models/qoutes_model.dart';

abstract interface class MeditateLoacalDataSource {
  Future<List<QoutesModel>> getQoutes();
}

class MeditateLoacalDataSourceImpl implements MeditateLoacalDataSource {
  @override
  Future<List<QoutesModel>> getQoutes() async {
    try {
      // Read the JSON file
      final String response =
          await rootBundle.loadString('assets/data/quotes.json');
      final data = await json.decode(response);

      // Convert the JSON data to a list of QoutesModel
      final List<dynamic> quotesJson = data['quotes'];
      return quotesJson.map((quote) => QoutesModel.fromJson(quote)).toList();
    } catch (error) {
      throw Exception('Failed to load quotes: ${error.toString()}');
    }
  }
}
