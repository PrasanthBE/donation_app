import 'package:akshaya_pathara/Global/apptheme.dart';
import 'package:akshaya_pathara/Pages/my_account.dart';
import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:shared_preferences/shared_preferences.dart'
    show SharedPreferences;

class CharityHierarchyPage extends StatefulWidget {
  final List<Map<String, dynamic>> indianCitizenshipDetails;
  final void Function(bool success)? onSubmitted;
  CharityHierarchyPage(
    this.indianCitizenshipDetails, {
    this.onSubmitted,
    Key? key,
  }) : super(key: key);

  @override
  CharityHierarchyPageState createState() => CharityHierarchyPageState();
}

class CharityHierarchyPageState extends State<CharityHierarchyPage> {
  // Global key for form validation
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Validation error messages
  String? categoryError;
  String? subcategoryError;
  String? programError;
  String? regionError;

  final Map<String, dynamic> charityData = {
    "charity_hierarchy": [
      {
        "category_id": "c1",
        "category": "Education",
        "subcategories": [
          {
            "subcategory_id": "sc1",
            "name": "School Infrastructure",
            "programs": [
              {
                "program_id": "p1",
                "name": "Adopt a School Program",
                "regions": [
                  {"region_id": "r1", "name": "Karnataka"},
                  {"region_id": "r2", "name": "Rural Maharashtra"},
                ],
              },
              {
                "program_id": "p2",
                "name": "Rebuild Classrooms",
                "regions": [
                  {"region_id": "r3", "name": "Tamil Nadu"},
                  {"region_id": "r4", "name": "Odisha"},
                ],
              },
            ],
          },
          {
            "subcategory_id": "sc2",
            "name": "Scholarships",
            "programs": [
              {"program_id": "p3", "name": "Bright Future Scholarships"},
              {
                "program_id": "p4",
                "name": "Girls Higher Education Fund",
                "regions": [
                  {"region_id": "r6", "name": "Uttar Pradesh"},
                  {"region_id": "r7", "name": "West Bengal"},
                ],
              },
            ],
          },
          {
            "subcategory_id": "sc3",
            "name": "Digital Learning",
            "programs": [
              {
                "program_id": "p5",
                "name": "Smart Classrooms Initiative",
                "regions": [
                  {"region_id": "r8", "name": "Punjab"},
                  {"region_id": "r9", "name": "Delhi NCR"},
                ],
              },
              {
                "program_id": "p6",
                "name": "Computer Lab Setup",
                "regions": [
                  {"region_id": "r10", "name": "Maharashtra"},
                  {"region_id": "r11", "name": "Andhra Pradesh"},
                ],
              },
            ],
          },
        ],
      },
      {
        "category_id": "c2",
        "category": "Health & Nutrition",
        "subcategories": [
          {
            "subcategory_id": "sc4",
            "name": "Cancer Support",
            "programs": [
              {
                "program_id": "p7",
                "name": "Mobile Cancer Screening Vans",
                "regions": [
                  {"region_id": "r12", "name": "Maharashtra"},
                ],
              },
              {
                "program_id": "p8",
                "name": "Awareness Camps",
                "regions": [
                  {"region_id": "r13", "name": "Kerala"},
                  {"region_id": "r14", "name": "Punjab"},
                ],
              },
            ],
          },
          {
            "subcategory_id": "sc5",
            "name": "Mental Health",
            "programs": [
              {
                "program_id": "p9",
                "name": "Community Wellness Workshops",
                "regions": [
                  {"region_id": "r15", "name": "Maharashtra"},
                  {"region_id": "r16", "name": "Karnataka"},
                ],
              },
              {
                "program_id": "p10",
                "name": "Therapy Access Program",
                "regions": [
                  {"region_id": "r17", "name": "Goa"},
                  {"region_id": "r18", "name": "Gujarat"},
                ],
              },
            ],
          },
          {
            "subcategory_id": "sc6",
            "name": "Sanitation",
            "programs": [
              {
                "program_id": "p11",
                "name": "Clean Toilets for All",
                "regions": [
                  {"region_id": "r19", "name": "Rural Maharashtra"},
                ],
              },
              {
                "program_id": "p12",
                "name": "Hygiene Awareness Drive",
                "regions": [
                  {"region_id": "r20", "name": "Bihar"},
                  {"region_id": "r21", "name": "Jharkhand"},
                ],
              },
            ],
          },
          {
            "subcategory_id": "sc7",
            "name": "Mobile Clinics",
            "programs": [
              {
                "program_id": "p13",
                "name": "Health on Wheels",
                "regions": [
                  {"region_id": "r22", "name": "Sikkim"},
                ],
              },
              {
                "program_id": "p14",
                "name": "Village Health Vans",
                "regions": [
                  {"region_id": "r23", "name": "Chhattisgarh"},
                  {"region_id": "r24", "name": "MP"},
                ],
              },
            ],
          },
        ],
      },
      {
        "category_id": "c3",
        "category": "Environment",
        "subcategories": [
          {
            "subcategory_id": "sc8",
            "name": "Tree Plantation",
            "programs": [
              {
                "program_id": "p15",
                "name": "Green India Drive",
                "regions": [
                  {"region_id": "r25", "name": "Karnataka"},
                  {"region_id": "r26", "name": "North-East India"},
                ],
              },
              {
                "program_id": "p16",
                "name": "Urban Forests Program",
                "regions": [
                  {"region_id": "r27", "name": "Delhi"},
                  {"region_id": "r28", "name": "Hyderabad"},
                ],
              },
            ],
          },
          {
            "subcategory_id": "sc9",
            "name": "Water Conservation",
            "programs": [
              {
                "program_id": "p17",
                "name": "Clean Ganga Campaign",
                "regions": [
                  {"region_id": "r29", "name": "Uttar Pradesh"},
                  {"region_id": "r30", "name": "Bihar"},
                ],
              },
              {
                "program_id": "p18",
                "name": "Rainwater Harvesting",
                "regions": [
                  {"region_id": "r31", "name": "Rajasthan"},
                  {"region_id": "r32", "name": "Haryana"},
                ],
              },
            ],
          },
          {
            "subcategory_id": "sc10",
            "name": "Waste Management",
            "programs": [
              {
                "program_id": "p19",
                "name": "Zero Waste Homes",
                "regions": [
                  {"region_id": "r33", "name": "Tier-2/3 cities"},
                ],
              },
              {
                "program_id": "p20",
                "name": "Plastic-Free Campaign",
                "regions": [
                  {"region_id": "r34", "name": "Kerala"},
                  {"region_id": "r35", "name": "Mizoram"},
                ],
              },
            ],
          },
        ],
      },
      {
        "category_id": "c4",
        "category": "Women Empowerment",
        "subcategories": [
          {
            "subcategory_id": "sc11",
            "name": "Self-Help Groups",
            "programs": [
              {
                "program_id": "p21",
                "name": "SHG Formation Drive",
                "regions": [
                  {"region_id": "r36", "name": "Tamil Nadu"},
                  {"region_id": "r37", "name": "West Bengal"},
                ],
              },
            ],
          },
          {
            "subcategory_id": "sc12",
            "name": "Menstrual Hygiene",
            "programs": [
              {
                "program_id": "p22",
                "name": "Sanitary Kit Distribution",
                "regions": [
                  {"region_id": "r38", "name": "Uttar Pradesh"},
                ],
              },
            ],
          },
          {
            "subcategory_id": "sc13",
            "name": "Livelihood Skills",
            "programs": [
              {
                "program_id": "p23",
                "name": "Tailoring Training",
                "regions": [],
              },
              {
                "program_id": "p24",
                "name": "Digital Literacy for Women",
                "regions": [
                  {"region_id": "r39", "name": "Andhra Pradesh"},
                ],
              },
            ],
          },
        ],
      },
      {
        "category_id": "c5",
        "category": "Child Welfare",
        "subcategories": [
          {
            "subcategory_id": "sc14",
            "name": "Nutrition Programs",
            "programs": [
              {
                "program_id": "p25",
                "name": "Mid-Day Meals Support",
                "regions": [],
              },
            ],
          },
          {
            "subcategory_id": "sc15",
            "name": "Orphan Support",
            "programs": [
              {
                "program_id": "p26",
                "name": "Orphanage Assistance Program",
                "regions": [
                  {"region_id": "r40", "name": "All India"},
                ],
              },
            ],
          },
          {
            "subcategory_id": "sc16",
            "name": "Child Safety",
            "programs": [
              {
                "program_id": "p27",
                "name": "Childline Support",
                "regions": [
                  {"region_id": "r41", "name": "Mumbai"},
                  {"region_id": "r42", "name": "Chennai"},
                ],
              },
            ],
          },
        ],
      },
      {
        "category_id": "c6",
        "category": "Animal Welfare",
        "subcategories": [
          {
            "subcategory_id": "sc17",
            "name": "Animal Shelter",
            "programs": [
              {
                "program_id": "p28",
                "name": "Pet Rescue Operations",
                "regions": [],
              },
            ],
          },
          {
            "subcategory_id": "sc18",
            "name": "Street Animal Care",
            "programs": [
              {
                "program_id": "p29",
                "name": "Stray Dog Vaccination",
                "regions": [
                  {"region_id": "r43", "name": "Delhi NCR"},
                ],
              },
            ],
          },
        ],
      },
      {
        "category_id": "c7",
        "category": "Disaster Relief",
        "subcategories": [
          {
            "subcategory_id": "sc19",
            "name": "Emergency Supplies",
            "programs": [
              {
                "program_id": "p30",
                "name": "Flood Relief Kits",
                "regions": [
                  {"region_id": "r44", "name": "Assam"},
                  {"region_id": "r45", "name": "Odisha"},
                ],
              },
            ],
          },
          {
            "subcategory_id": "sc20",
            "name": "Temporary Shelter",
            "programs": [
              {
                "program_id": "p31",
                "name": "Cyclone Relief Camps",
                "regions": [],
              },
            ],
          },
        ],
      },
      {
        "category_id": "c8",
        "category": "Skill Development",
        "subcategories": [
          {
            "subcategory_id": "sc21",
            "name": "Vocational Training",
            "programs": [
              {
                "program_id": "p32",
                "name": "Electrician Certification",
                "regions": [],
              },
            ],
          },
          {
            "subcategory_id": "sc22",
            "name": "IT Skills",
            "programs": [
              {
                "program_id": "p33",
                "name": "Basic Computer Course",
                "regions": [
                  {"region_id": "r46", "name": "Gujarat"},
                ],
              },
            ],
          },
        ],
      },
      {
        "category_id": "c9",
        "category": "Sports & Youth Empowerment",
        "subcategories": [
          {
            "subcategory_id": "sc23",
            "name": "Rural Sports",
            "programs": [
              {
                "program_id": "p34",
                "name": "Khelo India Outreach",
                "regions": [
                  {"region_id": "r47", "name": "Punjab"},
                ],
              },
            ],
          },
          {
            "subcategory_id": "sc24",
            "name": "Leadership Training",
            "programs": [
              {
                "program_id": "p35",
                "name": "Youth Leaders Bootcamp",
                "regions": [],
              },
            ],
          },
        ],
      },
      {
        "category_id": "c10",
        "category": "Rural Development",
        "subcategories": [
          {
            "subcategory_id": "sc25",
            "name": "Infrastructure",
            "programs": [
              {
                "program_id": "p36",
                "name": "Road Construction Aid",
                "regions": [
                  {"region_id": "r48", "name": "Jharkhand"},
                ],
              },
            ],
          },
          {
            "subcategory_id": "sc26",
            "name": "Village Sanitation",
            "programs": [
              {
                "program_id": "p37",
                "name": "Toilet Building Campaign",
                "regions": [],
              },
            ],
          },
        ],
      },
    ],
  };

