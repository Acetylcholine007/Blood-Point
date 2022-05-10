import 'package:blood_point/screens/subPages/LocationPicker.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../models/AccountData.dart';
import '../../services/AuthService.dart';
import '../../shared/constants.dart';
import '../../shared/decorations.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({Key key}) : super(key: key);

  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _formKey = GlobalKey<FormState>();
  final AuthService _auth = AuthService();

  Set<Marker> _markers = {Marker(markerId: MarkerId("location"), position: LatLng(45.521563, -122.677433))};
  LatLng target = const LatLng(45.521563, -122.677433);
  String email = '';
  String password = '';
  String fullName = '';
  String username = '';
  String address = 'Anilao';
  String contactNo = '';
  String bloodType = 'O+';
  double latitude = 14;
  double longitude = 120;
  bool isDonor = false;
  bool showPassword = true;
  bool loading = false;
  String error = '';
  DateTime birthday;
  TextEditingController controller = TextEditingController();

  GoogleMapController mapController;

  void markerChangeHandler(LatLng coordinates) {
    setState(() {
      target = coordinates;
      _markers = {Marker(markerId: MarkerId("location"), position: coordinates)};
    });
  }

  void submitHandler() async {
    if(_formKey.currentState.validate()) {
      setState(() => loading = true);
      String result = await _auth.register(
        AccountData(
          fullName: this.fullName,
          username: this.username,
          address: this.address,
          contactNo: this.contactNo,
          bloodType: this.bloodType,
          isDonor: this.isDonor,
          latitude: this.target.latitude,
          longitude: this.target.longitude
        ),
        email,
        password
      );
      if(result == 'SUCCESS') {
        setState(() {
          loading = false;
        });
        showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('Email Verification'),
              content: Text('Verification Email was sent into your account. Please verify first before logging in.'),
              actions: [
                TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text('OK')
                )
              ],
            )
        );
      } else {
        setState(() {
          error = result;
          loading = false;
        });
        showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('Sign In'),
              content: Text(error),
              actions: [
                TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text('OK')
                )
              ],
            )
        );
      }
    } else {
      final snackBar = SnackBar(
        duration: Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        content: Text('Fill up all the fields'),
        action: SnackBarAction(label: 'OK', onPressed: () => ScaffoldMessenger.of(context).hideCurrentSnackBar()),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  @override
  void initState() {
    controller.text = "";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.all(16),
      child: SingleChildScrollView(
        physics: ClampingScrollPhysics(),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                initialValue: fullName,
                decoration: formFieldDecoration.copyWith(hintText: 'Full Name'),
                validator: (val) => val.isEmpty ? 'Enter Full Name' : null,
                onChanged: (val) => setState(() => fullName = val)
              ),
              SizedBox(height: 10),
              TextFormField(
                initialValue: username,
                decoration: formFieldDecoration.copyWith(hintText: 'Username'),
                validator: (val) => val.isEmpty ? 'Enter Username' : null,
                onChanged: (val) => setState(() => username = val)
              ),
              SizedBox(height: 10),
              DropdownButtonFormField(
                isExpanded: true,
                menuMaxHeight: 300,
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => LocationPicker(target, _markers, markerChangeHandler))),
                value: address,
                decoration: dropdownDecoration.copyWith(prefixIcon: Icon(Icons.location_on_rounded)),
                items: municipalities.asMap().entries.map((filter) => DropdownMenuItem(
                  value: filter.value,
                  child: Text(filter.value, overflow: TextOverflow.ellipsis),
                )).toList(),
                onChanged: (value) => setState(() => address = value),
              ),
              SizedBox(height: 10),
              TextFormField(
                  initialValue: contactNo,
                  decoration: formFieldDecoration.copyWith(hintText: 'Contact No'),
                  validator: (val) => val.isEmpty ? 'Enter Contact No' : val.length != 11 ? 'Phone number length should only be 11' : null,
                  onChanged: (val) => setState(() => contactNo = val)
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: controller,
                enableInteractiveSelection: false,
                onTap: (){
                  FocusScope.of(context).requestFocus(new FocusNode());
                  showDatePicker(
                    context: context,
                    initialDate: birthday == null ? DateTime(DateTime.now().year - 4) : birthday,
                    firstDate: DateTime(1970),
                    lastDate: DateTime(DateTime.now().year - 4),
                  ).then((pickedDate) {
                    if (pickedDate == null) {
                      return;
                    }
                    setState(() {
                      birthday = pickedDate;
                      controller.text = dateFormatter.format(pickedDate);
                    });
                  });
                },
                decoration: formFieldDecoration.copyWith(hintText: 'Birthday', suffixIcon: Icon(Icons.calendar_today_rounded)),
                validator: (val) => val.isEmpty ? 'Enter Birthday' : null,
              ),
              SizedBox(height: 10),
              TextFormField(
                initialValue: email,
                decoration: formFieldDecoration.copyWith(hintText: 'Email'),
                validator: (val) => val.isEmpty ? 'Enter Email' : null,
                onChanged: (val) => setState(() => email = val)
              ),
              SizedBox(height: 10),
              TextFormField(
                initialValue: password,
                decoration: formFieldDecoration.copyWith(suffixIcon: IconButton(
                    onPressed: () => setState(() => showPassword = !showPassword),
                    icon: Icon(Icons.visibility)
                ),
                    hintText: 'Password'
                ),
                validator: (val) => val.isEmpty ? 'Enter Password' : null,
                onChanged: (val) => setState(() => password = val),
                obscureText: showPassword,
              ),
              SizedBox(height: 10),
              Row(
                children: [Expanded(flex: 6, child: DropdownButtonFormField(
                  value: bloodType,
                  decoration: dropdownDecoration.copyWith(prefixIcon: Icon(Icons.bloodtype_rounded)),
                  items: bloodTypes.asMap().entries.map((filter) => DropdownMenuItem(
                    value: filter.value,
                    child: Text(filter.value, overflow: TextOverflow.ellipsis),
                  )).toList(),
                  onChanged: (value) => setState(() => bloodType = value),
                )),
                  SizedBox(width: 10),
                  Expanded(flex: 4, child: Text('Set as donor')),
                  Expanded(flex: 2, child: Switch(value: isDonor, onChanged: (val) => setState(() => isDonor = val)))
                ],
              ),
              SizedBox(height: 10),
              Divider(
                thickness: 1,
                height: 25,
                color: theme.primaryColorDark,
              ),
              ElevatedButton(
                child: Text('SIGN UP'),
                onPressed: submitHandler,
                style: formButtonDecoration,
              ),
              TextButton(
                child: Text('Already have account? Sign in'),
                onPressed: () => Navigator.pop(context)
              )
            ],
          ),
        ),
      )
      );
  }
}
