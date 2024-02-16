

import 'package:flutter/cupertino.dart';
import 'package:sharemagazines/src/models/magazinePublishedGetAllLastByHotspotId_model.dart';
import 'package:sharemagazines/src/presentation/pages/reader/readerpage.dart';







CupertinoPageRoute createStartReaderRoute(ResponseMagazine magazine,
 String heroTag) {
  return CupertinoPageRoute(
    builder: (context) => StartReader(
      magazine: magazine,
      heroTag: heroTag,
    ),
  );
}