  // Selected values with IDs
  Map<String, String>? selectedCategory; // {id, name}
  Map<String, String>? selectedSubcategory;
  Map<String, String>? selectedProgram;
  Map<String, String>? selectedRegion;

  // Lists for dropdowns
  List<Map<String, String>> categories = [];
  List<Map<String, String>> subcategories = [];
  List<Map<String, String>> programs = [];
  List<Map<String, String>> regions = [];

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  void _loadCategories() {
    final hierarchy = charityData['charity_hierarchy'] as List;
    categories =
        hierarchy.map((e) {
          return {
            'id': e['category_id'] as String,
            'name': e['category'] as String,
          };
        }).toList();
  }

  void _onCategoryChanged(Map<String, String>? category) {
    setState(() {
      selectedCategory = category;
      selectedSubcategory = null;
      selectedProgram = null;
      selectedRegion = null;
      subcategories.clear();
      programs.clear();
      regions.clear();
      categoryError = null; // Clear error when selection changes

      if (category != null) {
        _loadSubcategories(category['id']!);
      }
    });
  }

  void _loadSubcategories(String categoryId) {
    final hierarchy = charityData['charity_hierarchy'] as List;
    final categoryData = hierarchy.firstWhere(
      (element) => element['category_id'] == categoryId,
    );

    if (categoryData['subcategories'] != null) {
      subcategories =
          (categoryData['subcategories'] as List).map((e) {
            return {
              'id': e['subcategory_id'] as String,
              'name': e['name'] as String,
            };
          }).toList();
    }
  }

