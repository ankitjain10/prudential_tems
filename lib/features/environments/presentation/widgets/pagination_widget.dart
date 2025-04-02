import 'dart:math';

import 'package:flutter/material.dart';

class PaginationWidget extends StatelessWidget {
  final int currentPage;
  final int totalPages;
  final int totalResults;
  final int resultsPerPage;
  final bool filterEnabled;
  final Function(int) onPageChanged;

  const PaginationWidget({
    super.key,
    required this.currentPage,
    required this.totalPages,
    required this.totalResults,
    required this.resultsPerPage,
    required this.onPageChanged,  this.filterEnabled =false,
  });

  @override
  Widget build(BuildContext context) {
    int startItem = ((currentPage - 1) * resultsPerPage) + 1;
    int endItem = (currentPage * resultsPerPage);
    if (endItem > totalResults) {
      endItem = totalResults;
    }
    return Visibility(
        visible: !filterEnabled,
      child: Column(
        children: [
          // Results summary
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
            child: SelectableText(
              "Showing $startItem-$endItem of $totalResults results",
              style: const TextStyle(fontSize: 14, color: Colors.black87),
            ),
          ),

          // Pagination Controls
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Previous Button
              IconButton(
                icon: const Icon(Icons.chevron_left),
                onPressed: currentPage > 1 ? () => onPageChanged(currentPage - 1) : null,
              ),

              // Page Numbers (Handling large page counts efficiently)
              if (totalPages <= 7)
                _buildPageButtons(1, totalPages)
              else
                Row(
                  children: [
                    if (currentPage > 3) _buildPageButton(1),
                    if (currentPage > 4) const SelectableText("..."),
                    _buildPageButtons(
                      max(1, currentPage - 2),
                      min(totalPages, currentPage + 2),
                    ),
                    if (currentPage < totalPages - 3) const SelectableText("..."),
                    if (currentPage < totalPages - 2) _buildPageButton(totalPages),
                  ],
                ),

              // Next Button
              IconButton(
                icon: const Icon(Icons.chevron_right),
                onPressed: currentPage < totalPages ? () => onPageChanged(currentPage + 1) : null,
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Builds a row of page number buttons within a given range
  Widget _buildPageButtons(int start, int end) {
    return Row(
      children: List.generate(end - start + 1, (index) => _buildPageButton(start + index)),
    );
  }

  /// Builds an individual page button
  Widget _buildPageButton(int pageNumber) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: currentPage == pageNumber ? Colors.grey[700] : Colors.white,
          foregroundColor: currentPage == pageNumber ? Colors.white : Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        ),
        onPressed: () => onPageChanged(pageNumber),
        child: Text(pageNumber.toString()),
      ),
    );
  }
}
