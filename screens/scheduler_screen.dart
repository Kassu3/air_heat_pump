// Käyttäjä voi valita päivän ja kellonajan

import 'package:flutter/material.dart';
import 'package:mi_smart_ac/utils/translations.dart';
import '../widgets/app_colors.dart';

class SchedulerScreen extends StatefulWidget {
  final String currentLanguage;
  final Function(String) onLanguageChanged;
  final VoidCallback? onSaveSuccess;

  const SchedulerScreen(
      {super.key,
      required this.currentLanguage,
      required this.onLanguageChanged,
      this.onSaveSuccess});

  @override
  State<SchedulerScreen> createState() => _SchedulerScreenState();
}

class _SchedulerScreenState extends State<SchedulerScreen> {
  // Alustetaan dynaamiset päivämäärät ja kellonajat
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _startTime = const TimeOfDay(hour: 08, minute: 00);
  TimeOfDay _endTime = const TimeOfDay(hour: 16, minute: 00);

  final Map<String, bool> _days = {
    'sche_mon': true,
    'sche_tue': true,
    'sche_wed': true,
    'sche_thu': true,
    'sche_fri': true,
    'sche_sat': false,
    'sche_sun': false
  };

  // KALENTERIVALITSIN
  Future<void> _pickDate() async {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate:
          DateTime.now().add(const Duration(days: 365)), // Vuosi eteenpäin
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(
                  primary: isDark
                      ? AppColors.darkTemperatureRing1
                      : AppColors.lightTemperatureRing2,
                  onPrimary:
                      isDark ? AppColors.dropdownColor : AppColors.lightText,
                ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedDate) {
      setState(() => _selectedDate = picked);
    }
  }

  // KELLONAJAN VALITSIN (Yleiskäyttöinen funktio aloitukselle ja lopetukselle)
  Future<void> _pickTime(bool isStartTime) async {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: isStartTime ? _startTime : _endTime,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(
                  primary: AppColors.modeColor,
                  onPrimary:
                      isDark ? AppColors.dropdownColor : AppColors.lightText,
                ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        if (isStartTime) {
          _startTime = picked;
        } else {
          _endTime = picked;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final colorScheme = Theme.of(context).colorScheme;

    final List<Color> activeGradient = isDark
        ? [AppColors.darkTemperatureRing1, AppColors.darkTemperatureRing2]
        : [AppColors.lightTemperatureRing1, AppColors.lightTemperatureRing2];

    final Color onGradientText =
        isDark ? AppColors.dropdownColor : AppColors.lightText;

    // Muotoillaan suomalainen päivämäärä esitystä varten
    String formattedDate =
        "${_selectedDate.day}.${_selectedDate.month}.${_selectedDate.year}";

    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppTranslations.translate(widget.currentLanguage, 'sche_title'),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              AppTranslations.translate(widget.currentLanguage, 'sche_add_new'),
            ),
            const SizedBox(height: 20),

            // 1. KALENTERIKORTTI (Dynaaminen päivämäärän valinta)
            GestureDetector(
              onTap: _pickDate,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerHigh,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: colorScheme.outlineVariant),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.calendar_month_outlined,
                          color: AppColors.markEco,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          AppTranslations.translate(
                              widget.currentLanguage, 'sche_add_day'),
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          formattedDate,
                          style: const TextStyle(
                            fontSize: 16,
                            color: AppColors.markEco,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Icon(
                          Icons.arrow_drop_down,
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // 2. KAKSOISKELLONAJAT (Aloitus- ja Lopetusaika rinnakkain)
            Row(
              children: [
                // ALOITUSAIKA -KORTTI
                Expanded(
                  child: GestureDetector(
                    onTap: () => _pickTime(true),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: colorScheme.surfaceContainerHigh,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: colorScheme.outlineVariant),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(
                                Icons.play_circle_outline,
                                color: AppColors.scheduleStarttime,
                                size: 18,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                AppTranslations.translate(
                                    widget.currentLanguage, 'sche_time1'),
                                style: TextStyle(
                                  color: colorScheme.onSurfaceVariant,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            _startTime.format(context),
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: AppColors.scheduleStarttime,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),

                // LOPETUSAIKA -KORTTI
                Expanded(
                  child: GestureDetector(
                    onTap: () => _pickTime(false),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: colorScheme.surfaceContainerHigh,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: colorScheme.outlineVariant),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(
                                Icons.stop_circle,
                                color: AppColors.scheduleEndtime,
                                size: 18,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                AppTranslations.translate(
                                    widget.currentLanguage, 'sche_time2'),
                                style: TextStyle(
                                  color: colorScheme.onSurfaceVariant,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            _endTime.format(context),
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: AppColors.scheduleEndtime,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 32),
            Text(
              AppTranslations.translate(widget.currentLanguage, 'sche_days'),
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),

            // 3. VIIKONPÄIVÄPAINIKKEET
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: _days.keys.map((day) {
                bool isSel = _days[day]!;
                return GestureDetector(
                  onTap: () => setState(() => _days[day] = !isSel),
                  child: Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: isSel
                          ? null
                          : (isDark
                              ? colorScheme.surfaceContainerHigh
                              : AppColors.lightText),
                      gradient: isSel
                          ? LinearGradient(
                              colors: activeGradient,
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            )
                          : null,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isSel
                            ? Colors.transparent
                            : colorScheme.outlineVariant,
                      ),
                      boxShadow: isSel
                          ? [
                              BoxShadow(
                                color: activeGradient.first
                                    .withValues(alpha: 0.35),
                                blurRadius: 8,
                                offset: Offset(0, 3),
                              ),
                            ]
                          : null,
                    ),
                    child: Center(
                      child: Text(
                        AppTranslations.translate(widget.currentLanguage, day),
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: isSel
                              ? onGradientText
                              : colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),

            const Spacer(),

            // TALLENNUSPAINIKE
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                gradient: LinearGradient(
                  colors: activeGradient,
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: activeGradient.first.withValues(alpha: 0.35),
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: ElevatedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                          "${AppTranslations.translate(widget.currentLanguage, 'sche_set')} $_selectedDate, ${_startTime.format(context)} - ${_endTime.format(context)}"),
                    ),
                  );
                  if (widget.onSaveSuccess != null) {
                    widget.onSaveSuccess!();
                  }
                },
                icon: const Icon(
                  Icons.calendar_today_outlined,
                ),
                label: Text(
                  AppTranslations.translate(widget.currentLanguage, 'sche_btn'),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  foregroundColor: onGradientText,
                  padding: const EdgeInsets.all(16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