  void _onSubcategoryChanged(Map<String, String>? subcategory) {
    setState(() {
      selectedSubcategory = subcategory;
      selectedProgram = null;
      selectedRegion = null;
      programs.clear();
      regions.clear();
      subcategoryError = null; // Clear error when selection changes

      if (subcategory != null && selectedCategory != null) {
        _loadPrograms(selectedCategory!['id']!, subcategory['id']!);
      }
    });
  }

  void _loadPrograms(String categoryId, String subcategoryId) {
    final hierarchy = charityData['charity_hierarchy'] as List;
    final categoryData = hierarchy.firstWhere(
      (element) => element['category_id'] == categoryId,
    );

    final subcategoryData = (categoryData['subcategories'] as List).firstWhere(
      (element) => element['subcategory_id'] == subcategoryId,
    );

    if (subcategoryData['programs'] != null) {
      programs =
          (subcategoryData['programs'] as List).map((e) {
            return {
              'id': e['program_id'] as String,
              'name': e['name'] as String,
            };
          }).toList();
    }
  }

  void _onProgramChanged(Map<String, String>? program) {
    setState(() {
      selectedProgram = program;
      selectedRegion = null;
      regions.clear();
      programError = null; // Clear error when selection changes

      if (program != null &&
          selectedCategory != null &&
          selectedSubcategory != null) {
        _loadRegions(
          selectedCategory!['id']!,
          selectedSubcategory!['id']!,
          program['id']!,
        );
      }
    });
  }

