import 'package:flutter/material.dart';
import 'package:medicare_app/core/app_theme.dart';
import 'package:medicare_app/core/database/app_database.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  List<Map<String, dynamic>> historyData = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    final data = await AppDatabase.instance.getHistory();

    if (!mounted) return;

    setState(() {
      historyData = data;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.width < 400;

    final tomados = historyData.where((e) => e['tomado'] == 1).length;
    final omitidos = historyData.length - tomados;

    return Container(
      decoration: const BoxDecoration(
        gradient: AppTheme.mainGradient,
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.white,
          foregroundColor: const Color(0xFF1E3A5F),
          elevation: 0,
          centerTitle: true,
          title: Text(
            "Historial",
            style: TextStyle(
              fontWeight: FontWeight.w900,
              fontSize: isSmallScreen ? 23 : 27,
            ),
          ),
          actions: [
            Padding(
              padding: EdgeInsets.only(right: isSmallScreen ? 8 : 12),
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFFFEBEE),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: IconButton(
                  onPressed: _confirmDeleteHistory,
                  icon: Icon(
                    Icons.delete_forever_rounded,
                    color: const Color(0xFFEF5350),
                    size: isSmallScreen ? 28 : 35,
                  ),
                ),
              ),
            ),
          ],
        ),
        body: isLoading
            ? _buildLoadingState()
            : historyData.isEmpty
            ? _emptyState(isSmallScreen)
            : _buildList(tomados, omitidos, isSmallScreen),
      ),
    );
  }

  Widget _buildLoadingState() {
    return const Center(
      child: CircularProgressIndicator(
        color: Color(0xFF42A5F5),
      ),
    );
  }

  Widget _buildList(int tomados, int omitidos, bool isSmallScreen) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: EdgeInsets.fromLTRB(
            isSmallScreen ? 14 : 20,
            isSmallScreen ? 10 : 14,
            isSmallScreen ? 14 : 20,
            isSmallScreen ? 10 : 14,
          ),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.45),
          ),
          child: Row(
            children: [
              _statBadge(
                icon: Icons.check_circle_rounded,
                count: tomados,
                label: "Tomados",
                color: const Color(0xFF10B981),
                isSmallScreen: isSmallScreen,
              ),
              SizedBox(width: isSmallScreen ? 8 : 12),
              _statBadge(
                icon: Icons.cancel_rounded,
                count: omitidos,
                label: "Omitidos",
                color: const Color(0xFFEF4444),
                isSmallScreen: isSmallScreen,
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: EdgeInsets.fromLTRB(
              isSmallScreen ? 14 : 20,
              isSmallScreen ? 12 : 16,
              isSmallScreen ? 14 : 20,
              isSmallScreen ? 70 : 90,
            ),
            itemCount: historyData.length,
            itemBuilder: (context, index) {
              return _historyCard(historyData[index], isSmallScreen);
            },
          ),
        ),
      ],
    );
  }

  Widget _statBadge({
    required IconData icon,
    required int count,
    required String label,
    required Color color,
    required bool isSmallScreen,
  }) {
    return Expanded(
      child: Container(
        height: isSmallScreen ? 70 : 86,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.92),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: color.withOpacity(0.55),
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.12),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: isSmallScreen ? 26 : 34),
            SizedBox(width: isSmallScreen ? 8 : 12),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  count.toString(),
                  style: TextStyle(
                    fontSize: isSmallScreen ? 22 : 30,
                    fontWeight: FontWeight.w900,
                    color: color,
                    height: 1,
                  ),
                ),
                SizedBox(height: isSmallScreen ? 2 : 4),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: isSmallScreen ? 13 : 16,
                    fontWeight: FontWeight.w900,
                    color: color,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _historyCard(Map<String, dynamic> item, bool isSmallScreen) {
    final bool tomado = item['tomado'] == 1;
    final Color mainColor =
    tomado ? const Color(0xFF10B981) : const Color(0xFFEF4444);

    return Container(
      margin: EdgeInsets.only(bottom: isSmallScreen ? 12 : 16),
      padding: EdgeInsets.all(isSmallScreen ? 12 : 18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: mainColor.withOpacity(0.45),
          width: 2.2,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1E3A5F).withOpacity(0.08),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: isSmallScreen ? 48 : 58,
                height: isSmallScreen ? 48 : 58,
                decoration: BoxDecoration(
                  color: mainColor,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  tomado ? Icons.check_rounded : Icons.close_rounded,
                  color: Colors.white,
                  size: isSmallScreen ? 24 : 34,
                ),
              ),
              SizedBox(width: isSmallScreen ? 12 : 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item['medicamento'] ?? 'Medicamento',
                      style: TextStyle(
                        fontSize: isSmallScreen ? 18 : 25,
                        fontWeight: FontWeight.w900,
                        color: const Color(0xFF1E3A5F),
                        height: 1.1,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: isSmallScreen ? 4 : 6),
                    Text(
                      item['fecha'] ?? '00/00/0000',
                      style: TextStyle(
                        fontSize: isSmallScreen ? 14 : 18,
                        color: const Color(0xFF5B7C99),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: isSmallScreen ? 10 : 14),
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(
              vertical: isSmallScreen ? 8 : 12,
            ),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF3E0),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: const Color(0xFFFF9800),
                width: 2,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.access_time_rounded,
                  size: isSmallScreen ? 20 : 27,
                  color: const Color(0xFFF57C00),
                ),
                SizedBox(width: isSmallScreen ? 8 : 10),
                Text(
                  item['hora'] ?? '00:00 AM',
                  style: TextStyle(
                    fontSize: isSmallScreen ? 18 : 24,
                    fontWeight: FontWeight.w900,
                    color: const Color(0xFFF57C00),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: isSmallScreen ? 10 : 12),
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(
              vertical: isSmallScreen ? 8 : 11,
            ),
            decoration: BoxDecoration(
              color: mainColor.withOpacity(0.10),
              borderRadius: BorderRadius.circular(15),
              border: Border.all(
                color: mainColor.withOpacity(0.45),
                width: 2,
              ),
            ),
            child: Text(
              tomado ? "MEDICAMENTO TOMADO" : "NO SE TOMÓ",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: isSmallScreen ? 13 : 17,
                fontWeight: FontWeight.w900,
                color: mainColor,
                letterSpacing: 0.2,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _emptyState(bool isSmallScreen) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Center(
        child: Container(
          margin: EdgeInsets.all(isSmallScreen ? 20 : 28),
          padding: EdgeInsets.all(isSmallScreen ? 20 : 26),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.94),
            borderRadius: BorderRadius.circular(26),
            border: Border.all(
              color: const Color(0xFF42A5F5),
              width: 2,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.history_rounded,
                size: isSmallScreen ? 60 : 76,
                color: const Color(0xFF1E3A5F),
              ),
              SizedBox(height: isSmallScreen ? 14 : 18),
              Text(
                "Sin historial aún",
                style: TextStyle(
                  fontSize: isSmallScreen ? 22 : 28,
                  fontWeight: FontWeight.w900,
                  color: const Color(0xFF1E3A5F),
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: isSmallScreen ? 8 : 10),
              Text(
                "Aquí aparecerán tus medicamentos tomados u omitidos.",
                style: TextStyle(
                  fontSize: isSmallScreen ? 15 : 18,
                  color: const Color(0xFF5B7C99),
                  fontWeight: FontWeight.w700,
                  height: 1.4,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _confirmDeleteHistory() {
    final isSmallScreen = MediaQuery.of(context).size.width < 400;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(28),
        ),
        contentPadding: EdgeInsets.fromLTRB(
          isSmallScreen ? 20 : 24,
          isSmallScreen ? 20 : 24,
          isSmallScreen ? 20 : 24,
          isSmallScreen ? 16 : 20,
        ),
        title: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.delete_forever_rounded,
              color: const Color(0xFFEF5350),
              size: isSmallScreen ? 44 : 56,
            ),
            SizedBox(height: isSmallScreen ? 10 : 12),
            Text(
              "Borrar historial",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: isSmallScreen ? 20 : 24,
                fontWeight: FontWeight.w900,
                color: const Color(0xFF1E3A5F),
              ),
            ),
          ],
        ),
        content: Text(
          "Esta acción eliminará todo el historial de medicamentos tomados y omitidos.",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: isSmallScreen ? 14 : 17,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF5B7C99),
            height: 1.4,
          ),
        ),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              "Cancelar",
              style: TextStyle(
                fontSize: isSmallScreen ? 14 : 17,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFEF5350),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            onPressed: () async {
              Navigator.pop(context);

              await AppDatabase.instance.deleteAllHistory();

              await _loadHistory();

              if (!mounted) return;

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Historial eliminado correctamente"),
                  backgroundColor: Color(0xFFEF5350),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            child: Text(
              "Eliminar",
              style: TextStyle(
                fontWeight: FontWeight.w900,
                fontSize: isSmallScreen ? 14 : 16,
              ),
            ),
          ),
        ],
      ),
    );
  }
}