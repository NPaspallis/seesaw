import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'package:seesaw/state_model.dart';

import 'buttons.dart';
import 'main.dart';

class SortProsCons extends StatefulWidget {

  const SortProsCons({super.key});

  @override
  State<StatefulWidget> createState() => _SortProsConsState();
}

enum Bucket { none, pros, cons }

class BucketItem {
  final int id;
  final String label;
  final Bucket correctBucket;

  const BucketItem(this.id, this.label, this.correctBucket);
}

class BucketItemWithColor extends BucketItem {
  final Color color;

  BucketItemWithColor(BucketItem bucketItem, this.color) : super(bucketItem.id, bucketItem.label, bucketItem.correctBucket);
}

class BucketItemWidget extends StatelessWidget {
  const BucketItemWidget({
    super.key,
    required this.bucketItem,
    this.currentBucket = Bucket.none,
    this.isCompleted = false
  });

  final BucketItemWithColor bucketItem;
  final Bucket currentBucket;
  final bool isCompleted;

  @override
  Widget build(BuildContext context) {
    final IconData iconData = isCompleted ? (bucketItem.correctBucket == currentBucket ? Icons.check : Icons.close) : Icons.drag_indicator;
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 5),
        decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            border: Border.all(
              color: bucketItem.color,
              width: 2.0,
            ),
            color: bucketItem.color,
            borderRadius: const BorderRadius.all(Radius.circular(5.0))
        ),
        child: Row (
          children: [
            Expanded(child: Container(color: preparedPrimarySemitransparentColor, padding: const EdgeInsets.only(left: 5), child: Text(bucketItem.label, style: const TextStyle(fontSize: textSizeSmallerer, fontWeight: FontWeight.bold, color: preparedWhiteColor)))),
            const SizedBox(width: 10),
            Icon(iconData, size: 30, color: preparedWhiteColor)
          ],
        )
      )
    );
  }
}

class DraggingListItem extends StatelessWidget {
  const DraggingListItem({
    super.key,
    required this.dragKey,
    required this.bucketItemWithColor
  });

  final GlobalKey dragKey;
  final BucketItemWithColor bucketItemWithColor;

  @override
  Widget build(BuildContext context) {
    return FractionalTranslation(
        translation: const Offset(-0.5, -0.5),
        child: Material(
            key: dragKey,
            // child: Text(bucketItem.label) // todo
          child: Container(
              width: 400,
              padding: const EdgeInsets.symmetric(horizontal: 5),
              decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  border: Border.all(
                    color: bucketItemWithColor.color,
                    width: 2.0,
                  ),
              ),
              child: Text(bucketItemWithColor.label, style: TextStyle(fontWeight: FontWeight.bold, fontSize: textSizeSmaller, color: bucketItemWithColor.color))
          )
            // child: BucketItemWidget(bucketItem: bucketItem),
        )
    );
  }
}

const List<BucketItem> bucketItems = [
  BucketItem(1, 'People take risks all the time and should be able to decide themselves whether to become a study volunteer or not.', Bucket.pros),
  BucketItem(2, 'Human Challenges Studies have the potential to advance medical science quickly.', Bucket.pros),
  BucketItem(3, 'A very large public health threat can justify higher research risks.', Bucket.pros),
  BucketItem(4, 'There is no good rescue therapy for severe forms of COVID-19.', Bucket.cons),
  BucketItem(5, 'Physicians should never impose intentional harm, but they do in human challenge studies.', Bucket.cons),
  BucketItem(6, 'If high amounts are paid for study participation, as in a UK trial, the poor are at risk of being exploited.', Bucket.cons),
];

final List<Color> bucketItemColors = [
  preparedCyanColor,
  preparedOrangeColor,
  preparedBrightRedColor,
  preparedRedColor,
  preparedDarkRedColor,
  preparedBlueColor,
];

class _SortProsConsState extends State<SortProsCons> {

  final List<BucketItemWithColor> bucketPros = [];
  final List<BucketItemWithColor> bucketCons = [];
  final List<BucketItemWithColor> bucketNone = [];

  @override
  void initState() {
    super.initState();
    bucketItemColors.shuffle();
    for(int i = 0; i < bucketItems.length; i++) {
      bucketNone.add(BucketItemWithColor(bucketItems[i], bucketItemColors[i]));
    }
    bucketNone.shuffle();
  }

