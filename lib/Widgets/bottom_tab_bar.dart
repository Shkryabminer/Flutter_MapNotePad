
import 'package:flutter/material.dart';

class BottomTabBar extends StatefulWidget
{
  const BottomTabBar({Key? key,
    required this.selectedIndex,
    required this.onItemTapped}) : super(key: key);

  final int selectedIndex;
  final Function(int) onItemTapped;

  @override
  State<StatefulWidget> createState() => _BottomTabBarState();

}
class _BottomTabBarState extends State<BottomTabBar>
{
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: [_buildBarItem('assets/ic_map.png', 'Map'),
      _buildBarItem('assets/ic_pin.png', 'Pins')],
      showSelectedLabels: false,
      showUnselectedLabels: false,
      onTap: widget.onItemTapped,
      currentIndex: widget.selectedIndex,
      type: BottomNavigationBarType.shifting,
      backgroundColor: Colors.grey,
    );
  }

  BottomNavigationBarItem _buildBarItem(String assetImage, String title)
  {
   return BottomNavigationBarItem(icon: _buildIcon(assetImage, title),
   label: '',
   activeIcon: _buildSelecteIcon(assetImage, title));
  }

  Widget _buildIcon(String image, String title)
  {
    return Center(
        child: Row(mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image(image: AssetImage(image),),
            SizedBox(width: 5,),
            Text(title)
          ],
        ),
    );
  }
  Widget _buildSelecteIcon(String image, String title)
  {
    return Center(
        child: Row(mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image(image: AssetImage(image),),
            SizedBox(width: 5,),
            Text(title)
          ],
      ),
    );
  }
}