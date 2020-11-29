
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class AddTagChip extends HookWidget {

  final Function(String) onSubmit;
  AddTagChip({@required this.onSubmit});

  @override
  Widget build(BuildContext context) {
    var controller = useTextEditingController();
    final editing = useState<bool>(false);
    if (editing.value) {
      return Container(
          constraints: BoxConstraints(
            minWidth: 100,
            maxHeight: 40,
          ),
          padding: EdgeInsets.only(
            left: 10,
            right: 10,
          ),
          decoration: BoxDecoration(
            color: Colors.orange,
            borderRadius: BorderRadius.all(Radius.circular(20)),
          ),
          child: IntrinsicWidth(
              child: TextField(
                autofocus: true,
                textAlignVertical: TextAlignVertical.center,
                controller: controller,
                cursorColor: Colors.white,
                onSubmitted: (x) {
                  editing.value = false;
                  if (x == '') {
                    return;
                  }

                  onSubmit(x.toLowerCase());
                  controller.clear();
                },
                decoration: InputDecoration(
                  border: InputBorder.none,
                  suffixIcon: IconButton(
                    iconSize: 20,
                    icon: Icon(Icons.clear),
                    color: Colors.white,
                    onPressed: () {
                      controller.clear();
                      editing.value = false;
                    },
                  )
                ),
              )
          )
      );
    }

    return Container(
      child: ElevatedButton(
        child: Icon(Icons.add),
        onPressed:() => editing.value = true,
        style: ButtonStyle(
          shape: MaterialStateProperty.all(RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          )),
          elevation: MaterialStateProperty.all(0),
          backgroundColor: MaterialStateProperty.all<Color>(Color(0xff494949)),
        )
      )
    );
  }
}