  void _loadRegions(String categoryId, String subcategoryId, String programId) {
    final hierarchy = charityData['charity_hierarchy'] as List;
    final categoryData = hierarchy.firstWhere(
      (element) => element['category_id'] == categoryId,
    );

    final subcategoryData = (categoryData['subcategories'] as List).firstWhere(
      (element) => element['subcategory_id'] == subcategoryId,
    );

    final programData = (subcategoryData['programs'] as List).firstWhere(
      (element) => element['program_id'] == programId,
    );

    if (programData['regions'] != null) {
      regions =
          (programData['regions'] as List).map((e) {
            return {
              'id': e['region_id'] as String,
              'name': e['name'] as String,
            };
          }).toList();
    }
  }

  void _onRegionChanged(Map<String, String>? region) {
    setState(() {
      selectedRegion = region;
      regionError = null;
    });
  }

  // Validation function
  /* bool _validateForm() {
    bool isValid = true;

    setState(() {
      // Reset all errors
      categoryError = null;
      subcategoryError = null;
      programError = null;
      regionError = null;

      // Validate category (always required)
      if (selectedCategory == null) {
        categoryError = "Please select a category";
        isValid = false;
        return; // Don't proceed with further validation if category is not selected
      }

      // Find the category data in JSON
      final hierarchy = charityData['charity_hierarchy'] as List;
      final categoryData = hierarchy.firstWhere(
        (element) => element['category_id'] == selectedCategory!['id'],
        orElse: () => null,
      );

      if (categoryData == null) {
        isValid = false;
        return;
      }

      // Check if category has subcategories
      if (categoryData.containsKey('subcategories') &&
          categoryData['subcategories'] != null &&
          (categoryData['subcategories'] as List).isNotEmpty) {
        // Subcategory is required
        if (selectedSubcategory == null) {
          subcategoryError = "Please select a subcategory";
          isValid = false;
          return;
        }

        // Find subcategory data
        final subcategoryData = (categoryData['subcategories'] as List)
            .firstWhere(
              (element) =>
                  element['subcategory_id'] == selectedSubcategory!['id'],
              orElse: () => null,
            );

        if (subcategoryData == null) {
          isValid = false;
          return;
        }

        // Check if subcategory has programs
        if (subcategoryData.containsKey('programs') &&
            subcategoryData['programs'] != null &&
            (subcategoryData['programs'] as List).isNotEmpty) {
          // Program is required
          if (selectedProgram == null) {
            programError = "Please select a program";
            isValid = false;
            return;
          }

          // Find program data
          final programData = (subcategoryData['programs'] as List).firstWhere(
            (element) => element['program_id'] == selectedProgram!['id'],
            orElse: () => null,
          );

          if (programData == null) {
            isValid = false;
            return;
          }

          // Check if program has regions
          if (programData.containsKey('regions') &&
              programData['regions'] != null &&
              (programData['regions'] as List).isNotEmpty) {
            // Region is required
            if (selectedRegion == null) {
              regionError = "Please select a region";
              isValid = false;
            }
          }
        }
      }
    });

    return isValid;
  }*/
  /*  bool _validateForm() {
    bool isValid = true;
    setState(() {
      // Reset all errors
      categoryError = null;
      subcategoryError = null;
      programError = null;
      regionError = null;

      // Validate category (always required)
      if (selectedCategory == null) {
        categoryError = "Please select a category";
        isValid = false;
        return;
      }

      // Find the category data in JSON
      final hierarchy = charityData['charity_hierarchy'] as List;
      Map<String, dynamic>? categoryData;

      try {
        categoryData =
            hierarchy.firstWhere(
                  (element) =>
                      element['category_id'] == selectedCategory!['id'],
                )
                as Map<String, dynamic>;
      } catch (e) {
        // Category not found
        isValid = false;
        return;
      }

      // Check if category has subcategories
      if (categoryData.containsKey('subcategories') &&
          categoryData['subcategories'] != null &&
          (categoryData['subcategories'] as List).isNotEmpty) {
        // Subcategory is required
        if (selectedSubcategory == null) {
          subcategoryError = "Please select a subcategory";
          isValid = false;
          return;
        }

        // Find subcategory data
        Map<String, dynamic>? subcategoryData;
        try {
          subcategoryData =
              (categoryData['subcategories'] as List).firstWhere(
                    (element) =>
                        element['subcategory_id'] == selectedSubcategory!['id'],
                  )
                  as Map<String, dynamic>;
        } catch (e) {
          // Subcategory not found
          isValid = false;
          return;
        }

        // Check if subcategory has programs
        if (subcategoryData.containsKey('programs') &&
            subcategoryData['programs'] != null &&
            (subcategoryData['programs'] as List).isNotEmpty) {
          // Program is required
          if (selectedProgram == null) {
            programError = "Please select a program";
            isValid = false;
            return;
          }

          // Find program data
          Map<String, dynamic>? programData;
          try {
            programData =
                (subcategoryData['programs'] as List).firstWhere(
                      (element) =>
                          element['program_id'] == selectedProgram!['id'],
                    )
                    as Map<String, dynamic>;
          } catch (e) {
            // Program not found
            isValid = false;
            return;
          }

          // Check if program has regions
          if (programData.containsKey('regions') &&
              programData['regions'] != null &&
              (programData['regions'] as List).isNotEmpty) {
            // Region is required
            if (selectedRegion == null) {
              regionError = "Please select a region";
              isValid = false;
            }
          }
        }
      }
    });
    return isValid;
  }

  // Submit function
  void _onSubmit() {
    if (_validateForm()) {
      // Create charity details in the requested format
      Map<String, dynamic> charityDetails = {
        'category': selectedCategory?['name'],
        'category_id': selectedCategory?['id'],
        'subcategory': selectedSubcategory?['name'],
        'subcategory_id': selectedSubcategory?['id'],
        'program': selectedProgram?['name'],
        'program_id': selectedProgram?['id'],
        'region': selectedRegion?['name'],
        'region_id': selectedRegion?['id'],
      };

      // Check if charity details already exist to avoid duplicates
      bool alreadyExists = widget.indianCitizenshipDetails.any(
        (item) =>
            item['category_id'] == charityDetails['category_id'] &&
            item['subcategory_id'] == charityDetails['subcategory_id'] &&
            item['program_id'] == charityDetails['program_id'] &&
            item['region_id'] == charityDetails['region_id'],
      );

      if (!alreadyExists) {
        widget.indianCitizenshipDetails.add(charityDetails);

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Charity details submitted successfully!'),
            backgroundColor: Colors.green,
          ),
        );

        // Reset form after successful submission
        setState(() {
          selectedCategory = null;
          selectedSubcategory = null;
          selectedProgram = null;
          selectedRegion = null;
          subcategories.clear();
          programs.clear();
          regions.clear();
          categoryError = null;
          subcategoryError = null;
          programError = null;
          regionError = null;
        });

        print(
          'Updated indianCitizenshipDetails: ${widget.indianCitizenshipDetails}',
        );
      } else {
        // Show duplicate message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('This charity selection already exists!'),
            backgroundColor: Colors.orange,
          ),
        );
      }
    }
  }*/
  void triggerSubmit() {
    _onSubmit();
  }

