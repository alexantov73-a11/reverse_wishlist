// ignore_for_file: use_build_context_synchronously, deprecated_member_use

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/create_edit_card_viewmodel.dart';
import '../../viewmodels/detail_viewmodel.dart';
import '../../../core/constants/app_constants.dart';

class CreateEditCardScreen extends StatefulWidget {
  final String? cardId;

  const CreateEditCardScreen({super.key, this.cardId});

  @override
  State<CreateEditCardScreen> createState() => _CreateEditCardScreenState();
}

class _CreateEditCardScreenState extends State<CreateEditCardScreen> {
  final _titleController = TextEditingController();
  final _reasonController = TextEditingController();
  final _notesController = TextEditingController();
  late TextEditingController _amountController;
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    _amountController = TextEditingController();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.cardId != null) {
        // Load existing card for editing
        context.read<DetailViewModel>().loadCard(widget.cardId!);
        _loadCardData();
      } else {
        // Reset for new card
        context.read<CreateEditCardViewModel>().reset();
      }
    });
  }

  void _loadCardData() {
    final card = context.read<DetailViewModel>().card;
    if (card != null) {
      _titleController.text = card.title;
      _reasonController.text = card.reason;
      _notesController.text = card.notes ?? '';
      _amountController.text = card.amount.toString();
      _selectedDate = DateTime.now();
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _reasonController.dispose();
    _notesController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.cardId != null ? 'Edit Card' : 'Add Card'),
        centerTitle: true,
      ),
      body: Consumer<CreateEditCardViewModel>(
        builder: (context, viewModel, _) => SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Photo section
              GestureDetector(
                onTap: () => _showPhotoOptions(context, viewModel),
                child: Container(
                  width: double.infinity,
                  height: 200,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Theme.of(context).primaryColor,
                      width: 2,
                    ),
                  ),
                  child: viewModel.photoPath.isEmpty
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.camera_alt,
                              size: 50,
                              color: Theme.of(context).primaryColor,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Tap to add photo',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ],
                        )
                      : Stack(
                          children: [
                            Image.file(
                              File(viewModel.photoPath),
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: 200,
                            ),
                            Positioned(
                              top: 8,
                              right: 8,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.black54,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                padding: const EdgeInsets.all(4),
                                child: Icon(
                                  Icons.edit,
                                  color: Theme.of(context).primaryColor,
                                  size: 20,
                                ),
                              ),
                            ),
                          ],
                        ),
                ),
              ),
              const SizedBox(height: 24),
              // Product Name
              TextField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Product Name',
                  hintText: 'Enter product name',
                ),
                onChanged: (value) =>
                    context.read<CreateEditCardViewModel>().setTitle(value),
              ),
              const SizedBox(height: 16),
              // Category
              DropdownButtonFormField<String>(
                value: context.read<CreateEditCardViewModel>().category,
                decoration: const InputDecoration(labelText: 'Category'),
                items: AppConstants.categories
                    .map(
                      (cat) => DropdownMenuItem(value: cat, child: Text(cat)),
                    )
                    .toList(),
                onChanged: (value) {
                  if (value != null) {
                    context.read<CreateEditCardViewModel>().setCategory(value);
                  }
                },
              ),
              const SizedBox(height: 16),
              // Reason
              TextField(
                controller: _reasonController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Reason for Rejection',
                  hintText: 'Why did you refuse this product?',
                ),
                onChanged: (value) =>
                    context.read<CreateEditCardViewModel>().setReason(value),
              ),
              const SizedBox(height: 16),
              // Amount
              TextField(
                controller: _amountController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: const InputDecoration(
                  labelText: 'Amount (\$)',
                  hintText: 'How much did you save?',
                  prefixText: '\$ ',
                ),
                onChanged: (value) {
                  final amount = double.tryParse(value) ?? 0.0;
                  context.read<CreateEditCardViewModel>().setAmount(amount);
                },
              ),
              const SizedBox(height: 16),
              // Date
              GestureDetector(
                onTap: () => _selectDate(context),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 16,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _selectedDate == null
                            ? 'Select Date'
                            : '${_selectedDate!.day}.${_selectedDate!.month}.${_selectedDate!.year}',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      Icon(
                        Icons.calendar_today,
                        color: Theme.of(context).primaryColor,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Notes
              TextField(
                controller: _notesController,
                maxLines: 2,
                decoration: const InputDecoration(
                  labelText: 'Notes (optional)',
                  hintText: 'Additional information',
                ),
                onChanged: (value) =>
                    context.read<CreateEditCardViewModel>().setNotes(value),
              ),
              const SizedBox(height: 32),
              // Save button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: viewModel.isLoading
                      ? null
                      : () => _saveCard(context, viewModel),
                  child: viewModel.isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Text(
                          widget.cardId != null ? 'Update Card' : 'Save Card',
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showPhotoOptions(
    BuildContext context,
    CreateEditCardViewModel viewModel,
  ) {
    showModalBottomSheet(
      context: context,
      builder: (_) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera),
              title: const Text('Camera'),
              onTap: () async {
                Navigator.pop(context);
                final path = await viewModel.pickFromCamera();
                if (path != null && mounted) {
                  viewModel.setPhoto(path);
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.image),
              title: const Text('Gallery'),
              onTap: () async {
                Navigator.pop(context);
                final path = await viewModel.pickFromGallery();
                if (path != null && mounted) {
                  viewModel.setPhoto(path);
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );

    if (picked != null && mounted) {
      setState(() => _selectedDate = picked);
      context.read<CreateEditCardViewModel>().setDate(
        '${picked.day}.${picked.month}.${picked.year}',
      );
    }
  }

  void _saveCard(BuildContext context, CreateEditCardViewModel viewModel) {
    if (_titleController.text.isEmpty ||
        _reasonController.text.isEmpty ||
        _selectedDate == null ||
        viewModel.photoPath.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all required fields')),
      );
      return;
    }

    viewModel
        .saveCard()
        .then((_) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  widget.cardId != null ? 'Card updated!' : 'Card saved!',
                ),
              ),
            );

            _titleController.clear();
            _reasonController.clear();
            _notesController.clear();
            _amountController.clear();
            _selectedDate = null;
            viewModel.reset();

            Navigator.pop(context, true);
          }
        })
        .catchError((e) {
          if (mounted) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text('Error: $e')));
          }
        });
  }
}
