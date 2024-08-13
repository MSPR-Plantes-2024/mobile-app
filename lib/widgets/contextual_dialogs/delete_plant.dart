import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_app_arosaje/main.dart';
import 'package:mobile_app_arosaje/models/publication.dart';
import 'package:mobile_app_arosaje/models/report.dart';
import 'package:mobile_app_arosaje/models/user.dart';
import 'package:mobile_app_arosaje/services/api_picture_service.dart';
import 'package:mobile_app_arosaje/services/api_plant_service.dart';
import 'package:mobile_app_arosaje/services/api_publication_service.dart';
import 'package:mobile_app_arosaje/services/api_report_service.dart';

class DeletePlant extends StatefulWidget {
  final Map<String, dynamic> map;
  const DeletePlant({super.key, this.map = const {}});

  @override
  State<DeletePlant> createState() => _DeletePlantState();
}

class _DeletePlantState extends State<DeletePlant> {
  @override
  Widget build(BuildContext context) {
    final plant = widget.map['plant'];
    return AlertDialog(
      title: const Text('Supprimer cette plante ?'),
      content:
      const Text('Êtes-vous sûr(e) de vouloir supprimer cette plante ?'
          '\nCette action est irréversible et cela supprimera également'
          ' les publications liées.'),
      actions: [
        TextButton(
            onPressed: () {
              context.pop();
            },
            child: const Text('Annuler')),
        TextButton(
            onPressed: () async {
              List<Publication> publications = await ApiPublicationService.getByUser(User.getCurrent());
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
              ApiPlantService.delete(plant).then((value) {
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Plante supprimée')));
                context.go('/address-management', extra: {'address': plant.address});
              });
            },
            child: const Text('Confirmer'))
      ],
    );
  }
}