  bool _validateForm() {
    bool isValid = true;
    setState(() {
      // Reset all errors
      categoryError = null;
      subcategoryError = null;
      programError = null;
      regionError = null;

      // Validate category (always required)
      if (selectedCategory == null) {
        categoryError = "Please select a category";
        isValid = false;
        return;
      }

      // Find the category data in JSON
      final hierarchy = charityData['charity_hierarchy'] as List;
      Map<String, dynamic>? categoryData;

      try {
        categoryData =
            hierarchy.firstWhere(
                  (element) =>
                      element['category_id'] == selectedCategory!['id'],
                )
                as Map<String, dynamic>;
      } catch (e) {
        // Category not found
        isValid = false;
        return;
      }

      // Check if category has subcategories
      if (categoryData.containsKey('subcategories') &&
          categoryData['subcategories'] != null &&
          (categoryData['subcategories'] as List).isNotEmpty) {
        // Subcategory is required
        if (selectedSubcategory == null) {
          subcategoryError = "Please select a subcategory";
          isValid = false;
          return;
        }

        // Find subcategory data
        Map<String, dynamic>? subcategoryData;
        try {
          subcategoryData =
              (categoryData['subcategories'] as List).firstWhere(
                    (element) =>
                        element['subcategory_id'] == selectedSubcategory!['id'],
                  )
                  as Map<String, dynamic>;
        } catch (e) {
          // Subcategory not found
          isValid = false;
          return;
        }

        // Check if subcategory has programs
        if (subcategoryData.containsKey('programs') &&
            subcategoryData['programs'] != null &&
            (subcategoryData['programs'] as List).isNotEmpty) {
          // Program is required
          if (selectedProgram == null) {
            programError = "Please select a program";
            isValid = false;
            return;
          }

          // Find program data
          Map<String, dynamic>? programData;
          try {
            programData =
                (subcategoryData['programs'] as List).firstWhere(
                      (element) =>
                          element['program_id'] == selectedProgram!['id'],
                    )
                    as Map<String, dynamic>;
          } catch (e) {
            // Program not found
            isValid = false;
            return;
          }

          // Check if program has regions
          if (programData.containsKey('regions') &&
              programData['regions'] != null &&
              (programData['regions'] as List).isNotEmpty) {
            // Region is required
            if (selectedRegion == null) {
              regionError = "Please select a region";
              isValid = false;
              return;
            }
          }
        }
      }
    });
    return isValid;
  }

