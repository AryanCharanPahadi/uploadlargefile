// To parse this JSON data, do
//
//     final enrolmentCollectionModel = enrolmentCollectionModelFromJson(jsonString);

import 'dart:convert';

EnrolmentCollectionModel enrolmentCollectionModelFromJson(String str) => EnrolmentCollectionModel.fromJson(json.decode(str));

String enrolmentCollectionModelToJson(EnrolmentCollectionModel data) => json.encode(data.toJson());

class EnrolmentCollectionModel{
    int? id;
    String? tourId;
    String? school;
    String? registerImage;
    String? enrolmentData;
    String? remarks;
    String? createdAt;
    String? submittedBy;

    EnrolmentCollectionModel({
        this.id,
        required this.tourId,
        required this.school,
        required this.registerImage,
        required this.enrolmentData,
        required this.remarks,
        required this.createdAt,
        required this.submittedBy,
    });

    factory EnrolmentCollectionModel.fromJson(Map<String, dynamic> json) => EnrolmentCollectionModel(
        id: json["id"],
        tourId: json["tourId"],
        school: json["school"],
        registerImage: json["registerImage"],
        enrolmentData: json["enrolmentData"],
        remarks: json["remarks"],
        createdAt: json["createdAt"],
        submittedBy: json["submittedBy"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "tourId": tourId,
        "school": school,
        "registerImage": registerImage,
        "enrolmentData": enrolmentData,
        "remarks": remarks,
        "createdAt": createdAt,
        "submittedBy": submittedBy,
    };
}
