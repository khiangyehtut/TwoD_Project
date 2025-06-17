import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CustomListContain extends StatelessWidget {
  String? label;
  Widget? icon;
  dynamic secLabel;
  void Function()? onPressed;
  bool? frame;
  Color? color;
  CustomListContain({
    this.color,
    this.icon,
    this.onPressed,
    this.label,
    this.frame,
    this.secLabel,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: (frame ?? false)
              ? const Color.fromARGB(255, 240, 192, 188)
              : Colors.grey,
          width: 2.0,
        ),
      ),
      child: Row(
        children: [
          /// ✅ Wrap `Text` in `Expanded` to prevent overflow
          Expanded(
            flex: 7,
            child: Text(
              label ?? '',
              style: const TextStyle(fontSize: 16),
              overflow: TextOverflow.ellipsis, // ✅ Prevents text overflow
              maxLines: 1, // ✅ Ensures it stays in one line
            ),
          ),

          Expanded(
            flex: 3,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                /// ✅ Use `Flexible` to allow wrapping if needed
                if (secLabel != null)
                  Flexible(
                    child: (secLabel is Widget)
                        ? secLabel
                        : Text(
                            secLabel,
                            style: const TextStyle(fontSize: 14),
                            overflow:
                                TextOverflow.ellipsis, // ✅ Prevents overflow
                          ),
                  ),

                IconButton(
                  onPressed: onPressed,
                  icon: icon ??
                      Icon(
                        Icons.calendar_month,
                        color: (frame ?? false)
                            ? Colors.deepPurple
                            : Colors.black87,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
