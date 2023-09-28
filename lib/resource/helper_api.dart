import 'package:dio/dio.dart';
import 'package:isilahtitiktitik/model/city.dart';
import 'package:isilahtitiktitik/model/profesi.dart';
import 'package:isilahtitiktitik/model/province.dart';
import 'package:isilahtitiktitik/model/region.dart';
import 'package:isilahtitiktitik/model/region_postal_code.dart';
import 'package:isilahtitiktitik/model/subdistrict.dart';
import 'package:isilahtitiktitik/model/urban_village.dart';
import 'package:isilahtitiktitik/model/version_app.dart';
import 'package:isilahtitiktitik/resource/api.dart';
import 'package:isilahtitiktitik/utils/api_helper.dart';
import 'package:isilahtitiktitik/utils/enc.dart';
import 'package:isilahtitiktitik/utils/exceptions.dart';
import 'package:logger/logger.dart';

class HelperApi {
  final CHttp? http;
  HelperApi({this.http});

  Future<RegionModel> fetchRegion(String query) async {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final gmt = DateTime.now().timeZoneOffset.inHours;
    final apiKey = encryptAES(timestamp, gmt);
    Dio dio = Dio();
    try {
      Response res = await dio.post(
        regionUrl,
        data: {"search": query, "limit": 30, "page": 1},
        options: Options(headers: {"isilah-key": apiKey, "release": timestamp}),
      );

      RegionModel regionModel = RegionModel.fromJson(res.data);
      return regionModel;
    } on DioError catch (err) {
      throw err.response!.data;
    }
  }

  Future<RegionPostalCodeModel> fetchRegionByPostalCode(
      String postalCode) async {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final gmt = DateTime.now().timeZoneOffset.inHours;
    final apiKey = encryptAES(timestamp, gmt);
    Dio dio = Dio();

    try {
      Response res = await dio.get(
        "$regionByPostalcodeUrl/$postalCode",
        options: Options(headers: {"isilah-key": apiKey, "release": timestamp}),
      );

      RegionPostalCodeModel regionModel =
          RegionPostalCodeModel.fromJson(res.data);
      Logger().d(res.data);
      return regionModel;
    } on DioError catch (err) {
      Logger().e("error : $err");
      if (err.response != null) {
        throw err.response!.data;
      } else {
        throw DioExceptions.fromDioError(
                dioError: err, errorFrom: "fetchRegionByPostalCode")
            .errorMessage();
      }
    }
  }

  Future<ProfesiModel> fetchProfesi() async {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final gmt = DateTime.now().timeZoneOffset.inHours;
    final apiKey = encryptAES(timestamp, gmt);
    Dio dio = Dio();
    try {
      Response res = await dio.post(
        profesiUrl,
        options: Options(headers: {"isilah-key": apiKey, "release": timestamp}),
      );

      ProfesiModel profesiModel = ProfesiModel.fromJson(res.data);
      return profesiModel;
    } on DioError catch (err) {
      throw DioExceptions.fromDioError(dioError: err, errorFrom: "fetchProfesi")
          .errorMessage();
    }
  }

  Future<VersionModel> fetchVersion(String version, String os) async {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final gmt = DateTime.now().timeZoneOffset.inHours;
    final apiKey = encryptAES(timestamp, gmt);
    Dio dio = Dio();
    try {
      Response res = await dio.post(
        versionUrl,
        data: {"version": version, "os": os},
        options: Options(headers: {"isilah-key": apiKey, "release": timestamp}),
      );
      VersionModel versionModel = VersionModel.fromJson(res.data);
      return versionModel;
    } on DioError catch (err) {
      throw err.response!.data;
    }
  }

  Future<ProvinceModel> fetchProvince() async {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final gmt = DateTime.now().timeZoneOffset.inHours;
    final apiKey = encryptAES(timestamp, gmt);
    Dio dio = Dio();
    try {
      Response res = await dio.post(
        provinceUrl,
        options: Options(headers: {"isilah-key": apiKey, "release": timestamp}),
      );
      ProvinceModel provinceModel = ProvinceModel.fromJson(res.data);
      return provinceModel;
    } on DioError catch (err) {
      throw DioExceptions.fromDioError(
              dioError: err, errorFrom: "fetchProvince")
          .errorMessage();
    }
  }

  Future<CityModel> fetchCity(int idProvince) async {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final gmt = DateTime.now().timeZoneOffset.inHours;
    final apiKey = encryptAES(timestamp, gmt);
    Dio dio = Dio();
    try {
      Response res = await dio.post(
        cityUrl,
        data: {"province_id": idProvince},
        options: Options(headers: {"isilah-key": apiKey, "release": timestamp}),
      );
      CityModel cityModel = CityModel.fromJson(res.data);
      return cityModel;
    } on DioError catch (err) {
      throw DioExceptions.fromDioError(dioError: err, errorFrom: "fetchCity")
          .errorMessage();
    }
  }

  Future<SubdistrictModel> fetchSubdistrict(int idCity) async {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final gmt = DateTime.now().timeZoneOffset.inHours;
    final apiKey = encryptAES(timestamp, gmt);
    Dio dio = Dio();
    try {
      Response res = await dio.post(
        subdistrictUrl,
        data: {"regency_id": idCity},
        options: Options(headers: {"isilah-key": apiKey, "release": timestamp}),
      );
      SubdistrictModel subdistrictModel = SubdistrictModel.fromJson(res.data);
      return subdistrictModel;
    } on DioError catch (err) {
      throw DioExceptions.fromDioError(
              dioError: err, errorFrom: "fetchSubdistrict")
          .errorMessage();
    }
  }

  Future<UrbanVillageModel> fetchUrbanVillage(int idSubdistrict) async {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final gmt = DateTime.now().timeZoneOffset.inHours;
    final apiKey = encryptAES(timestamp, gmt);
    Dio dio = Dio();
    try {
      Response res = await dio.post(
        urbanVillageUrl,
        data: {"subdistrict_id": idSubdistrict},
        options: Options(headers: {"isilah-key": apiKey, "release": timestamp}),
      );
      UrbanVillageModel urbanVillageModel =
          UrbanVillageModel.fromJson(res.data);
      return urbanVillageModel;
    } on DioError catch (err) {
      throw DioExceptions.fromDioError(
              dioError: err, errorFrom: "fetchUrbanVillage")
          .errorMessage();
    }
  }
}
