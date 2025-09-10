import 'package:akshaya_pathara/Global/apptheme.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class FilterBottomSheet extends StatefulWidget {
  final List<String> currentFilters;
  final Color primaryColor;
  final bool addnewfeature;

  FilterBottomSheet({
    this.currentFilters = const [],
    required this.primaryColor,
    this.addnewfeature = false,
  });

  @override
  _FilterBottomSheetState createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  late List<String> categories;
  late String selectedCategory;

  final List<String> leadTypes = ['Buy', 'Sell'];
  final List<String> leadStatusTypes = ['Donated', 'In Progress', 'Failed'];
  final List<String> dateFilterTypes = ['Today', 'Last 7 Days', 'Last 30 Days'];

  Set<String> selectedTypes = {};

  @override
  void initState() {
    super.initState();

    // Initialize categories and default selected category
    categories = [
      'Sort By',
      if (widget.addnewfeature) 'Lead type',
      'Donation Status',
      'Date Filter / Date Range',
    ];

    selectedCategory = widget.addnewfeature ? 'Lead type' : 'Donation Status';
    selectedTypes = widget.currentFilters.toSet();
  }

  List<String> get currentOptions {
    if (selectedCategory == 'Lead type') return leadTypes;
    if (selectedCategory == 'Donation Status') return leadStatusTypes;
    if (selectedCategory == 'Date Filter / Date Range') return dateFilterTypes;
    return [];
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    return Container(
      height: MediaQuery.of(context).size.height * 0.65,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Filters",
                  style: theme.typography.title1.override(
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                    color: Colors.black87,
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.close_rounded,
                    color: Colors.black,
                    size: 20,
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
          Divider(color: Colors.grey, thickness: 0.5, height: 4),
          Expanded(
            child: Row(
              children: [
                /// LEFT SIDE CATEGORY LIST + Clear Filters
                Container(
                  width: 150,
                  color: Colors.grey[100],
                  child: Column(
                    children: [
                      Expanded(
                        child: ListView.builder(
                          itemCount: categories.length,
                          itemBuilder: (_, index) {
                            final cat = categories[index];
                            final selected = cat == selectedCategory;

                            return GestureDetector(
                              onTap: () {
                                if (cat != 'Sort By') {
                                  setState(() {
                                    selectedCategory = cat;
                                  });
                                }
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  vertical: 16,
                                  horizontal: 12,
                                ),
                                decoration: BoxDecoration(
                                  color:
                                      selected && cat != 'Sort By'
                                          ? Colors.white
                                          : Colors.transparent,
                                  border:
                                      selected && cat != 'Sort By'
                                          ? Border(
                                            left: BorderSide(
                                              color: widget.primaryColor,
                                              width: 3,
                                            ),
                                          )
                                          : null,
                                ),
                                child: Text(
                                  cat,
                                  style: theme.typography.bodyText2.override(
                                    color: theme.primaryText,
                                    fontWeight:
                                        cat == 'Sort By'
                                            ? FontWeight.w600
                                            : FontWeight.normal,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(
                          width: double.infinity,
                          child: TextButton(
                            onPressed:
                                () => setState(() => selectedTypes.clear()),
                            child: Text(
                              "Clear Filters",
                              style: theme.typography.bodyText1.override(
                                color: widget.primaryColor,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                /// RIGHT SIDE FILTER OPTIONS + Apply button
                Expanded(
                  child: Column(
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    selectedCategory.toUpperCase(),
                                    style: theme.typography.bodyText1.override(
                                      color: theme.primaryText,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                ],
                              ),
                            ),
                            Expanded(
                              child: ListView.builder(
                                itemCount: currentOptions.length,
                                itemBuilder: (context, index) {
                                  final item = currentOptions[index];
                                  return CheckboxListTile(
                                    value: selectedTypes.contains(item),
                                    onChanged: (value) {
                                      setState(() {
                                        value!
                                            ? selectedTypes.add(item)
                                            : selectedTypes.remove(item);
                                      });
                                    },
                                    title: Text(
                                      item,
                                      style: theme.typography.bodyText1
                                          .override(
                                            color: theme.primaryText,
                                            fontWeight: FontWeight.w400,
                                          ),
                                    ),
                                    activeColor: widget.primaryColor,
                                    controlAffinity:
                                        ListTileControlAffinity.leading,
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Align(
                          alignment: Alignment.center,
                          child: ElevatedButton(
                            onPressed:
                                () => Navigator.pop(
                                  context,
                                  selectedTypes.toList(),
                                ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: widget.primaryColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: Text(
                              "Apply",
                              style: theme.typography.bodyText1.override(
                                color: Colors.white,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class FilterUtils {
  static String getStatusFromItem(dynamic item) {
    String status = '';
    if (item.transcation_status != null) {
      final raw = item.transcation_status.toString().toLowerCase();
      if (raw == 'success') {
        status = 'Donated';
      } else if (raw == 'incomplete') {
        status = 'In Progress';
      } else if (raw == 'failed') {
        status = 'Failed';
      } else if (['success', 'in progress', 'failed'].contains(raw)) {
        status = item.current_status;
      }
    }
    return status;
  }

  static bool checkDateFilter(dynamic item, Set<String> dateFilters) {
    if (item.created_date_formatted == null) return false;

    try {
      DateTime itemDate;

      if (item.created_date_formatted.contains('-') &&
          item.created_date_formatted.contains(':')) {
        itemDate = DateTime.parse(item.created_date_formatted);
      } else {
        itemDate = DateFormat(
          'd MMMM yyyy, hh:mm a',
        ).parse(item.created_date_formatted);
      }

      DateTime now = DateTime.now();
      DateTime today = DateTime(now.year, now.month, now.day);
      DateTime itemDateOnly = DateTime(
        itemDate.year,
        itemDate.month,
        itemDate.day,
      );

      for (String filter in dateFilters) {
        switch (filter) {
          case 'Today':
            if (itemDateOnly == today) return true;
            break;
          case 'Last 7 Days':
            DateTime sevenDaysAgo = today.subtract(Duration(days: 7));
            if (itemDateOnly.isAfter(sevenDaysAgo) ||
                itemDateOnly == sevenDaysAgo)
              return true;
            break;
          case 'Last 30 Days':
            DateTime thirtyDaysAgo = today.subtract(Duration(days: 30));
            if (itemDateOnly.isAfter(thirtyDaysAgo) ||
                itemDateOnly == thirtyDaysAgo)
              return true;
            break;
        }
      }

      return false;
    } catch (e) {
      print('Date parsing error: $e');
      return false;
    }
  }

  /// Reusable method for applying filters to any model list.
  static Map<String, dynamic> applyFilters({
    required List<dynamic> originalList,
    required Set<String> activeFilters,
  }) {
    if (activeFilters.isEmpty) {
      return {'filteredList': List.from(originalList), 'emptyMessage': ''};
    }

    Set<String> statusFilters = {};
    Set<String> dateFilters = {};
    Set<String> leadTypeFilters = {};
    const statusOptions = ['Donated', 'In Progress', 'Failed'];
    const dateOptions = ['Today', 'Last 7 Days', 'Last 30 Days'];
    for (String filter in activeFilters) {
      if (statusOptions.contains(filter)) {
        statusFilters.add(filter);
      } else if (dateOptions.contains(filter)) {
        dateFilters.add(filter);
      }
    }

    /* List<dynamic> filteredList = originalList.where((item) {
      bool statusMatch = statusFilters.isEmpty ||
          statusFilters.contains(getStatusFromItem(item));
      bool dateMatch =
          dateFilters.isEmpty || checkDateFilter(item, dateFilters);
      return statusMatch && dateMatch;
    }).toList();*/
    List<dynamic> filteredList =
        originalList.where((item) {
          bool statusMatch =
              statusFilters.isEmpty ||
              statusFilters.contains(getStatusFromItem(item));
          bool dateMatch =
              dateFilters.isEmpty || checkDateFilter(item, dateFilters);
          bool leadTypeMatch =
              leadTypeFilters.isEmpty ||
              leadTypeFilters.contains(item.lead_category?.toString());

          return statusMatch && dateMatch && leadTypeMatch;
        }).toList();

    // Create user-friendly message
    String dateText = dateFilters.join(', ');
    String statusText = statusFilters.join(', ');
    String leadTypeText = leadTypeFilters.join(', ');

    String emptyMessage = '';
    if (dateText.isNotEmpty ||
        statusText.isNotEmpty ||
        leadTypeText.isNotEmpty) {
      emptyMessage = 'No';
      if (statusText.isNotEmpty) emptyMessage += ' $statusText';
      if (leadTypeText.isNotEmpty) emptyMessage += ' ($leadTypeText)';
      emptyMessage += ' leads found';
      if (dateText.isNotEmpty)
        emptyMessage += ' for the selected period: $dateText';
      emptyMessage += '.';
    } else {
      emptyMessage = 'No leads available for selected filters.';
    }
    return {'filteredList': filteredList, 'emptyMessage': emptyMessage};
  }
}

class FilterBar extends StatelessWidget {
  final Set<String> activeFilters;
  final void Function(Set<String>) onFilterChanged;
  final Color primaryColor;
  final bool addnewfeature;

  const FilterBar({
    Key? key,
    required this.activeFilters,
    required this.onFilterChanged,
    this.primaryColor = Colors.blueAccent,
    this.addnewfeature = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
      child: Row(
        children: [
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children:
                    activeFilters.map((filter) {
                      return GestureDetector(
                        onTap: () {
                          final updatedFilters = Set<String>.from(
                            activeFilters,
                          );
                          updatedFilters.remove(filter);
                          onFilterChanged(updatedFilters);
                        },
                        child: Container(
                          margin: const EdgeInsets.only(right: 6),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: primaryColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: primaryColor, width: 1),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                filter,
                                style: TextStyle(
                                  color: primaryColor,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(width: 4),
                              Icon(Icons.close, size: 12, color: primaryColor),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Align(
              alignment: Alignment.centerRight,
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 2,
                  ),
                  minimumSize: const Size(0, 32),
                  side: BorderSide(color: Colors.grey.shade400),
                  backgroundColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                onPressed: () async {
                  final result = await showModalBottomSheet<List<String>>(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    builder:
                        (context) => FilterBottomSheet(
                          currentFilters: activeFilters.toList(),
                          primaryColor: primaryColor,
                          addnewfeature: addnewfeature,
                        ),
                  );

                  if (result != null) {
                    onFilterChanged(result.toSet());
                  }
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Filter',
                      style: theme.typography.bodyText1.override(
                        color: theme.primaryText,
                        fontWeight: FontWeight.w400,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Icon(
                      Icons.keyboard_arrow_down,
                      size: 16,
                      color: Colors.black,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
