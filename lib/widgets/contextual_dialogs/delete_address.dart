import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_app_arosaje/main.dart';
import 'package:mobile_app_arosaje/models/plant.dart';
import 'package:mobile_app_arosaje/models/publication.dart';
import 'package:mobile_app_arosaje/models/report.dart';
import 'package:mobile_app_arosaje/models/user.dart';
import 'package:mobile_app_arosaje/services/api_address_service.dart';
import 'package:mobile_app_arosaje/services/api_picture_service.dart';
import 'package:mobile_app_arosaje/services/api_plant_service.dart';
import 'package:mobile_app_arosaje/services/api_publication_service.dart';
import 'package:mobile_app_arosaje/services/api_report_service.dart';

class DeleteAddress extends StatefulWidget {
  final Map<String, dynamic> map;
  const DeleteAddress({super.key, required this.map});

  @override
  State<DeleteAddress> createState() => _DeleteAddressState();
}

class _DeleteAddressState extends State<DeleteAddress> {
  @override
  Widget build(BuildContext context) {
    final address = widget.map['address'];
    return AlertDialog(
      title: const Text('Supprimer l\'adresse'),
      content:
          const Text('Êtes-vous sûr(e) de vouloir supprimer cette adresse ?'
              '\nCette action est irréversible et cela supprimera également'
              ' les plantes ainsi que les publications liées à cette adresse.'),
      actions: [
        TextButton(
            onPressed: () {
              context.pop();
            },
            child: const Text('Annuler')),
        TextButton(
            onPressed: () async {
              List<Plant> plants = await ApiPlantService.getByAddress(address);
              List<Publication> publications = await ApiPublicationService.getByUser(User.getCurrent());
              for (Plant plant in plants) {
                for (Publication publication in publications) {
                  // List<Comment> comments = await ApiCommentService.getCommentsByPublication(publication);
                  // if (comments.isNotEmpty) {
                  //   for (Comment comment in comments) {
                  //     await ApiCommentService.deleteComment(comment);
                  //   }
                  // }
                  if (publication.plants.where((element) => element.id == plant.id).isNotEmpty) {
                    List<Report> reports = await ApiReportService.getByPublication(publication);
                    if (reports.isNotEmpty) {
                      for (Report report in reports) {
                        await ApiReportService.delete(report);
                      }
                    }
                    await ApiPublicationService.delete(publication);
                  }
                }
                await ApiPictureService.delete(plant.picture!);
                await ApiPlantService.delete(plant);
              }
              ApiAddressService.delete(address).then((value) {
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Adresse supprimée')));
                context.go('/user');
              });
            },
            child: const Text('Confirmer'))
      ],
    );
  }
}
