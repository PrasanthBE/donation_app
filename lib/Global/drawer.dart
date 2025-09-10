// // main.dart
// import 'package:akshaya_pathara/Global/apptheme.dart';
// import 'package:flutter/material.dart';
// import 'package:ionicons/ionicons.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// class AppDrawer extends StatefulWidget {
//   final String currentPage;
//   AppDrawer({this.currentPage = 'dashboard'});
//
//   @override
//   _AppDrawerState createState() => _AppDrawerState();
// }
//
// class _AppDrawerState extends State<AppDrawer> {
//   String name = '';
//   String email = '';
//   String mobileNumber = '';
//   bool isLoading = true;
//
//   @override
//   void initState() {
//     super.initState();
//     _loadUserDetails();
//   }
//
//   Future<void> _loadUserDetails() async {
//     try {
//       final prefs = await SharedPreferences.getInstance();
//       setState(() {
//         name = prefs.getString('name') ?? 'Guest User';
//         email = prefs.getString('email') ?? 'No email provided';
//         mobileNumber = prefs.getString('mobile_number') ?? 'No mobile number';
//         isLoading = false;
//       });
//     } catch (e) {
//       setState(() {
//         name = 'Guest User';
//         email = 'No email provided';
//         mobileNumber = 'No mobile number';
//         isLoading = false;
//       });
//     }
//   }
//
//   Widget _buildDrawerItem({
//     required BuildContext context,
//     required IconData icon,
//     required String title,
//     required String subtitle,
//     required String pageName,
//     required String route,
//     bool hasDropdown = true,
//   }) {
//     bool isSelected = widget.currentPage == pageName;
//     final theme = AppTheme.of(context);
//
//     return Container(
//       margin: EdgeInsets.symmetric(vertical: 4),
//       child: ListTile(
//         leading: Container(
//           padding: EdgeInsets.all(8),
//           decoration: BoxDecoration(
//             color:
//                 isSelected ? Colors.blue.withOpacity(0.2) : Colors.transparent,
//             borderRadius: BorderRadius.circular(8),
//           ),
//           child: Icon(
//             icon,
//             color: isSelected ? Colors.blue : Colors.grey[600],
//             size: 24,
//           ),
//         ),
//         title: Text(title, style: theme.typography.bodyText1.override()),
//         subtitle: Text(
//           subtitle,
//           style: theme.typography.bodyText3.override(
//             color: Colors.grey.shade600,
//           ),
//         ),
//         trailing:
//             isSelected
//                 ? Icon(Icons.keyboard_arrow_down, color: Colors.grey[600])
//                 : null,
//         onTap: () {
//           Navigator.of(context).pop(); // Close drawer
//           if (!isSelected) {
//             Navigator.of(context).pushReplacementNamed(route);
//           }
//         },
//         selected: isSelected,
//         selectedTileColor: Colors.blue.withOpacity(0.05),
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final theme = AppTheme.of(context);
//
//     return Container(
//       width: MediaQuery.of(context).size.width * 0.75,
//       child: Drawer(
//         child: Column(
//           children: [
//             // Profile Header
//             Container(
//               width: double.infinity,
//               padding: EdgeInsets.fromLTRB(20, 60, 20, 20),
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.grey.withOpacity(0.1),
//                     spreadRadius: 1,
//                     blurRadius: 4,
//                     offset: Offset(0, 2),
//                   ),
//                 ],
//               ),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Container(
//                     width: 60,
//                     height: 60,
//                     decoration: BoxDecoration(
//                       color: Colors.blue,
//                       borderRadius: BorderRadius.circular(30),
//                     ),
//                     child: Center(
//                       child: Icon(Ionicons.person, color: Colors.white),
//                     ),
//                   ),
//                   SizedBox(height: 16),
//                   // Show loading or user data
//                   isLoading
//                       ? Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Container(
//                             height: 16,
//                             width: 120,
//                             decoration: BoxDecoration(
//                               color: Colors.grey[300],
//                               borderRadius: BorderRadius.circular(4),
//                             ),
//                           ),
//                           SizedBox(height: 8),
//                           Container(
//                             height: 14,
//                             width: 160,
//                             decoration: BoxDecoration(
//                               color: Colors.grey[300],
//                               borderRadius: BorderRadius.circular(4),
//                             ),
//                           ),
//                           SizedBox(height: 4),
//                           Container(
//                             height: 14,
//                             width: 140,
//                             decoration: BoxDecoration(
//                               color: Colors.grey[300],
//                               borderRadius: BorderRadius.circular(4),
//                             ),
//                           ),
//                         ],
//                       )
//                       : Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             name,
//                             style: theme.typography.bodyText1.override(),
//                           ),
//                           SizedBox(height: 4),
//                           Text(
//                             email,
//                             style: theme.typography.bodyText2.override(
//                               color: Colors.grey.shade600,
//                             ),
//                           ),
//                           SizedBox(height: 4),
//                           Text(
//                             mobileNumber,
//                             style: theme.typography.bodyText2.override(
//                               color: Colors.grey.shade600,
//                             ),
//                           ),
//                         ],
//                       ),
//                 ],
//               ),
//             ),
//
//             // Menu Items
//             Expanded(
//               child: ListView(
//                 padding: EdgeInsets.symmetric(vertical: 8),
//                 children: [
//                   _buildDrawerItem(
//                     context: context,
//                     icon: Icons.dashboard,
//                     title: 'Dashboard',
//                     subtitle: 'Overview of your account',
//                     pageName: 'Dashboard',
//                     route: '/dashboard',
//                     hasDropdown: false,
//                   ),
//                   _buildDrawerItem(
//                     context: context,
//                     icon: Ionicons.person_outline,
//                     title: 'My Account',
//                     subtitle: 'Manage your profile and settings',
//                     pageName: 'My Account',
//                     route: '/my_account',
//                   ),
//                   _buildDrawerItem(
//                     context: context,
//                     icon: Ionicons.heart_outline,
//                     title: 'Online Donation',
//                     subtitle: 'Make secure donations to support children',
//                     pageName: 'Online Donation',
//                     route: '/online_donation',
//                   ),
//                   _buildDrawerItem(
//                     context: context,
//                     icon: Ionicons.megaphone_outline,
//                     title: 'Donation Campaign',
//                     subtitle: 'Participate in ongoing donation drives',
//                     pageName: 'Donation Campaign',
//                     route: '/donation_campaign',
//                   ),
//                   _buildDrawerItem(
//                     context: context,
//                     icon: Ionicons.headset_outline,
//                     title: 'Support',
//                     subtitle: 'Get help or raise a concern',
//                     pageName: 'Support',
//                     route: '/support',
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'package:akshaya_pathara/Global/apptheme.dart';
import 'package:akshaya_pathara/Pages/dashboard.dart';
import 'package:akshaya_pathara/Pages/donation_campaign.dart';
import 'package:akshaya_pathara/Pages/donation_campaign/campaign_list.dart';
import 'package:akshaya_pathara/Pages/india_map/indian%20map.dart';
import 'package:akshaya_pathara/Pages/online_donation_branch/recent_donation.dart';
import 'package:akshaya_pathara/Pages/online_donation_form.dart';
import 'package:akshaya_pathara/Pages/signup.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppDrawer extends StatefulWidget {
  final String currentPage;
  AppDrawer({this.currentPage = 'Dashboard'});

  @override
  _AppDrawerState createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  String name = '';
  String email = '';
  String mobileNumber = '';
  bool isLoading = true;
  void initState() {
    super.initState();
    _loadUserDetails();
  }

  Future<void> _loadUserDetails() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      setState(() {
        name = prefs.getString('name') ?? 'Guest User';
        mobileNumber = prefs.getString('mobile_number') ?? 'No mobile number';
        isLoading = false;
      });
    } catch (e) {
      final prefs = await SharedPreferences.getInstance();

      setState(() {
        name = 'Guest User';
        mobileNumber = prefs.getString('mobile_number') ?? 'No mobile number';
        email = 'No email provided';
        isLoading = false;
      });
    }
  }

  Widget _buildDrawerItem({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    required String pageName,
    required String route,
    bool hasDropdown = true,
  }) {
    bool isSelected =
        widget.currentPage.trim().toLowerCase() ==
        pageName.trim().toLowerCase();
    final theme = AppTheme.of(context);

    return Container(
      decoration: BoxDecoration(
        // color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      margin: EdgeInsets.symmetric(vertical: 2),
      child: ListTile(
        leading: Container(
          padding: EdgeInsets.fromLTRB(6, 0, 6, 0),
          decoration: BoxDecoration(
            color:
                isSelected ? Colors.blue.withOpacity(0.2) : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: isSelected ? Colors.blue : Colors.grey[600],
            size: 24,
          ),
        ),
        title: Text(title, style: theme.typography.bodyText2.override()),
        subtitle: Text(
          subtitle,
          style: theme.typography.bodyText3.override(
            color: Colors.grey.shade600,
            fontSize: 11,
          ),
        ),
        trailing:
            !isSelected
                ? Icon(Icons.keyboard_arrow_down, color: Colors.grey[600])
                : null,
        onTap: () {
          Navigator.of(context).pop(); // Close drawer
          // if (!isSelected) {
          Navigator.of(context).pushReplacementNamed(route);

          // }
        },
        selected: isSelected,
        selectedTileColor: Colors.blue.withOpacity(0.05),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);

    return Container(
      width: MediaQuery.of(context).size.width * 0.80,
      decoration: BoxDecoration(color: Colors.white),
      child: Drawer(
        backgroundColor: Colors.white,

        child: Column(
          children: [
            // Profile Header
            Container(
              width: double.infinity,
              padding: EdgeInsets.fromLTRB(20, 60, 20, 0),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Center(
                      child: Icon(Ionicons.person, color: Colors.white),
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(name, style: theme.typography.bodyText1.override()),
                  if (email.isNotEmpty) SizedBox(height: 4),
                  if (email.isNotEmpty)
                    Text(
                      email,
                      style: theme.typography.bodyText2.override(
                        color: Colors.grey.shade600,
                      ),
                    ),
                  SizedBox(height: 4),
                  Text(
                    mobileNumber,
                    style: theme.typography.bodyText2.override(
                      color: Colors.grey.shade600,
                    ),
                  ),
                  SizedBox(height: 4),
                ],
              ),
            ),

            // Menu Items
            Expanded(
              child: ListView(
                padding: EdgeInsets.symmetric(vertical: 4),
                children: [
                  _buildDrawerItem(
                    context: context,
                    icon: MdiIcons.handHeartOutline,
                    title: 'Donate',
                    subtitle: 'Make secure donations to support children',
                    pageName: 'online_donation',
                    route: '/online_donation',
                  ),
                  _buildDrawerItem(
                    context: context,
                    icon: Ionicons.person_outline,
                    title: 'Create Profile',
                    subtitle: 'Manage your profile and settings',
                    pageName: 'my_account',
                    route: '/my_account',
                  ),
                  _buildDrawerItem(
                    context: context,
                    icon: Icons.dashboard,
                    title: 'Dashboard',
                    subtitle: 'Overview of your account',
                    pageName: 'Dashboard',
                    route: '/dashboard',
                    hasDropdown: false,
                  ),
                  _buildDrawerItem(
                    context: context,
                    icon: Ionicons.map_outline,
                    title: 'State-wise Donations',
                    subtitle: 'Visualize where donations are being used',
                    pageName: 'state_wise_overview',
                    route: '/state_wise_overview',
                  ),

                  _buildDrawerItem(
                    context: context,
                    icon: MdiIcons.heartMultipleOutline,
                    title: 'Recent Donation',
                    subtitle: 'Review your past donations securely',
                    pageName: 'recent_donation',
                    route: '/recent_donation',
                  ),
                  _buildDrawerItem(
                    context: context,
                    icon: Icons.campaign,
                    title: 'Donation Campaign',
                    subtitle: 'Start campaigns to support a cause',
                    pageName: 'donation_campaign',
                    route: '/donation_campaign',
                  ),
                  _buildDrawerItem(
                    context: context,
                    icon: MdiIcons.formatListBulleted,
                    title: 'Donation Campaign list',
                    subtitle: 'View and manage fundraising efforts',
                    pageName: 'donation_campaign_list',
                    route: '/donation_campaign_list',
                  ),

                  Padding(
                    padding: const EdgeInsets.only(bottom: 20.0),
                    child: ListTile(
                      leading: Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.red.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          Ionicons.log_out_outline,
                          color: Colors.red,
                        ),
                      ),
                      title: Text(
                        'Logout',
                        style: theme.typography.bodyText1.override(),
                      ),
                      subtitle: Text(
                        'Sign out of your account',
                        style: theme.typography.bodyText3.override(
                          color: Colors.grey.shade600,
                        ),
                      ),
                      onTap: () => _showLogoutConfirmation(context),
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

  void _showLogoutConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        final theme = AppTheme.of(context);

        return AlertDialog(
          title: Text(
            'Confirm Logout',
            style: theme.bodyText1,
            textAlign: TextAlign.center,
          ),
          content: Text(
            'Are you sure you want to logout? \n Logging out will remove your saved preferences and clear your session data.',
            style: theme.bodyText2,
            textAlign: TextAlign.center,
          ),
          actions: [
            TextButton(
              child: Text(
                'Cancel',
                style: theme.typography.bodyText2.override(color: Colors.blue),
              ),
              onPressed: () => Navigator.of(dialogContext).pop(),
            ),
            TextButton(
              child: Text(
                'Logout',
                style: theme.typography.bodyText2.override(color: Colors.red),
              ),
              onPressed: () async {
                Navigator.of(dialogContext).pop(); // close dialog
                final prefs = await SharedPreferences.getInstance();
                await prefs.clear(); // clear session
                Navigator.of(context).pushNamedAndRemoveUntil(
                  '/', // or your login route
                  (route) => false,
                );
              },
            ),
          ],
        );
      },
    );
  }
}
