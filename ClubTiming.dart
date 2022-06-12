
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:darq/darq.dart';

class ClubTiming extends StatefulWidget {
  const ClubTiming({Key? key}) : super(key: key);

  @override
  _ClubTimingState createState() => _ClubTimingState();
}

class _ClubTimingState extends State<ClubTiming> {

  bool timepickerEnabled = true;
  TimeOfDay? selectedTime = TimeOfDay(hour: 00, minute: 00);
  List<WeekDay> weekdays = [];
  List<OpeningHour> openingHour = [];
  List<WeekDay> allWeekDay = [];
  List<OpeningHour> allDayOpeningHours = [];
  TextEditingController _openTimeController = TextEditingController();
  TextEditingController _closeTimeController = TextEditingController();

  Future selectTime(bool IsStartTime) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: selectedTime!,
      initialEntryMode: TimePickerEntryMode.dial,
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: child ?? Container(),
        );
      },
    );
    if (pickedTime != null && pickedTime != selectedTime) {
      setState(() {
        if (IsStartTime == true){
          _openTimeController.text = pickedTime.to24hours();
          print('open time ${_openTimeController.text}');
        }
        else {
          _closeTimeController.text = pickedTime.to24hours();
          print('close time ${_closeTimeController.text}');
        }
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _startUp();
  }

  void _startUp(){
    //openingHour.add(new OpeningHour(StartTime: '01:00:00', EndTime: '02:00:00'));
    weekdays.add(new WeekDay(IsSelected: false, WeekID: 1, WeekName: 'Monday', openingHours: openingHour),);
    weekdays.add(new WeekDay(IsSelected: false, WeekID: 2, WeekName: 'Tuesday', openingHours: openingHour));
    weekdays.add(new WeekDay(IsSelected: false, WeekID: 3, WeekName: 'Wednesday', openingHours: openingHour));
    weekdays.add(new WeekDay(IsSelected: false, WeekID: 4, WeekName: 'Thursday', openingHours: openingHour));
    weekdays.add(new WeekDay(IsSelected: false, WeekID: 5, WeekName: 'Friday', openingHours: openingHour));
    weekdays.add(new WeekDay(IsSelected: false, WeekID: 6, WeekName: 'Saturday', openingHours: openingHour));
    weekdays.add(new WeekDay(IsSelected: false, WeekID: 7, WeekName: 'Sunday', openingHours: openingHour));
    print(weekdays.length);

    var cd = DateTime.now();
    final startTime = DateTime(cd.year, cd.month, cd.day, 10, 30);
    print(startTime.hour);
    print(startTime.day);
    final endTime = DateTime(cd.year, cd.month, cd.day, 13, 00);
    Duration time1 = new Duration();

    if (startTime.isBefore(endTime)){
      print('fa');
    }
    else if (endTime.isBefore(DateTime.now())){
      print('fagf');
    }

/*    weekdays.forEach((wd) {
      wd.openingHours!.insert(0, new OpeningHour(StartTime: '01:00:00', EndTime: '02:00:00'));
    });*/
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Club Timing'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white,),
          onPressed: () => Navigator.of(context).pop()
        ),
      ),
      body: Container(
        child: Column(
          children: [
            Container(
              child: Column(
                children: [
                  Container(
                    height: 80,
                    padding: new EdgeInsets.only(left: 10.0, right: 10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: _myRadioButton(
                            title: "All Days",
                            value: 0,
                            onChanged: (newValue) => setState(() => _groupValue = newValue ?? -1),
                          ),
                        ),
                        Expanded(
                          child: _myRadioButton(
                            title: "Week Days",
                            value: 1,
                            onChanged: (newValue) => setState(() => _groupValue = newValue ?? -1),
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.info, size: 15),
                        SizedBox(width: 10,),
                        Text(_groupValue == 0 ? 'All week days time will be same.' : 'All week days time will be different.')
                      ],
                    ),
                  ),
                  SizedBox(height: 10,),
                ],
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.height * 0.70,
              child: _groupValue == 0
                  ? AllDayLayout()
                  : WeekDayLayout(),
            )
          ],
        ),
      ),
      bottomSheet: submitBtn(),
    );
  }

  int _groupValue = 0;
  Widget _myRadioButton({required String title, required int value, required Function(int? val) onChanged}) {
    return RadioListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 0),
      activeColor: Colors.red,
      value: value,
      groupValue: _groupValue,
      title: Text(title, style: TextStyle(fontSize: 12),),
      onChanged: onChanged,
    );
  }

  int AllDayItem = 1;
  Widget AllDayLayout(){
    return ListView.builder(
      shrinkWrap: true,
      itemCount: AllDayItem,
        itemBuilder: (BuildContext context, index){
          return Container(
              height: 60,
              child: Row(
                children: [
                  Expanded(
                      child: Container(
                        height: 50,
                        margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
                        color: Colors.white,
                        child: TextFormField(
                          keyboardType: TextInputType.datetime,
                          enabled: this.timepickerEnabled,
                          decoration: InputDecoration(
                            suffixIcon: IconButton(
                              icon: Icon(Icons.calendar_today_rounded, size: 15,),
                              onPressed: () {
                                selectTime(true);
                              },
                            ),
                            border: OutlineInputBorder(
                              borderSide:
                              BorderSide(color: Colors.white),
                              borderRadius:
                              BorderRadius.circular(10.0),
                            ),
                            labelText: 'Open Time',
                            labelStyle: TextStyle(fontSize: 12)
                          ),
                          onTap: () {
                            FocusScope.of(context).requestFocus(new FocusNode());
                          },
                          controller: _openTimeController,
                        ),
                      )
                  ),
                  Expanded(
                      child: Container(
                        height: 50,
                        margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
                        color: Colors.white,
                        child: TextFormField(
                          keyboardType: TextInputType.datetime,
                          enabled: this.timepickerEnabled,
                          decoration: InputDecoration(
                            suffixIcon: IconButton(
                              icon: Icon(Icons.calendar_today_rounded, size: 15,),
                              onPressed: () {
                                selectTime(false);
                              },
                            ),
                            border: OutlineInputBorder(
                              borderSide:
                              BorderSide(color: Colors.white),
                              borderRadius:
                              BorderRadius.circular(10.0),
                            ),
                            labelText: 'Close Time',
                            labelStyle: TextStyle(fontSize: 12)
                          ),
                          onTap: () {
                            FocusScope.of(context).requestFocus(new FocusNode());
                          },
                          controller: _closeTimeController,
                        ),
                      )
                  ),
                  IconButton(
                      onPressed: (){
                        onAllDayClick(index);
                      },
                      icon: Icon(index == 0 ? Icons.add : Icons.remove, color: Colors.red,)
                  )
                ],
              )
          );
        }
    );
  }

  void onAllDayClick(int selectedIndex){
    setState(() {
      if (selectedIndex == 0){
        AllDayItem++;
      }
      else {
        AllDayItem--;
      }
    });
  }

  int WeekDayItem = 1;
  Widget WeekDayLayout(){
    return Container(
      margin: EdgeInsets.all(10),
      child: ListView.builder( // outer ListView
        itemCount: weekdays.length,
        shrinkWrap: true,
        itemBuilder: (_, Dayindex) {
          return Column(
            children: [
              Row(
                //mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Checkbox(
                      value: weekdays[Dayindex].IsSelected,
                      onChanged: (bool? isChecked){
                        setState(() {
                          weekdays[Dayindex].IsSelected = isChecked!;
                        });
                      }),
                  Text(weekdays[Dayindex].WeekName!, style: TextStyle(fontSize: 10),),
                  SizedBox(width: 5,),
                  IconButton(
                      onPressed: () {
                        OnWeekDayClick(Dayindex);
                      },
                      icon: Icon(Icons.add, color: Colors.red,)
                  )
                ],
              ),
              ListView.builder( // inner ListView
                shrinkWrap: true, // 1st add
                physics: ClampingScrollPhysics(), // 2nd add
                itemCount: weekdays[Dayindex].openingHours!.length,
                itemBuilder: (_, slotindex) {
                  return Container(
                      height: 60,
                      child: Row(
                        children: [
                          Expanded(
                              child: Container(
                                height: 50,
                                margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
                                color: Colors.white,
                                child: TextFormField(
                                  keyboardType: TextInputType.datetime,
                                  enabled: this.timepickerEnabled,
                                  decoration: InputDecoration(
                                    suffixIcon: IconButton(
                                      icon: Icon(Icons.calendar_today_rounded, size: 15,),
                                      onPressed: () {
                                        selectTime(true);
                                      },
                                    ),
                                    border: OutlineInputBorder(
                                      borderSide:
                                      BorderSide(color: Colors.white),
                                      borderRadius:
                                      BorderRadius.circular(10.0),
                                    ),
                                    labelText: 'Open Time',
                                    labelStyle: TextStyle(fontSize: 10)
                                  ),
                                  onTap: () {
                                    FocusScope.of(context).requestFocus(new FocusNode());
                                  },
                                  controller: _openTimeController,
                                ),
                              )
                          ),
                          Expanded(
                              child: Container(
                                height: 50,
                                margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
                                color: Colors.white,
                                child: TextFormField(
                                  keyboardType: TextInputType.datetime,
                                  enabled: this.timepickerEnabled,
                                  decoration: InputDecoration(
                                    suffixIcon: IconButton(
                                      icon: Icon(Icons.calendar_today_rounded, size: 15,),
                                      onPressed: () {
                                        selectTime(false);
                                      },
                                    ),
                                    border: OutlineInputBorder(
                                      borderSide:
                                      BorderSide(color: Colors.white),
                                      borderRadius:
                                      BorderRadius.circular(10.0),
                                    ),
                                    labelText: 'Close Time',
                                      labelStyle: TextStyle(fontSize: 10)
                                  ),
                                  onTap: () {
                                    FocusScope.of(context).requestFocus(new FocusNode());
                                  },
                                  controller: _closeTimeController,
                                ),
                              )
                          ),
                          IconButton(
                              onPressed: () {
                                //OnWeekDayClick(Dayindex);
                                },
                              icon: Icon(Icons.remove, color: Colors.red,)
                          )
                        ],
                      )
                  );
                },
              )
            ],
          );
        },
      ),
    );
  }

  void OnWeekDayClick(int DayIndex){
    if (weekdays[DayIndex].IsSelected == false){
      ScaffoldMessenger.of(context)
        ..removeCurrentSnackBar()
        ..showSnackBar(
            SnackBar(content: Text('Select ${weekdays[DayIndex].WeekName} First.')));
    }
    else {
      var wd = weekdays[DayIndex]; // weekdays.where((element) => element.WeekID == weekdays[DayIndex].WeekID).first;
      wd.openingHours!.add(new OpeningHour());
      //weekdays[DayIndex].openingHours!.add(new OpeningHour());
      print('selected day ${ weekdays[DayIndex].WeekName }');
    }
    setState(() {});
  }

  Widget submitBtn() {
    return InkWell(
      onTap: () {},
      child: Container(
        height: 40,
        padding: EdgeInsets.only(bottom: 5.0),
        width: MediaQuery.of(context).size.width,
        margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20), color: Colors.red),
        child: TextButton(
          onPressed: () {},
          child: Text('Save',style: TextStyle(color: Colors.white, fontSize: 13),),
          style: TextButton.styleFrom(
            //padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          ),),
      ),
    );
  }

  bool isNoBallCheck = false;
  Widget TestWeekDayLayout(){
    return ListView.builder(
      shrinkWrap: true,
      itemCount: 7,
        itemBuilder: (BuildContext context, index) {
        return Row(
          children: [
            Expanded(
                child: Container(
                  height: 50,
                  color: Colors.black12,
                  child: Expanded(
                    child: Row(
                      children: [
                        Checkbox(
                            value: isNoBallCheck,
                            onChanged: (bool? isChecked){
                              setState(() {
                                isNoBallCheck = isChecked!;
                              });
                            }),
                        Text('Wednesday', style: TextStyle(fontSize: 10),),
                        Expanded(
                            child: ListView.builder(
                              itemCount: 2,
                                itemBuilder: (BuildContext context, index) {
                                  return Text('item 1');
                                }
                            )
                        ),
                      ],
                    ),
                  ),
                )
            ),
          ],
        );
      }
    );
  }


}


//ModelFiles
class WeekDay
{
  int? ID;
  int? WeekID;
  String? WeekName;
  bool? IsSelected;
  List<OpeningHour>? openingHours;

  WeekDay({this.ID, this.WeekName, this.IsSelected, this.openingHours, this.WeekID}); 
  }
  
  class OpeningHour
{
  int? ID;
  int? VenueID;
  int? ClubID;
  //Venue? Venue;
  int? WeekDay;
  String? StartTime;
  String? EndTime;

  OpeningHour({this.ID, this.VenueID, this.ClubID, this.StartTime, this.EndTime, this.WeekDay});
}
