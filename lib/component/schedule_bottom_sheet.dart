import 'package:flutter/material.dart';
import 'package:joanda0/component/custom_text_field.dart';
import 'package:joanda0/component/schedule_card.dart';
import 'package:joanda0/const/colors.dart';
import 'package:joanda0/screen/calendar_screen.dart';

class ScheduleBottomSheet extends StatefulWidget {
  final TextEditingController startTimeController;
  final TextEditingController endTimeController;
  final TextEditingController contentController;
  final VoidCallback onSavedPressedbtn;
  static final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  ScheduleBottomSheet(
      {required this.startTimeController,
      required this.endTimeController,
      required this.contentController,
      required this.onSavedPressedbtn,
      super.key});

  @override
  State<ScheduleBottomSheet> createState() => _ScheduleBottomSheetState();
}

class _ScheduleBottomSheetState extends State<ScheduleBottomSheet> {
  int? startTime;
  int? endTime;
  String? content;
  List<List<ScheduleCard>>? scheduleListList;
  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Form(
      key: ScheduleBottomSheet.formKey,
      child: SafeArea(
        child: Container(
          height: MediaQuery.of(context).size.height * 0.5 + bottomInset,
          color: Colors.white,
          child: Padding(
            padding:
                EdgeInsets.only(left: 8, right: 8, top: 8, bottom: bottomInset),
            child: Column(children: [
              Row(
                children: [
                  Expanded(
                    child: CustomTextField(
                        onSaved: (String? val) {
                          startTime = int.parse(val!);
                        },
                        validator: timeValidator,
                        textEditingController: widget.startTimeController,
                        isTime: true,
                        label: 'start time'),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: CustomTextField(
                      onSaved: (String? val) {
                        startTime = int.parse(val!);
                      },
                      validator: timeValidator,
                      textEditingController: widget.endTimeController,
                      isTime: true,
                      label: 'end time',
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8),
              Expanded(
                child: CustomTextField(
                  onSaved: (String? val) {
                    content = val;
                  },
                  validator: contentValidator,
                  textEditingController: widget.contentController,
                  isTime: false,
                  label: 'content',
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: widget.onSavedPressedbtn,
                  child: Text('save'),
                  style: ElevatedButton.styleFrom(
                    primary: PRIMARY_COLOR,
                  ),
                ),
              )
            ]),
          ),
        ),
      ),
    );
  }

  void onSavePressed() {
    if (ScheduleBottomSheet.formKey.currentState!.validate()) {
      ScheduleBottomSheet.formKey.currentState!.save();
    }
  }

  String? timeValidator(String? val) {
    if (val == null || val.isEmpty) {
      return 'Please enter some text';
    }
    if (int.parse(val) > 24 || int.parse(val) < 0) {
      return 'Please enter valid time';
    }
    return null;
  }

  String? contentValidator(String? val) {
    if (val == null || val.isEmpty) {
      return 'Please enter some text';
    }
    return null;
  }
}
