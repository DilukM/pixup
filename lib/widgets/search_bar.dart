import 'package:flutter/material.dart';

// CustomSearchBar widget to handle search input
class CustomSearchBar extends StatefulWidget {
  final Function(String) onSearch;// Callback function to handle search input

  const CustomSearchBar({Key? key, required this.onSearch}) : super(key: key);

  @override
  State<CustomSearchBar> createState() => _CustomSearchBarState();
}

class _CustomSearchBarState extends State<CustomSearchBar> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      setState(() {});// Update the state when the text changes
    });
  }

  @override
  Widget build(BuildContext context) {
    return IntrinsicWidth(
      child: TextField(
        controller: _controller,// Assigning the controller to the text field
        decoration: InputDecoration(
          hintText: 'Search movies...',
          prefixIcon: const Icon(Icons.search),
          suffixIcon: _controller.text.isEmpty
              ? null
              : IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _controller.clear();
                    widget.onSearch('');
                  },
                ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.horizontal(
              left: Radius.circular(50.0),
              right: Radius.circular(50.0),
            ),
            borderSide: BorderSide.none,
          ),
        ),
        onChanged: (value) {
          widget.onSearch(value);// Trigger the search callback with the current input
        },
      ),
    );
  }
}