  @override
  Widget build(BuildContext context) {

    return SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height * 2 / 3,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const Padding(
                padding: EdgeInsets.symmetric(horizontal: 160),
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text('Are you ready to start a short information gathering and decision-making process on Human Challenge Studies?',
                      style: TextStyle(
                          fontSize: textSizeLarge,
                          color: preparedWhiteColor,
                          decoration: TextDecoration.none), textAlign: TextAlign.center),
                )),
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _getBucket(Bucket.pros, 'PROS', preparedSecondaryColor.withAlpha(100)),
                _getItemsColumn(),
                _getBucket(Bucket.cons, 'CONS', Colors.red.shade300.withAlpha(175)),
              ],
            ),
            bucketNone.isNotEmpty ?
              getOutlinedButton(context, 'SKIP', proceed, preparedSecondaryColor) :
              getElevatedButton(context, 'CARRY ON', proceed, preparedSecondaryColor)
          ],
        ));
  }

  final GlobalKey _draggableKey = GlobalKey();

  Widget _buildBucketItemDraggableView(BucketItemWithColor bucketItem) {
    return LongPressDraggable<BucketItem>(
      data: bucketItem,
      delay: const Duration(milliseconds: 100),
      dragAnchorStrategy: pointerDragAnchorStrategy,
      feedback: DraggingListItem(dragKey: _draggableKey, bucketItemWithColor: bucketItem),
      childWhenDragging: BucketItemWidget(bucketItem: bucketItem),
      child: BucketItemWidget(bucketItem: bucketItem),
    );
  }

  Widget _getItemsColumn() {
// <<<<<<< Updated upstream
//     final List<Widget> bucketItemWidgets = [
//       const Padding(
//           padding: EdgeInsets.symmetric(vertical: 10),
//           child: FittedBox(
//             fit: BoxFit.fitWidth,
//             child: Text('Press and hold on each item, then drag it to the correct bucket.',
//               style: TextStyle(fontSize: textSizeMedium, color: preparedWhiteColor)),
//           )
//       )
//     ];
// =======
    final List<Widget> bucketItemWidgets = [];
    if(bucketNone.isNotEmpty) {
      bucketItemWidgets.add(const Padding(
          padding: EdgeInsets.all(10),
          child: FittedBox(
            child: Text('Press and hold on each item, then drag it to the correct bucket.',
                style: TextStyle(fontSize: textSizeLarge, fontStyle: FontStyle.italic, color: preparedWhiteColor)),
          )
      ));
    }
// >>>>>>> Stashed changes
    for(int i = 0; i < bucketNone.length; i++) {
      bucketItemWidgets.add(_buildBucketItemDraggableView(bucketNone[i]));
    }

    final ScrollController itemsScrollController = ScrollController();

    return SizedBox(
        width: MediaQuery.of(context).size.width / 3,
// <<<<<<< Updated upstream
//         height: MediaQuery.of(context).size.height / 2,
//         child: RawScrollbar(
//           thumbColor: Colors.white,
//           thumbVisibility: true,
//           controller: itemsScrollController,
//           child: SingleChildScrollView(
//             controller: itemsScrollController,
//             child: Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 20.0),
//               child: Column(
//                   mainAxisAlignment: MainAxisAlignment.start,
//                   children: bucketItemWidgets
//               ),
//             ),
//           ),
// =======
        child: Column(
            children: bucketItemWidgets
// >>>>>>> Stashed changes
        )
    );
  }

  Widget _getBucket(Bucket bucket, String title, Color color) {

    ScrollController scrollController = ScrollController();

    return SizedBox(
      width: MediaQuery.of(context).size.width / 3,
      height: MediaQuery.of(context).size.height / 2,
      child: DragTarget<BucketItemWithColor>(
        builder: (context, candidateItems, rejectedItems) {
          List<Widget> bucketWidgets = (bucket == Bucket.pros ? bucketPros : bucketCons).map((bucketItem) => BucketItemWidget(bucketItem: bucketItem, currentBucket: bucket, isCompleted: true)).toList();
          return Padding(
            padding: const EdgeInsets.all(20),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  color: color,
                  border: Border.all(
                    color: Colors.white,
                    width: 5.0,
                  ),
                  borderRadius: const BorderRadius.all(Radius.circular(10.0))
              ),
              alignment: Alignment.topCenter,
              child: RawScrollbar(
                controller: scrollController,
                thumbVisibility: true,
                thumbColor: Colors.white,
                child: SingleChildScrollView(
                  controller: scrollController,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(title, style: const TextStyle(fontSize: textSizeMedium, fontWeight: FontWeight.w900, color: Colors.white), textAlign: TextAlign.center),
                      const Gap(20),
                      ...bucketWidgets
                    ],
                  ),
                ),
              )
            ),
          );
        },
        onAcceptWithDetails: (bucketItemWithDragTargetDetails) => _bucketItemDroppedOnBucket(bucketItemWithDragTargetDetails, bucket)
      ),
    );
  }

  void _bucketItemDroppedOnBucket(DragTargetDetails<BucketItemWithColor> bucketItemWithDragTargetDetails, Bucket bucket) {
    BucketItemWithColor bucketItem = bucketItemWithDragTargetDetails.data;
    setState(() {
      bucketNone.remove(bucketItem);
      debugPrint('adding ${bucketItem.id} to $bucket');
      (bucket == Bucket.pros ? bucketPros : bucketCons).add(bucketItem);
    });
  }

  void proceed() {
    Provider.of<StateModel>(context, listen: false).progressToNextSeesawState();
  }
}