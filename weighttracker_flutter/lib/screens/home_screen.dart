// ignore_for_file: prefer_const_constructors_in_immutables

import 'package:weighttracker_flutter/models/user.dart';
import 'package:weighttracker_flutter/models/weight.dart';
import 'package:weighttracker_flutter/screens/login_screen.dart';
import 'package:weighttracker_flutter/widgets/toast.dart';
import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:jiffy/jiffy.dart';

import '../config.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isLoading = true;
  List<WeightElement> _weightsHistory = [];
  late Map _user;
  late WeightElement selectWeight;
  WeightElement _weight = WeightElement(
    id: '',
    unit: '',
    weight: 0,
    userId: '',
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
  );

  @override
  void initState() {
    super.initState();
    _weight.getAll().then((value) {
      setState(() {
        _isLoading = false;
        _weightsHistory = value;
      });
    });
  }

  void _addWeight(weight, id) {
    setState(() {
      _isLoading = true;
    });

    if (id != null) {
      _weight.update({"weight": weight, "unit": "kg", "id": id}).then(
          (value) => setState(() {
                print("done up");
                _isLoading = false;
                int index = _weightsHistory.indexWhere((elem) => elem.id == id);
                _weightsHistory[index].weight = int.parse(weight);
              }));
    } else {
      _weight.save({"weight": weight, "unit": "kg"}).then((value) => {
            setState(() {
              //   print(value);
              _isLoading = false;
              _weightsHistory.add(value);
            })
          });
    }
  }

  void _deleteWeight(int index, String id) {
    setState(() {
      _isLoading = true;
    });
    _weight.delete(id).then((value) => {
          if (value == true)
            {
              setState(() {
                _isLoading = false;
                _weightsHistory.removeAt(index);
              })
            }
        });
  }

  void _promptRemoveWeightItem(int index) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: Text(
                  'Are you sure you want to delete ${_weightsHistory[index].weight} ?'),
              actions: <Widget>[
                FlatButton(
                    child: Text('Cancel'),
                    onPressed: () => Navigator.of(context).pop()),
                FlatButton(
                    child: const Text('Delete'),
                    onPressed: () {
                      _deleteWeight(index, _weightsHistory[index].id);
                      Navigator.of(context).pop();
                    })
              ]);
        });
  }

  Widget _buildWeightList() {
    return ListView.builder(
      itemCount: _weightsHistory != null ? _weightsHistory.length : 0,
      itemBuilder: (context, index) {
        return _buildWeightItem(_weightsHistory[index], index);
      },
    );
  }

  Widget _buildWeightItem(WeightElement weightObj, int index) {
    return ListTile(
      title: Text("${weightObj.weight} ${weightObj.unit}"),
      subtitle: Text(
          "${Jiffy(weightObj.createdAt).format('MMM do yyyy, h:mm:ss a')}"),
      trailing: Wrap(
        spacing: 12,
        children: <Widget>[
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              setState(() => _weight = weightObj);
              _pushAddWeightScreen();
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () => _promptRemoveWeightItem(index),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Scaffold(
        appBar: AppBar(
            title: Text('weight List'),
            backgroundColor: primaryColor,
            actions: [
              FlatButton(
                onPressed: () {
                  _weight.logout().then((value) {
                    if (value == true) {
                      Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                              builder: (BuildContext context) => LoginScreen()),
                          (Route<dynamic> route) => false);
                    } else {
                      toast("Something went wrong", "error");
                    }
                  });
                },
                child: Text("Logout", style: TextStyle(color: whiteColor)),
              ),
            ]),
        body: _buildWeightList(),
        floatingActionButton: FloatingActionButton(
            backgroundColor: primaryColor,
            onPressed: () {
              setState(() => _weight = WeightElement(
                    id: '',
                    unit: '',
                    weight: 0,
                    userId: '',
                    createdAt: DateTime.now(),
                    updatedAt: DateTime.now(),
                  ));
              _pushAddWeightScreen();
            },
            tooltip: 'Add weight',
            child: _isLoading ? CircularProgressIndicator() : Icon(Icons.add)),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      ),
    );
  }

  void _pushAddWeightScreen() {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return Scaffold(
          appBar: AppBar(
            title: Text('Add weight'),
            backgroundColor: primaryColor,
          ),
          body: TextField(
            autofocus: true,
            controller: TextEditingController(
                text: _weight.weight != null ? _weight.weight.toString() : ""),
            keyboardType: TextInputType.number,
            onSubmitted: (val) {
              _addWeight(val, _weight.id);
              Navigator.pop(context);
            },
            decoration: InputDecoration(
                hintText: 'Kg', contentPadding: const EdgeInsets.all(16.0)),
          ));
    }));
  }
}
