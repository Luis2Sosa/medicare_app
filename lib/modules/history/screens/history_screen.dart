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
    final tomados = historyData.where((e) => e['tomado'] == 1).length;
    final omitidos = historyData.length - tomados;

    final clampedTextScaler = MediaQuery.textScalerOf(context).clamp(
      minScaleFactor: 0.9,
      maxScaleFactor: 1.12,
    );

    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaler: clampedTextScaler),
      child: Container(
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
            title: const FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                "Historial",
                style: TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 27,
                ),
              ),
            ),
            actions: [
              Builder(
                builder: (context) {
                  final width = MediaQuery.of(context).size.width;
                  final isSmall = width < 360;

                  return Padding(
                    padding: EdgeInsets.only(right: isSmall ? 8 : 12),
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFEBEE),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: IconButton(
                        tooltip: "Borrar historial",
                        onPressed: _confirmDeleteHistory,
                        icon: Icon(
                          Icons.delete_forever_rounded,
                          color: const Color(0xFFEF5350),
                          size: isSmall ? 28 : 32,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
          body: SafeArea(
            top: false,
            bottom: true,
            child: LayoutBuilder(
              builder: (context, constraints) {
                final r = _Responsive(
                  width: constraints.maxWidth,
                  height: constraints.maxHeight,
                );

                if (isLoading) {
                  return _buildLoadingState();
                }

                if (historyData.isEmpty) {
                  return _emptyState(r);
                }

                return _buildList(tomados, omitidos, r);
              },
            ),
          ),
        ),
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

  Widget _buildList(int tomados, int omitidos, _Responsive r) {
    final bottomSafe = MediaQuery.of(context).padding.bottom;

    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: EdgeInsets.fromLTRB(
            r.pagePadding,
            r.statsPaddingV,
            r.pagePadding,
            r.statsPaddingV,
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
                r: r,
              ),
              SizedBox(width: r.scale(8)),
              _statBadge(
                icon: Icons.cancel_rounded,
                count: omitidos,
                label: "Omitidos",
                color: const Color(0xFFEF4444),
                r: r,
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.fromLTRB(
              r.pagePadding,
              r.listTopPadding,
              r.pagePadding,
              r.listBottomPadding + bottomSafe,
            ),
            itemCount: historyData.length,
            itemBuilder: (context, index) {
              return _historyCard(historyData[index], r);
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
    required _Responsive r,
  }) {
    return Expanded(
      child: Container(
        height: r.statHeight,
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
            Icon(icon, color: color, size: r.statIconSize),
            SizedBox(width: r.scale(8)),
            Flexible(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    count.toString(),
                    style: TextStyle(
                      fontSize: r.font(28),
                      fontWeight: FontWeight.w900,
                      color: color,
                      height: 1,
                    ),
                  ),
                  SizedBox(height: r.scale(3)),
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      label,
                      style: TextStyle(
                        fontSize: r.font(15),
                        fontWeight: FontWeight.w900,
                        color: color,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _historyCard(Map<String, dynamic> item, _Responsive r) {
    final bool tomado = item['tomado'] == 1;
    final Color mainColor =
    tomado ? const Color(0xFF10B981) : const Color(0xFFEF4444);

    return Container(
      margin: EdgeInsets.only(bottom: r.cardBottomMargin),
      padding: EdgeInsets.all(r.cardPadding),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: mainColor.withOpacity(0.45),
          width: 2,
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
                width: r.statusIconBox,
                height: r.statusIconBox,
                decoration: BoxDecoration(
                  color: mainColor,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  tomado ? Icons.check_rounded : Icons.close_rounded,
                  color: Colors.white,
                  size: r.statusIconSize,
                ),
              ),
              SizedBox(width: r.scale(12)),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item['medicamento'] ?? 'Medicamento',
                      style: TextStyle(
                        fontSize: r.font(23),
                        fontWeight: FontWeight.w900,
                        color: const Color(0xFF1E3A5F),
                        height: 1.1,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: r.scale(4)),
                    Text(
                      item['fecha'] ?? '00/00/0000',
                      style: TextStyle(
                        fontSize: r.font(16),
                        color: const Color(0xFF5B7C99),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: r.cardInnerGap),
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(
              vertical: r.timeBoxPaddingV,
              horizontal: 8,
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
                  size: r.scale(24),
                  color: const Color(0xFFF57C00),
                ),
                SizedBox(width: r.scale(8)),
                Flexible(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      item['hora'] ?? '00:00 AM',
                      style: TextStyle(
                        fontSize: r.font(23),
                        fontWeight: FontWeight.w900,
                        color: const Color(0xFFF57C00),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: r.scale(10)),
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(
              vertical: r.statusBoxPaddingV,
              horizontal: 8,
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
                fontSize: r.font(15.5),
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

  Widget _emptyState(_Responsive r) {
    final bottomSafe = MediaQuery.of(context).padding.bottom;

    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.fromLTRB(
            r.pagePadding,
            r.emptyTopPadding,
            r.pagePadding,
            r.emptyBottomPadding + bottomSafe,
          ),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: constraints.maxHeight -
                  r.emptyTopPadding -
                  r.emptyBottomPadding,
            ),
            child: Center(
              child: Container(
                width: double.infinity,
                constraints: BoxConstraints(maxWidth: r.maxContentWidth),
                padding: EdgeInsets.all(r.emptyCardPadding),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.94),
                  borderRadius: BorderRadius.circular(26),
                  border: Border.all(
                    color: const Color(0xFF42A5F5),
                    width: 2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF42A5F5).withOpacity(0.12),
                      blurRadius: 18,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.history_rounded,
                      size: r.emptyIconSize,
                      color: const Color(0xFF1E3A5F),
                    ),
                    SizedBox(height: r.scale(14)),
                    Text(
                      "Sin historial aún",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: r.font(26),
                        fontWeight: FontWeight.w900,
                        color: const Color(0xFF1E3A5F),
                      ),
                    ),
                    SizedBox(height: r.scale(10)),
                    Text(
                      "Aquí aparecerán los medicamentos\nque hayas tomado u omitido.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: r.font(16.5),
                        height: 1.35,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF5B7C99),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _confirmDeleteHistory() {
    final width = MediaQuery.of(context).size.width;
    final isSmallScreen = width < 400;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        insetPadding: EdgeInsets.symmetric(
          horizontal: isSmallScreen ? 18 : 32,
          vertical: 24,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(28),
        ),
        contentPadding: EdgeInsets.fromLTRB(
          isSmallScreen ? 18 : 24,
          isSmallScreen ? 18 : 24,
          isSmallScreen ? 18 : 24,
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
        content: SingleChildScrollView(
          child: Text(
            "Esta acción eliminará todo el historial de medicamentos tomados y omitidos.",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: isSmallScreen ? 14 : 17,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF5B7C99),
              height: 1.4,
            ),
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

class _Responsive {
  final double width;
  final double height;

  const _Responsive({
    required this.width,
    required this.height,
  });

  bool get isTablet => width >= 600;
  bool get compactWidth => width < 360;
  bool get compactHeight => height < 680;

  double get maxContentWidth => isTablet ? 560 : double.infinity;

  double get _factor => _clamp(width / 390, 0.82, 1.16);

  double scale(double base) => base * _factor;

  double font(double base) {
    final eased = 1 + (_factor - 1) * 0.50;
    return base * _clamp(eased, 0.88, 1.10);
  }

  double get pagePadding => compactWidth ? 14 : scale(20);

  double get statsPaddingV => compactHeight ? scale(10) : scale(14);

  double get listTopPadding => compactHeight ? scale(12) : scale(16);

  double get listBottomPadding => compactHeight ? scale(76) : scale(90);

  double get statHeight => compactHeight ? scale(68) : scale(82);

  double get statIconSize => compactHeight ? scale(25) : scale(32);

  double get cardPadding => compactHeight ? scale(12) : scale(17);

  double get cardBottomMargin => compactHeight ? scale(12) : scale(16);

  double get statusIconBox => compactHeight ? scale(46) : scale(56);

  double get statusIconSize => compactHeight ? scale(24) : scale(32);

  double get cardInnerGap => compactHeight ? scale(10) : scale(14);

  double get timeBoxPaddingV => compactHeight ? scale(8) : scale(11);

  double get statusBoxPaddingV => compactHeight ? scale(8) : scale(10);

  double get emptyTopPadding => compactHeight ? scale(28) : scale(44);

  double get emptyBottomPadding => compactHeight ? scale(28) : scale(44);

  double get emptyCardPadding => compactHeight ? scale(22) : scale(28);

  double get emptyIconSize => compactHeight ? scale(58) : scale(74);

  static double _clamp(double value, double min, double max) {
    if (value < min) return min;
    if (value > max) return max;
    return value;
  }
}