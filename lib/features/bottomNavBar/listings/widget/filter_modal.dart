import 'package:campusmart/core/utils/my_colors.dart';
import 'package:campusmart/features/bottomNavBar/listings/controller/listing_contr.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class FilterModal extends ConsumerStatefulWidget {
  const FilterModal({super.key});

  @override
  ConsumerState<FilterModal> createState() => _FilterModalState();
}

class _FilterModalState extends ConsumerState<FilterModal> {
  RangeValues? _currentRangeValues;
  final currencyFormat = NumberFormat.currency(symbol: '₦', decimalDigits: 0);

  @override
  Widget build(BuildContext context) {
    // Initialize with current provider value on first build
    _currentRangeValues ??= ref.read(priceRangeFilterProvider);
    
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Price Filter',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: MyColors.darkBase,
                ),
              ),
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.close),
              ),
            ],
          ),
          const SizedBox(height: 20),
          
          // Price Range Display
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Min',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                  Text(
                    currencyFormat.format(_currentRangeValues!.start),
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: MyColors.darkBase,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'Max',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                  Text(
                    currencyFormat.format(_currentRangeValues!.end),
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: MyColors.darkBase,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          // Range Slider
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: MyColors.purpleShade,
              inactiveTrackColor: MyColors.purpleShade.withOpacity(0.2),
              thumbColor: MyColors.purpleShade,
              overlayColor: MyColors.purpleShade.withOpacity(0.2),
              rangeThumbShape: const RoundRangeSliderThumbShape(enabledThumbRadius: 10),
            ),
            child: RangeSlider(
              values: _currentRangeValues!,
              min: 0,
              max: 500000,
              divisions: 50,
              onChanged: (RangeValues values) {
                setState(() {
                  _currentRangeValues = values;
                });
              },
            ),
          ),
          const SizedBox(height: 24),
          
          // Buttons
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    const resetValues = RangeValues(0, 500000);
                    setState(() {
                      _currentRangeValues = resetValues;
                    });
                    ref.read(priceRangeFilterProvider.notifier).state = resetValues;
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: MyColors.darkBase,
                    side: BorderSide(color: Colors.grey[300]!),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Reset'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    ref.read(priceRangeFilterProvider.notifier).state = _currentRangeValues!;
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: MyColors.purpleShade,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Apply Filter'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}