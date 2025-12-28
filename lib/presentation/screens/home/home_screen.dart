import 'package:asisten_buku_kebun/DI.dart';
import 'package:asisten_buku_kebun/app.dart';
import 'package:asisten_buku_kebun/data/model/crop_log_model.dart';
import 'package:asisten_buku_kebun/data/preferences/app_shared_preferences.dart';
import 'package:asisten_buku_kebun/presentation/common/util/app_toast.dart';
import 'package:asisten_buku_kebun/presentation/resources/app_colors.dart';
import 'package:asisten_buku_kebun/presentation/resources/app_constant.dart';
import 'package:asisten_buku_kebun/presentation/routing/app_routes.dart';
import 'package:asisten_buku_kebun/presentation/routing/app_routing.dart';
import 'package:asisten_buku_kebun/presentation/screens/home/widgets/crop_summary_section.dart';
import 'package:asisten_buku_kebun/presentation/screens/home/widgets/greeting_section.dart';
import 'package:asisten_buku_kebun/presentation/screens/home/widgets/primary_action_section.dart';
import 'package:asisten_buku_kebun/presentation/screens/home/widgets/recent_logs_section.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  final authPresenter = DI.authPresenter;
  final cropPresenter = DI.cropPresenter;
  final cropLogPresenter = DI.cropLogPresenter;
  HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomePageState();
}

class _HomePageState extends State<HomeScreen> with RouteAware {
  String name = "";

  List<CropLogModel> _latestLogs = [];

  Future<void> _fetchLatestLogs() async {
    final userId = widget.authPresenter.loggedInUser?.id;
    if (userId != null) {
      try {
        final logs = await widget.cropLogPresenter.fetchLatestCropLogs(userId);
        // You can use the fetched logs as needed
        if (mounted) {
          setState(() {
            _latestLogs = logs;
          });
        }
      } catch (e) {
        // Handle error
        if (!mounted) return;
        showAppToast(
          context,
          'Terjadi Kesalahan : ${widget.cropLogPresenter.message}',
          title: 'Gagal ❌',
        );
      }
    }
  }

  int totalCrops = 0;
  int sickCrops = 0;
  Future<void> _calculateCropSummary()  async {
    try{
      final userId = widget.authPresenter.loggedInUser?.id;
      if (userId != null) {
        await widget.cropPresenter.fetchMyCrops(userId);
        if(!mounted) return;
        setState(() {
          totalCrops = widget.cropPresenter.myCrops.length;
          sickCrops = widget.cropPresenter.myCrops.where((crop) => crop.cropStatus == AppConstant.CROP_SAKIT).length;
        });
      }
    }catch(e){
      if(!mounted) return;
      showAppToast(
        context,
        'Terjadi Kesalahan : ${widget.cropPresenter.message}',
        title: 'Gagal ❌',
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _checkLogin();
    _fetchLatestLogs();
    _calculateCropSummary();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)!);
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  Future<void> didPopNext() async {
    _fetchLatestLogs();
    _calculateCropSummary();
  }

  int refreshTick = 0;

  Future<void> _checkLogin() async {
    print("checking login");
    final hasLoggedIn = await AppSharedPreferences.containsKey(
      AppSharedPreferences.userModelKey,
    );
    if (!mounted) return;
    if (hasLoggedIn) {
      DI.authPresenter.loggedInUser = await AppSharedPreferences.getUserModel();
      setState(() {
        name = DI.authPresenter.loggedInUser?.name ?? "";
      });
    } else {
      AppRouting().pushReplacement(AppRoutes.login);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Beranda"),
          actions: [
            IconButton(
              color: Colors.red,
              icon: const Icon(Icons.logout),
              onPressed: () async {
                await DI.authPresenter.logout();
                if (!mounted) return;
                AppRouting().pushReplacement(AppRoutes.login);
              },
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: AppColors.primary900,
          foregroundColor: AppColors.white,
          onPressed: () {
            AppRouting().navigateTo(AppRoutes.cropMapScreen);
          },
          child: const Icon(Icons.map),
        ),
        body: RefreshIndicator(
          onRefresh: () async {
            setState(() {
              refreshTick++;
            });
          },
          child: DI.authPresenter.loggedInUser == null
              ? const Center(child: CircularProgressIndicator())
              : Container(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GreetingSection(name: name),
                      const SizedBox(height: 20),
                      CropSummarySection(
                        totalCrops: totalCrops,
                        sickCrops: sickCrops,
                      ),

                      const SizedBox(height: 20),
                      const PrimaryActionsSection(),
                      const SizedBox(height: 24),
                      RecentLogsSection(
                        latestLogs: _latestLogs,
                      ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}
