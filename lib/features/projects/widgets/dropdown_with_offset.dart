import 'package:flutter/material.dart';

/// A custom dropdown widget with an offset overlay for improved UI experience.
class DropdownWithOffset extends StatefulWidget {
  final String label;
  final List<String> options;
  final ValueChanged<String?> onChanged;
  final bool isOpen;
  final VoidCallback onTap;

  const DropdownWithOffset({
    super.key,
    required this.label,
    required this.options,
    required this.onChanged,
    required this.isOpen,
    required this.onTap,
  });

  @override
  DropdownWithOffsetState createState() => DropdownWithOffsetState();
}

class DropdownWithOffsetState extends State<DropdownWithOffset> {
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;
  String? selectedValue;

  /// Displays the dropdown overlay.
  void _showOverlay() {
    if (_overlayEntry == null) {
      _overlayEntry = _createOverlayEntry();
      Overlay.of(context).insert(_overlayEntry!);
    }
  }

  /// Hides the dropdown overlay if it exists.
  void _hideOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  /// Creates the dropdown overlay with proper positioning.
  OverlayEntry _createOverlayEntry() {
    RenderBox renderBox = context.findRenderObject() as RenderBox;
    Offset offset = renderBox.localToGlobal(Offset.zero);

    return OverlayEntry(
      builder: (context) => Positioned(
        width: renderBox.size.width,
        left: offset.dx,
        top: offset.dy + renderBox.size.height + 5, // Offset below field
        child: CompositedTransformFollower(
          link: _layerLink,
          offset: const Offset(0, 50), // Adds spacing below field
          child: Material(
            elevation: 4,
            borderRadius: BorderRadius.circular(8),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: widget.options.map(
                    (val) => ListTile(
                  title: Text(val),
                  onTap: () {
                    setState(() => selectedValue = val);
                    widget.onChanged(val);
                    _hideOverlay();
                  },
                ),
              ).toList(),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void didUpdateWidget(DropdownWithOffset oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Open/close overlay based on isOpen flag
    if (widget.isOpen && _overlayEntry == null) {
      _showOverlay();
    } else if (!widget.isOpen && _overlayEntry != null) {
      _hideOverlay();
    }
  }

  @override
  void dispose() {
    _hideOverlay(); // Ensure overlay is removed when widget is disposed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: GestureDetector(
        onTap: () {
          if (_overlayEntry == null) {
            _showOverlay();
          } else {
            _hideOverlay();
          }
          widget.onTap();
        },
        child: InputDecorator(
          decoration: InputDecoration(
            labelText: widget.label,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(selectedValue ?? widget.options.first),
              const Icon(Icons.arrow_drop_down),
            ],
          ),
        ),
      ),
    );
  }
}
