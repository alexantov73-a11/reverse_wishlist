import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/reverse_list_viewmodel.dart';
import '../../../core/constants/app_constants.dart';

class ReverseListScreen extends StatefulWidget {
  const ReverseListScreen({super.key});

  @override
  State<ReverseListScreen> createState() => _ReverseListScreenState();
}

class _ReverseListScreenState extends State<ReverseListScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ReverseListViewModel>().loadCards();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ReverseListViewModel>(
      builder: (context, viewModel, _) => Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: ['All', ...AppConstants.categories]
                    .map(
                      (category) => Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: FilterChip(
                          label: Text(category),
                          selected: viewModel.filterCategory == category,
                          onSelected: (_) {
                            viewModel.setFilterCategory(category);
                          },
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
          ),
          Expanded(
            child: viewModel.filteredCards.isEmpty
                ? const Center(child: Text('No cards in this category'))
                : ListView.builder(
                    itemCount: viewModel.filteredCards.length,
                    itemBuilder: (context, index) {
                      final card = viewModel.filteredCards[index];
                      return GestureDetector(
                        onTap: () => Navigator.of(context)
                            .pushNamed('/detail', arguments: card.id)
                            .then((_) => viewModel.loadCards()),
                        child: Card(
                          margin: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          child: ListTile(
                            title: Text(card.title),
                            subtitle: Text(card.category),
                            trailing: PopupMenuButton(
                              itemBuilder: (_) => [
                                PopupMenuItem(
                                  child: const Text('Delete'),
                                  onTap: () {
                                    viewModel.deleteCard(card.id);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Card deleted'),
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
