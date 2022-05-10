import 'package:flutter/material.dart';

class HelpPage extends StatelessWidget {
  const HelpPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.all(16),
      child: ListView(
        children: [
          Text('Blood Donation Procedures', style: theme.textTheme.headline5),
          Divider(height: 25, color: theme.primaryColorDark),
          Text('Before', style: theme.textTheme.headline6),
          ListTile(
            leading: CircleAvatar(
              radius: 16,
              child: Text('1'),
            ),
            title: Text('Schedule an appointment at your own convenience'),
            subtitle: Text('Select a donation type and find a convenient time that works best for you.'),
          ),
          ListTile(
            leading: CircleAvatar(
              radius: 16,
              child: Text('2'),
            ),
            title: Text('Eat fiber-rich food'),
            subtitle: Text('Have iron-rich foods, such as red meat, fish, poultry, beans, spinach, iron-fortified cereals, or raisins.'),
          ),
          ListTile(
            leading: CircleAvatar(
              radius: 16,
              child: Text('3'),
            ),
            title: Text('Take a good rest and hydrate'),
            subtitle: Text('Get a good night\'s sleep the night before your donation, eat healthy foods and drink extra liquids.'),
          ),
          Divider(height: 25, color: theme.primaryColorDark),
          Text('During', style: theme.textTheme.headline6),
          ListTile(
            leading: CircleAvatar(
              radius: 16,
              child: Text('1'),
            ),
            title: Text('Fill out Donor’s form.'),
          ),
          ListTile(
            leading: CircleAvatar(
              radius: 16,
              child: Text('2'),
            ),
            title: Text('Submit fulfilled form to the Medical Technologist on duty.'),
          ),
          ListTile(
            leading: CircleAvatar(
              radius: 16,
              child: Text('3'),
            ),
            title: Text('Medical Technologists will call donors one by one for an initial interview.'),
            subtitle: Text('Example interview:' +
            '\n•	Name, Age, Birthday' +
            '\n•	Coughs/Colds' +
            '\n•	Hours of sleep' +
            '\n•	Alcohol intake or any medication' +
            '\n•	Blood pressure' +
            '\n•	Temperature' +
            '\n•	Pulse Rate'
            ),
          ),
          ListTile(
            leading: CircleAvatar(
              radius: 16,
              child: Text('4'),
            ),
            title: Text('If the donor passed the initial interview, he/she will be tested for hemoglobin and blood type.'),
            subtitle: Text('Hemoglobin required for female: 12.5 mg/dL' +
                '\nHemoglobin required for male: 13.0 mg/dL'),
          ),
          ListTile(
            leading: CircleAvatar(
              radius: 16,
              child: Text('5'),
            ),
            title: Text('If the donor passed, he/she will be given their own blood bag labeled with their donor number, blood type, Rh factor, expiration and extraction date.'),
          ),
          ListTile(
            leading: CircleAvatar(
              radius: 16,
              child: Text('6'),
            ),
            title: Text('The donor’s blood will then be extracted.'),
          ),
          ListTile(
            leading: CircleAvatar(
              radius: 16,
              child: Text('7'),
            ),
            title: Text('After the blood bag is full, the donors must rest 5 to 10 minutes.'),
          ),
          Divider(height: 25, color: theme.primaryColorDark),
          Text('After', style: theme.textTheme.headline6),
          ListTile(
            leading: CircleAvatar(
              radius: 16,
              child: Text('1'),
            ),
            title: Text('After donating, you sit in an observation area, where you rest and eat a light snack. After 15 minutes, you can leave. After your blood donation:'),
            subtitle: Text(
              '•	Drink extra fluids.' +
              '\n•	Avoid strenuous physical activity or heavy\n  lifting for about five hours.' +
              '\n•	If you feel lightheaded, lie down with your\n  feet up until the feeling passes.' +
              '\n•	Keep your bandage on and dry for the next\n  five hours.' +
              '\n•	If you have bleeding after removing the\n  bandage, put pressure on the site and raise\n  your arm until the bleeding stops.' +
              '\n•	If bruising occurs, apply a cold pack to the\n  area periodically during the first 24 hours.' +
              '\n•	Consider adding iron-rich foods to your diet\n  to replace the iron lost with blood donation.' +
              '\n•	Contact the blood donor center or your\n  doctor if you:' +
              '\n•	Forgot to report any important health\n  information.' +
              '\n•	Have signs and symptoms of an illness, such\n  as a fever, within several days after your\n  blood donation.' +
              '\n•	Are diagnosed with COVID-19 within 48 hours\n  after donating blood.'
              ),
          ),
          Divider(height: 25, color: theme.primaryColorDark),
          Text('Source:', style: theme.textTheme.subtitle2.copyWith(fontStyle: FontStyle.italic)),
          Text('https://www.redcrossblood.org/donate-blood/blood-donation-process/before-during-after.html', style: theme.textTheme.caption.copyWith(fontStyle: FontStyle.italic)),
          Text('https://www.mayoclinic.org/tests-procedures/blood-donation/about/pac-20385144', style: theme.textTheme.caption.copyWith(fontStyle: FontStyle.italic)),
        ],
      ),
    );
  }
}
