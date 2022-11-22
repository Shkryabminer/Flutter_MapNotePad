
abstract class MapEvent{}

class SearchPinEvent extends MapEvent
{
  final String pinTitle;
  final Function(num,num) callBack;
  SearchPinEvent(
    this.pinTitle,
      this.callBack);
}


