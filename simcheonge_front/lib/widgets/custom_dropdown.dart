import 'package:flutter/material.dart';

class CustDropDown<T> extends StatefulWidget {
  final List<CustDropdownMenuItem> items;
  final Function onChanged;
  final String hintText;
  final double borderRadius;
  final double maxListHeight;
  final double borderWidth; // 추가된 속성
  final Color borderColor; // 추가된 속성
  final int defaultSelectedIndex;
  final bool enabled;

  const CustDropDown(
      {required this.items,
      required this.onChanged,
      this.hintText = "",
      this.borderRadius = 0,
      this.borderWidth = 1, // 기본값 설정
      this.borderColor = Colors.grey, // 기본값 설정
      this.maxListHeight = 100,
      this.defaultSelectedIndex = -1,
      super.key,
      this.enabled = true});

  @override
  _CustDropDownState createState() => _CustDropDownState();
}

class _CustDropDownState extends State<CustDropDown>
    with WidgetsBindingObserver {
  bool _isOpen = false, _isAnyItemSelected = false, _isReverse = false;
  late OverlayEntry _overlayEntry;
  late RenderBox? _renderBox;
  Widget? _itemSelected;
  late Offset dropDownOffset;
  final LayerLink _layerLink = LayerLink();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(() {
          dropDownOffset = getOffset();
        });
      }
      if (widget.defaultSelectedIndex > -1) {
        if (widget.defaultSelectedIndex < widget.items.length) {
          if (mounted) {
            setState(() {
              _isAnyItemSelected = true;
              _itemSelected = widget.items[widget.defaultSelectedIndex];
              widget.onChanged(widget.items[widget.defaultSelectedIndex].value);
            });
          }
        }
      }
    });
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  void _addOverlay() {
    if (mounted) {
      setState(() {
        _isOpen = true;
      });
    }

    _overlayEntry = _createOverlayEntry();
    Overlay.of(context).insert(_overlayEntry);
  }

  void _removeOverlay() {
    if (mounted) {
      setState(() {
        _isOpen = false;
      });
      _overlayEntry.remove();
    }
  }

  @override
  dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  OverlayEntry _createOverlayEntry() {
    _renderBox = context.findRenderObject() as RenderBox?;

    var size = _renderBox!.size;
    var offset = _renderBox!.localToGlobal(Offset.zero);

    return OverlayEntry(
        builder: (context) => Positioned(
              left: offset.dx,
              top: offset.dy + size.height, // 드롭다운 버튼 바로 아래에 오버레이를 위치시킵니다.
              width: size.width,
              child: Material(
                elevation: 20.0,
                borderRadius:
                    BorderRadius.circular(12), // 여기에 borderRadius를 적용합니다.
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxHeight: widget.maxListHeight,
                  ),
                  child: ClipRRect(
                    borderRadius:
                        BorderRadius.circular(12), // 자식 위젯들이 이 경계를 넘지 않도록 합니다.
                    child: ListView(
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      children: widget.items
                          .map((item) => GestureDetector(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: item.child,
                                ),
                                onTap: () {
                                  setState(() {
                                    _isAnyItemSelected = true;
                                    _itemSelected = item.child;
                                    _removeOverlay();
                                    widget.onChanged(item.value);
                                  });
                                },
                              ))
                          .toList(),
                    ),
                  ),
                ),
              ),
            ));
  }

  Offset getOffset() {
    RenderBox? renderBox = context.findRenderObject() as RenderBox?;
    double y = renderBox!.localToGlobal(Offset.zero).dy;
    double spaceAvailable = _getAvailableSpace(y + renderBox.size.height);
    if (spaceAvailable > widget.maxListHeight) {
      _isReverse = false;
      return Offset(0, renderBox.size.height);
    } else {
      _isReverse = true;
      return Offset(
          0,
          renderBox.size.height -
              (widget.maxListHeight + renderBox.size.height));
    }
  }

  double _getAvailableSpace(double offsetY) {
    double safePaddingTop = MediaQuery.of(context).padding.top;
    double safePaddingBottom = MediaQuery.of(context).padding.bottom;

    double screenHeight =
        MediaQuery.of(context).size.height - safePaddingBottom - safePaddingTop;

    return screenHeight - offsetY;
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: GestureDetector(
        onTap: widget.enabled
            ? () {
                _isOpen ? _removeOverlay() : _addOverlay();
              }
            : null,
        child: Container(
          decoration: _getDecoration(),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Flexible(
                flex: 3,
                child: _isAnyItemSelected
                    ? Padding(
                        padding: const EdgeInsets.only(left: 4.0),
                        child: _itemSelected!,
                      )
                    : Padding(
                        padding:
                            const EdgeInsets.only(left: 4.0), // change it here
                        child: Text(
                          widget.hintText,
                          maxLines: 1,
                          overflow: TextOverflow.clip,
                        ),
                      ),
              ),
              const Flexible(
                flex: 1,
                child: Icon(
                  Icons.arrow_drop_down,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Decoration? _getDecoration() {
    return BoxDecoration(
      border: Border.all(
        color: widget.borderColor, // 테두리 색상 사용
        width: widget.borderWidth, // 테두리 두께 사용
      ),
      borderRadius: BorderRadius.all(Radius.circular(widget.borderRadius)),
    );
  }
}

class CustDropdownMenuItem<T> extends StatelessWidget {
  final T value;
  final Widget child;

  const CustDropdownMenuItem(
      {super.key, required this.value, required this.child});

  @override
  Widget build(BuildContext context) {
    return child;
  }
}
