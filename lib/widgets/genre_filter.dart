import 'package:flutter/material.dart';
import 'package:pixup/models/genre.dart';

class GenreFilterDialog extends StatefulWidget {
  final List<Genre> genres; // List of all available genres
  final List<Genre> selectedGenres; // List of currently selected genres
  final Function(List<Genre>)
      onGenresSelected; // Callback function to handle selected genres

  const GenreFilterDialog({
    Key? key,
    required this.genres,
    required this.selectedGenres,
    required this.onGenresSelected,
  }) : super(key: key);

  @override
  State<GenreFilterDialog> createState() => _GenreFilterDialogState();
}

class _GenreFilterDialogState extends State<GenreFilterDialog> {
  late List<Genre>
      tempSelectedGenres; // Temporary list to manage selected genres

  @override
  void initState() {
    super.initState();
    // Initialize with current selection
    tempSelectedGenres = List.from(widget.selectedGenres);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.7,
          maxWidth: MediaQuery.of(context).size.width * 0.9,
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Filter by Genres',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                '${tempSelectedGenres.length} selected',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(height: 16),
              Flexible(
                child: SingleChildScrollView(
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: widget.genres.map((genre) {
                      final isSelected = tempSelectedGenres.contains(genre);
                      return FilterChip(
                        selected: isSelected,
                        label: Text(genre.name), // Display the genre name
                        onSelected: (selected) {
                          setState(() {
                            if (selected) {
                              tempSelectedGenres
                                  .add(genre); // Add genre to the selected list
                            } else {
                              tempSelectedGenres.remove(
                                  genre); // Remove genre from the selected list
                            }
                          });
                        },
                        selectedColor: Theme.of(context)
                            .colorScheme
                            .primary
                            .withOpacity(0.2),
                        checkmarkColor: Theme.of(context).colorScheme.primary,
                        backgroundColor: Theme.of(context).colorScheme.surface,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                          side: BorderSide(
                            color: isSelected
                                ? Theme.of(context).colorScheme.primary
                                : Theme.of(context).colorScheme.outline,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      setState(() {
                        tempSelectedGenres.clear(); // Clear all selected genres
                      });
                    },
                    child: const Text('Clear All'),
                  ),
                  const SizedBox(width: 8),
                  FilledButton(
                    onPressed: () {
                      widget.onGenresSelected(
                          tempSelectedGenres); // Apply the selected genres
                      Navigator.pop(context); // Close the dialog
                    },
                    child: const Text('Apply'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
