
abstract class PinEvents
 {}

 class SearchPinEvent extends PinEvents
 {
   final String searchText;
   SearchPinEvent(
       this.searchText
       );
 }

 class InitPinStateEvent extends PinEvents
 {
   InitPinStateEvent();
 }
