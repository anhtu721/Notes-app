import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes_app/cubit/dashboard_cubit.dart';
import 'package:notes_app/state/dashboard_state.dart';
import 'package:notes_app/model/dashboard_data.dart';
import 'package:notes_app/responsitory/dashboard_repository.dart';
import 'package:notes_app/until/navbar.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DashBoardPage extends StatelessWidget {
  const DashBoardPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const NavBar(),
      appBar: AppBar(
        title: const Text('Dashboard'),
      ),
      body: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {

  final _dashboardCubit = DashboardCubit(DashboardRepository());
  String emailController = '';
  bool isChecked =  true;
  bool _isLoading =  true;
  DashboardData? data;

  Future<void> _refresh() async{
    SharedPreferences pref= await SharedPreferences.getInstance();

    setState(() {

      emailController = pref.getString('email')??"";
      _dashboardCubit.getAllDashboard(emailController);
      isChecked = pref.getBool('remember')?? false;
    });
  }

  @override
  void initState() {
    super.initState();
    _refresh();
  }

  final colorList = <Color>[
    const Color(0xfffdcb6e),
    const Color(0xff0984e3),
    const Color(0xfffd79a8),
    const Color(0xffff6f00),
    const Color(0xffc6ff00),
    const Color(0xff26a69a),
    const Color(0xff00e5ff),
    const Color(0xff7b1fa2),
  ];

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: BlocProvider.value(
        value: _dashboardCubit,
        child: BlocBuilder<DashboardCubit, DashboardState>(
          builder: (context, state) {
            if (state is InitialDashboardState || state is LoadingDashboardState){
              return const Center(child: CircularProgressIndicator());
            }else if (state is SuccessLoadAllDashboardState){
              final dashboard = state.dashboardData;
              final info = dashboard.data;
              Map<String, double> data = {
                for (var v in info) v[0]: double.parse('${v[1]}')
              };

              if(data != {} && data.isNotEmpty){
                _isLoading = true;
              }else{
                _isLoading = false;
              }

              return _isLoading
                  ?PieChart(
                dataMap: data,
                animationDuration: const Duration(milliseconds: 800),
                chartLegendSpacing: 32,
                chartRadius: MediaQuery.of(context).size.width / 1.9,
                colorList: colorList,
                initialAngleInDegree: 0,
                chartType: ChartType.disc,
                ringStrokeWidth: 32,
                centerText: "NOTE",
                legendOptions: const LegendOptions(
                  showLegendsInRow: false,
                  legendPosition: LegendPosition.bottom,
                  showLegends: true,
                  legendShape: BoxShape.circle,
                  legendTextStyle: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                chartValuesOptions: const ChartValuesOptions(
                  showChartValueBackground: true,
                  showChartValues: true,
                  showChartValuesInPercentage: true,
                  showChartValuesOutside: false,
                  decimalPlaces: 1,
                ),
                // gradientList: ---To add gradient colors---
                // emptyColorGradient: ---Empty Color gradient---
              ):Center(
                child: Text(
                  'No NOTE',
                  style: Theme.of(context).textTheme.headline3,
                ),
              );
            }else if (state is FailureDashboardState) {
              return Center(child: Text(state.errorMessage));
            }
            return Text(state.toString());
          },
        ),
      ),
    );
  }
}