  void _onSubmit() {
    if (_validateForm()) {
      // Step 1: Build the charity details map
      Map<String, dynamic> charityDetails = {
        'category': selectedCategory!['name'],
        'category_id': selectedCategory!['id'],
      };

      if (selectedSubcategory != null) {
        charityDetails['subcategory'] = selectedSubcategory!['name'];
        charityDetails['subcategory_id'] = selectedSubcategory!['id'];
      }

      if (selectedProgram != null) {
        charityDetails['program'] = selectedProgram!['name'];
        charityDetails['program_id'] = selectedProgram!['id'];
        String programName = charityDetails['program'];
        SharedPreferences.getInstance().then((prefs) {
          prefs.setString('selected_program_name', programName);
        });
      }

      if (selectedRegion != null) {
        charityDetails['region'] = selectedRegion!['name'];
        charityDetails['region_id'] = selectedRegion!['id'];
      }
      if (widget.indianCitizenshipDetails.isEmpty) {
        // Insert charityDetails directly if list is empty
        widget.indianCitizenshipDetails.add(charityDetails);
      } else {
        // Clear existing data and insert fresh one
        widget.indianCitizenshipDetails.clear();
        widget.indianCitizenshipDetails.add(charityDetails);
      }
      /*if (widget.indianCitizenshipDetails.isEmpty) {
        // If top-level list is empty, create a fresh one
        widget.indianCitizenshipDetails.add({
          "indian_citizenship_details": [charityDetails],
        });
      } else {
        final details =
            widget.indianCitizenshipDetails[0]["indian_citizenship_details"];

        if (details is List && details.isNotEmpty && details[0] is Map) {
          // Merge charityDetails into the first map
          details[0].addAll(charityDetails);
        } else {
          // If details not valid, replace with new list
          widget.indianCitizenshipDetails[0]["indian_citizenship_details"] = [
            charityDetails,
          ];
        }
      }*/

      // // Step 4: Show success and debug output
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(
      //     content: Text('Charity details submitted successfully!'),
      //     backgroundColor: Colors.green,
      //   ),
      // );

      print(
        'Updated indianCitizenshipDetails: ${widget.indianCitizenshipDetails}',
      );
      widget.onSubmitted?.call(true);
    } else {
      widget.onSubmitted?.call(false);
    }
  }

  // Updated Submit function to only include non-null values
  /*  void _onSubmit() { // latest
    if (_validateForm()) {
      // Create charity details in the requested format - only include non-null values
      Map<String, dynamic> charityDetails = {};

      // Always include category (it's required)
      charityDetails['category'] = selectedCategory!['name'];
      charityDetails['category_id'] = selectedCategory!['id'];

      // Only include subcategory if it exists
      if (selectedSubcategory != null) {
        charityDetails['subcategory'] = selectedSubcategory!['name'];
        charityDetails['subcategory_id'] = selectedSubcategory!['id'];
      }

      // Only include program if it exists
      if (selectedProgram != null) {
        charityDetails['program'] = selectedProgram!['name'];
        charityDetails['program_id'] = selectedProgram!['id'];
      }

      // Only include region if it exists
      if (selectedRegion != null) {
        charityDetails['region'] = selectedRegion!['name'];
        charityDetails['region_id'] = selectedRegion!['id'];
      }

      // Check if charity details already exist to avoid duplicates
      bool alreadyExists = widget.indianCitizenshipDetails.any((item) {
        // Compare only the fields that exist in both items
        bool categoryMatch =
            item['category_id'] == charityDetails['category_id'];

        bool subcategoryMatch = true;
        if (charityDetails.containsKey('subcategory_id') ||
            item.containsKey('subcategory_id')) {
          subcategoryMatch =
              item['subcategory_id'] == charityDetails['subcategory_id'];
        }

        bool programMatch = true;
        if (charityDetails.containsKey('program_id') ||
            item.containsKey('program_id')) {
          programMatch = item['program_id'] == charityDetails['program_id'];
        }

        bool regionMatch = true;
        if (charityDetails.containsKey('region_id') ||
            item.containsKey('region_id')) {
          regionMatch = item['region_id'] == charityDetails['region_id'];
        }

        return categoryMatch && subcategoryMatch && programMatch && regionMatch;
      });

      */ /*if (!alreadyExists) {
        widget.indianCitizenshipDetails
          ..clear()
          ..add(charityDetails);
        //   widget.indianCitizenshipDetails.add(charityDetails);

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Charity details submitted successfully!'),
            backgroundColor: Colors.green,
          ),
        );

        // Reset form after successful submission
        // setState(() {
        //   selectedCategory = null;
        //   selectedSubcategory = null;
        //   selectedProgram = null;
        //   selectedRegion = null;
        //   subcategories.clear();
        //   programs.clear();
        //   regions.clear();
        //   categoryError = null;
        //   subcategoryError = null;
        //   programError = null;
        //   regionError = null;
        // });

        print(
          'Updated indianCitizenshipDetails: ${widget.indianCitizenshipDetails}',
        );
      }*/ /*
      if (!alreadyExists) {
        if (widget.indianCitizenshipDetails[0]["indian_citizenship_details"]
            is List) {
          widget.indianCitizenshipDetails[0]["indian_citizenship_details"]
              .clear();
          (widget.indianCitizenshipDetails[0]["indian_citizenship_details"]
                  as List)
              .add(charityDetails);
        }
        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Charity details submitted successfully!'),
            backgroundColor: Colors.green,
          ),
        );

        print(
          'Updated indianCitizenshipDetails: ${widget.indianCitizenshipDetails}',
        );
      } else {
        // Show duplicate message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('This charity selection already exists!'),
            backgroundColor: Colors.orange,
          ),
        );
      }
    }
  }*/

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    final theme = AppTheme.of(context);

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Category Dropdown
          Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Material(
                  elevation: 3,
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    width: screenWidth * 0.9,
                    child: DropdownSearch<Map<String, String>>(
                      items: categories,
                      selectedItem: selectedCategory,
                      onChanged: (value) {
                        setState(() {
                          selectedCategory = value;
                          _onCategoryChanged(value);
                        });
                        _onSubmit();
                      },
                      itemAsString: (item) => item['name']!,
                      dropdownBuilder: (context, selectedItem) {
                        return Text(
                          selectedItem?['name'] ?? '',
                          style: theme.typography.bodyText2.override(
                            color: theme.secondaryText,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        );
                      },
                      dropdownDecoratorProps: DropDownDecoratorProps(
                        dropdownSearchDecoration:
                            DecorationUtils.commonInputDecoration(
                              context: context,
                              iconData: null,
                              labelText: 'Select Category',
                              mandatory: true,
                            ).copyWith(
                              errorBorder:
                                  categoryError != null
                                      ? OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.red,
                                        ),
                                        borderRadius: BorderRadius.circular(12),
                                      )
                                      : null,
                            ),
                      ),
                      popupProps: PopupProps.menu(
                        showSearchBox: true,
                        fit: FlexFit.loose,
                        constraints: BoxConstraints(maxHeight: 300),
                        itemBuilder: (context, item, isSelected) {
                          return ListTile(
                            title: Text(
                              item['name']!,
                              style: theme.typography.bodyText2.override(
                                color: theme.secondaryText,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            selected: isSelected,
                          );
                        },
                        searchFieldProps: TextFieldProps(
                          decoration: InputDecoration(
                            hintText: 'Search categories...',
                            hintStyle: theme.typography.bodyText2.override(
                              color: theme.secondaryText,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                            prefixIcon: Icon(Icons.search, size: 20),
                          ),
                          style: theme.typography.bodyText2.override(
                            color: theme.secondaryText,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                if (categoryError != null)
                  Padding(
                    padding: const EdgeInsets.only(left: 12, top: 5),
                    child: Text(
                      categoryError!,
                      style: TextStyle(color: Colors.red, fontSize: 12),
                    ),
                  ),
              ],
            ),
          ),
          if (selectedCategory != null && subcategories.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Material(
                    elevation: 3,
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      width: screenWidth * 0.9,
                      child: DropdownSearch<Map<String, String>>(
                        items: subcategories,
                        selectedItem: selectedSubcategory,
                        onChanged: (value) {
                          setState(() {
                            selectedSubcategory = value;
                            _onSubcategoryChanged(value);
                          });
                          _onSubmit();
                        },
                        itemAsString: (item) => item['name']!,
                        dropdownBuilder: (context, selectedItem) {
                          return Text(
                            selectedItem?['name'] ?? '',
                            style: theme.typography.bodyText2.override(
                              color: theme.secondaryText,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          );
                        },
                        dropdownDecoratorProps: DropDownDecoratorProps(
                          dropdownSearchDecoration:
                              DecorationUtils.commonInputDecoration(
                                context: context,
                                iconData: null,
                                labelText: 'Select Subcategory',
                                mandatory: true,
                              ).copyWith(
                                errorBorder:
                                    subcategoryError != null
                                        ? OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Colors.red,
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        )
                                        : null,
                              ),
                        ),
                        popupProps: PopupProps.menu(
                          showSearchBox: true,
                          fit: FlexFit.loose,
                          constraints: BoxConstraints(
                            maxHeight: subcategories.length * 300.0,
                          ),
                          itemBuilder: (context, item, isSelected) {
                            return ListTile(
                              title: Text(
                                item['name']!,
                                style: theme.typography.bodyText2.override(
                                  color: theme.secondaryText,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              selected: isSelected,
                            );
                          },
                          searchFieldProps: TextFieldProps(
                            decoration: InputDecoration(
                              hintText: 'Search subcategories...',
                              hintStyle: theme.typography.bodyText2.override(
                                color: theme.secondaryText,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                              prefixIcon: Icon(Icons.search),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  if (subcategoryError != null)
                    Padding(
                      padding: const EdgeInsets.only(left: 12, top: 5),
                      child: Text(
                        subcategoryError!,
                        style: TextStyle(color: Colors.red, fontSize: 12),
                      ),
                    ),
                ],
              ),
            ),
          if (selectedSubcategory != null && programs.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Material(
                    elevation: 3,
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      width: screenWidth * 0.9,
                      child: DropdownSearch<Map<String, String>>(
                        items: programs,
                        selectedItem: selectedProgram,
                        onChanged: (value) {
                          setState(() {
                            selectedProgram = value;
                            _onProgramChanged(value);
                          });
                          _onSubmit();
                        },
                        itemAsString: (item) => item['name']!,
                        dropdownBuilder: (context, selectedItem) {
                          return Text(
                            selectedItem?['name'] ?? '',
                            style: theme.typography.bodyText2.override(
                              color: theme.secondaryText,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          );
                        },
                        dropdownDecoratorProps: DropDownDecoratorProps(
                          dropdownSearchDecoration:
                              DecorationUtils.commonInputDecoration(
                                context: context,
                                iconData: null,
                                labelText: 'Select Program',
                                mandatory: true,
                              ).copyWith(
                                errorBorder:
                                    programError != null
                                        ? OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Colors.red,
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        )
                                        : null,
                              ),
                        ),
                        popupProps: PopupProps.menu(
                          showSearchBox: true,
                          fit: FlexFit.loose,
                          constraints: BoxConstraints(
                            maxHeight: programs.length * 300.0,
                          ),
                          itemBuilder: (context, item, isSelected) {
                            return ListTile(
                              title: Text(
                                item['name']!,
                                style: theme.typography.bodyText2.override(
                                  color: theme.secondaryText,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              selected: isSelected,
                            );
                          },
                          searchFieldProps: TextFieldProps(
                            decoration: InputDecoration(
                              hintText: 'Search programs...',
                              hintStyle: theme.typography.bodyText2.override(
                                color: theme.secondaryText,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                              prefixIcon: Icon(Icons.search),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  if (programError != null)
                    Padding(
                      padding: const EdgeInsets.only(left: 12, top: 5),
                      child: Text(
                        programError!,
                        style: TextStyle(color: Colors.red, fontSize: 12),
                      ),
                    ),
                ],
              ),
            ),

          // Region Dropdown
          if (selectedProgram != null && regions.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Material(
                    elevation: 3,
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      width: screenWidth * 0.9,
                      child: DropdownSearch<Map<String, String>>(
                        items: regions,
                        selectedItem: selectedRegion,
                        onChanged: (value) {
                          setState(() {
                            selectedRegion = value;
                            _onRegionChanged(value);
                          });
                          _onSubmit();
                        },
                        itemAsString: (item) => item['name']!,
                        dropdownBuilder: (context, selectedItem) {
                          return Text(
                            selectedItem?['name'] ?? '',
                            style: theme.typography.bodyText2.override(
                              color: theme.secondaryText,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          );
                        },
                        dropdownDecoratorProps: DropDownDecoratorProps(
                          dropdownSearchDecoration:
                              DecorationUtils.commonInputDecoration(
                                context: context,
                                iconData: null,
                                labelText: 'Select Region',
                                mandatory: true,
                              ).copyWith(
                                errorBorder:
                                    regionError != null
                                        ? OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Colors.red,
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        )
                                        : null,
                              ),
                        ),
                        popupProps: PopupProps.menu(
                          showSearchBox: true,
                          fit: FlexFit.loose,
                          constraints: BoxConstraints(
                            maxHeight: regions.length * 300.0,
                          ),
                          itemBuilder: (context, item, isSelected) {
                            return ListTile(
                              title: Text(
                                item['name']!,
                                style: theme.typography.bodyText2.override(
                                  color: theme.secondaryText,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              selected: isSelected,
                            );
                          },
                          searchFieldProps: TextFieldProps(
                            decoration: InputDecoration(
                              hintText: 'Search regions...',
                              hintStyle: theme.typography.bodyText2.override(
                                color: theme.secondaryText,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                              prefixIcon: Icon(Icons.search),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  if (regionError != null)
                    Padding(
                      padding: const EdgeInsets.only(left: 12, top: 5),
                      child: Text(
                        regionError!,
                        style: TextStyle(color: Colors.red, fontSize: 12),
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
