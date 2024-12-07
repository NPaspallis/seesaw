import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'package:seesaw/state_model.dart';

import 'buttons.dart';
import 'main.dart';

class SortProsConsTriage extends StatefulWidget {

  const SortProsConsTriage({super.key});

  @override
  State<StatefulWidget> createState() => _SortProsConsTriageState();
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
  BucketItem(1, 'It is important to treat patients immediately when they require care. Treating patients as they come in, recognizes this idea.', Bucket.pros),
  BucketItem(2, 'It is wrong to discriminate among patients based on characteristics like age. Treating patients as they arrive avoids discrimination based on such characteristics.', Bucket.pros),
  BucketItem(3, 'Treating patients as they arrive, until the last ICU bed is filled, can be an egalitarian way of dividing healthcare, since it is only concerned with immediate need.', Bucket.pros),
  BucketItem(4, 'People should not just be treated as they arrive since some people (e.g., with higher social-economic status) may be able to reach hospitals and health services more quickly.', Bucket.cons),
  BucketItem(5, 'It would be fair to give people who have not had a good shot at a full life (i.e., younger people) priority to maximize everyone\'s chances at a good life.', Bucket.cons),
  BucketItem(6, 'If people are treated as they come in, valuable resources are wasted, for instance when patients with a worse prognosis happen to arrive slightly earlier than others.', Bucket.cons),
  BucketItem(7, 'If one were to prioritize healthcare workers who come in, one might be able to ensure that more people can be rescued and lead full lives.', Bucket.cons),
];

final List<Color> bucketItemColors = [
  preparedCyanColor,
  preparedOrangeColor,
  preparedBrightRedColor,
  preparedRedColor,
  preparedDarkRedColor,
  preparedBlueColor,
  preparedPurpleColor,
];

class _SortProsConsTriageState extends State<SortProsConsTriage> {

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
        height: MediaQuery.of(context).size.height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const Padding(
                padding: EdgeInsets.symmetric(horizontal: 160),
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text('Are you ready to start a short information gathering and decision-making process on access to ICU beds during pandemics?',
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
    for(int i = 0; i < bucketNone.length; i++) {
      bucketItemWidgets.add(_buildBucketItemDraggableView(bucketNone[i]));
    }

    final ScrollController itemsScrollController = ScrollController();

    return SizedBox(
        width: MediaQuery.of(context).size.width / 3,
        child: Column(
            children: bucketItemWidgets
        )
    );
  }

  Widget _getBucket(Bucket bucket, String title, Color color) {

    ScrollController scrollController = ScrollController();

    return SizedBox(
      width: MediaQuery.of(context).size.width / 3,
      height: MediaQuery.of(context).size.height * 2 / 3,
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