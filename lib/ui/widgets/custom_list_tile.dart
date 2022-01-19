part of 'widgets.dart';

class CustomListTile extends StatelessWidget {
  final String title;
  final String description;
  //// Pointer to Update Function
  final Function? onUpdate;
  //// Pointer to Delete Function
  final Function? onDelete;

  CustomListTile(this.title, this.description,
      {Key? key, this.onUpdate, this.onDelete})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      padding: const EdgeInsets.only(top: 10, bottom: 10, left: 8, right: 8),
      decoration: BoxDecoration(
        color: kPrimaryColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.5,
                child: Text(
                  title,
                  style:
                      blackTextStyle.copyWith(fontSize: 16, fontWeight: bold),
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.5,
                child: Text(
                  description,
                  style: blackTextStyle.copyWith(color: Colors.black54),
                ),
              )
            ],
          ),
          Row(
            children: [
              CustomButtonOpt(
                  update: true,
                  icon: Icons.edit,
                  onPressed: () {
                    if (onUpdate != null) onUpdate!();
                  },
                ),
              CustomButtonOpt(
                  update: false,
                  icon: Icons.delete,
                  onPressed: () {
                    if (onDelete != null) onDelete!();
                  },
                ),
            ],
          )
        ],
      ),
    );
  }
}
