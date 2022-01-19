part of 'widgets.dart';

class CustomButtonOpt extends StatelessWidget {
  final IconData icon;
  final bool update;
  //// Pointer to Update Function
  final Function()? onPressed;
  const CustomButtonOpt(
      {Key? key, this.onPressed, required this.icon, required this.update})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      width: 60,
      child: RaisedButton(
          shape: CircleBorder(),
          color: update == true ? kGreenColor : kRedColor,
          onPressed: onPressed,
          child: Center(
              child: Icon(
            icon,
            color: Colors.white,
          ))),
    );
  }
}
