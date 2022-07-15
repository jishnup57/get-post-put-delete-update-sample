import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:note_app_get_post_put/core/urls.dart';

import '../Domain/get_all_notes/get_all_notes.dart';
import '../Domain/note_model/note_model.dart';

abstract class ApiClass {
  Future<NoteModel?> createNote(NoteModel value);
  Future<List<NoteModel>> getAllNotes();
  Future<NoteModel?> updateNote(NoteModel value);
  Future<void> deleteNote(String id);
}

class NoteDB implements ApiClass {
  final dio = Dio(BaseOptions(
    baseUrl: Url.baseUrl,
    responseType: ResponseType.plain,
  ));

  static ValueNotifier<List<NoteModel>> allListNotifier = ValueNotifier([]);

  @override
  Future<NoteModel?> createNote(NoteModel value) async {
    try {
      final _result = await dio.post(Url.createNote, data: value.toJson());
      final _resultAsJson = jsonDecode(_result.data);
      allListNotifier.notifyListeners();
      return NoteModel.fromJson(_resultAsJson);
    } on DioError catch (e) {
      print(e.response?.data.toString());
      log(e.toString());
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Future<void> deleteNote(String id) async {
    final _result = await dio.delete(Url.deleteNote.replaceFirst('{id}', id));
    if (_result == null) {
      return;
    }
    final _index = allListNotifier.value.indexWhere((note) => note.id == id);
    if (_index == -1) {
      return;
    }
    allListNotifier.value.removeAt(_index);
    allListNotifier.notifyListeners();
  }

  @override
  Future<List<NoteModel>> getAllNotes() async {
    final response = await dio.get(Url.getAllNote);

    if (response.data != null) {
      final resultAsJson = jsonDecode(response.data);
      final getallnotesRepo = GetAllNotes.fromJson(resultAsJson);
      allListNotifier.value.clear();
      allListNotifier.value.addAll(getallnotesRepo.data.reversed);
      allListNotifier.notifyListeners();
      return getallnotesRepo.data;
    } else {
      allListNotifier.value.clear();
      allListNotifier.notifyListeners();
      return [];
    }
  }

  @override
  Future<NoteModel?> updateNote(NoteModel value) async {
    final _result=await dio.put(Url.updateNote,data: value.toJson());
    final resultasjson=jsonDecode(_result.data);
    // final getallnotesRepo = GetAllNotes.fromJson(resultAsJson);
    final reppo=NoteModel.fromJson(resultasjson);
   // final _data=NoteModel.fromJson(_result.data);
   // log(_data.toString());
    if (_result.data==null) {
      return null;
    }
    final _index=allListNotifier.value.indexWhere((notes) =>notes.id==value.id );

    if (_index==-1) {
      return null;
    }
    allListNotifier.value.removeAt(_index);
    allListNotifier.value.insert(_index,reppo);
    allListNotifier.notifyListeners();
    return reppo;
  }

  NoteModel? getNoteById(String id){
  try{
  return allListNotifier.value.firstWhere((note) =>note.id== id);

  }
  catch(e){
    log(e.toString());
    return null;
   
  }
  }
}
