import 'package:asisten_buku_kebun/data/request_state.dart';
import 'package:asisten_buku_kebun/presentation/resources/text_styles_resources.dart';
import 'package:asisten_buku_kebun/presentation/screens/crop/widgets/crop_log_card.dart';
import 'package:asisten_buku_kebun/presenter/crop_log_presenter.dart';
import 'package:flutter/material.dart';

class CropLogSection extends StatelessWidget {
  final CropLogPresenter presenter;

  const CropLogSection({super.key, required this.presenter});

  @override
  Widget build(BuildContext context) {
    if (presenter.requestState == RequestState.loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (presenter.cropLogs.isEmpty) {
      return const _EmptyLogState();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Riwayat Log", style: bold14),
        const SizedBox(height: 12),
        ...presenter.cropLogs.map(
              (log) => CropLogCard(log: log),
        ),
      ],
    );
  }
}

class _EmptyLogState extends StatelessWidget {
  const _EmptyLogState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: const [
          Icon(Icons.inbox, size: 64, color: Colors.grey),
          SizedBox(height: 12),
          Text(
            "Belum ada log tanaman",
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
