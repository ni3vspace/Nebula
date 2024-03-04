import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nebula/utils/color_constants.dart';
import 'package:nebula/utils/image_constants.dart';
import 'package:nebula/view/home/import_media/import_media_controller.dart';
import 'package:photo_gallery/photo_gallery.dart';

class ImportMediaScreen extends StatelessWidget {
  Size size;
  ImportMediaScreen({Key? key,required this.size}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ImportMediaController controller=Get.find();
    return Container(
      // height: size.height,
      decoration:  BoxDecoration(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(50),
          topRight: Radius.circular(50),
        ),
        color: ColorConstants.back_black,
      ),

      // color: Color.fromARGB(128, 28, 28, 28),
      child: Obx(()=>controller.isLoading.value
          ? Center(
        child: CircularProgressIndicator(),
      )
          : LayoutBuilder(
        builder: (context, constraints) {
          double gridWidth = (constraints.maxWidth - 20) / 3;
          double gridHeight = gridWidth + 33;
          double ratio = gridWidth / gridHeight;
          return Container(
            padding: EdgeInsets.all(5),
            child: GridView.count(
              childAspectRatio: ratio,
              crossAxisCount: 3,
              mainAxisSpacing: 5.0,
              crossAxisSpacing: 5.0,
              children: <Widget>[
                ...?controller.albums.value.map(
                      (album) => GestureDetector(
                    /*onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => AlbumPage(album)),
                    ),*/
                    child: Column(
                      children: <Widget>[
                        ClipRRect(
                          borderRadius: BorderRadius.circular(5.0),
                          child: Container(
                            color: Colors.grey[300],
                            height: gridWidth,
                            width: gridWidth,
                            child: FadeInImage(
                              fit: BoxFit.cover,
                              placeholder: NetworkImage('https://blog.hubspot.com/hs-fs/hubfs/image8-2.jpg?width=600&name=image8-2.jpg'),
                              image: AlbumThumbnailProvider(
                                album: album,
                                highQuality: true,
                              ),
                            ),
                          ),
                        ),
                        Container(
                          alignment: Alignment.topLeft,
                          padding: EdgeInsets.only(left: 2.0),
                          child: Text(
                            album.name ?? "Unnamed Album",
                            maxLines: 1,
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              height: 1.2,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        Container(
                          alignment: Alignment.topLeft,
                          padding: EdgeInsets.only(left: 2.0),
                          child: Text(
                            album.count.toString(),
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              height: 1.2,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      )),
    );
  }
}
