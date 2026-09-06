import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopping_app/core/inject/injection.dart';
import 'package:shopping_app/core/theme/app_theme.dart';
import 'package:shopping_app/core/theme/dimens.dart';
import 'package:shopping_app/core/utils/app_navigator.dart';
import 'package:shopping_app/core/widgets/app_button.dart';
import 'package:shopping_app/core/widgets/app_choice_chip.dart';
import 'package:shopping_app/core/widgets/app_scaffold.dart';
import 'package:shopping_app/core/widgets/general_app_bar.dart';
import 'package:shopping_app/features/auth/presentation/bloc/cubits/auth_cubit.dart';
import 'package:shopping_app/features/feedback/domain/feedback_entities.dart';
import 'package:shopping_app/features/feedback/presentation/bloc/feedback_cubit.dart';
import 'package:shopping_app/features/feedback/presentation/bloc/feedback_state.dart';

class FeedbackScreen extends StatefulWidget {
  const FeedbackScreen({super.key});

  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  int _rating = 0;
  FeedbackCategory _category = FeedbackCategory.suggestion;
  final _messageController = TextEditingController();

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authCubit = context.read<AuthCubit>();
    final user = authCubit.currentUser;
    //final appColors = context.theme.appColors;
    final appTypography = context.theme.appTypography;

    return BlocProvider<FeedbackCubit>(
      create: (_) => getIt<FeedbackCubit>(),
      child: AppScaffold(
        appBar: GeneralAppBar(title: 'Feedback'),
        body: BlocConsumer<FeedbackCubit, FeedbackState>(
          listener: (context, state) {
            if (state is FeedbackSubmitted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Thanks for your feedback!')),
              );
              appPop(context);
            }
            if (state is FeedbackSubmitError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Failed to submit: ${state.message}')),
              );
            }
          },
          builder: (context, state) {
            final isSubmitting = state is FeedbackSubmitting;

            return SingleChildScrollView(
              padding: EdgeInsets.all(Dimens.largePadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: Dimens.largePadding,
                children: [
                  Text(
                    'How would you rate your experience?',
                    style: appTypography.bodyLarge,
                  ),
                  Row(
                    children: List.generate(5, (index) {
                      final starIndex = index + 1;
                      return IconButton(
                        onPressed: () => setState(() => _rating = starIndex),
                        icon: Icon(
                          starIndex <= _rating ? Icons.star : Icons.star_border,
                          color: Colors.amber,
                          size: 32,
                        ),
                      );
                    }),
                  ),
                  Text('Category', style: appTypography.bodyLarge),
                  Wrap(
                    spacing: Dimens.padding,
                    children: FeedbackCategory.values.map((cat) {
                      final isSelected = _category == cat;
                      return AppChoiceChip(
                        label:
                            cat.name[0].toUpperCase() + cat.name.substring(1),
                        selected: isSelected,
                        onSelected: (_) => setState(() => _category = cat),
                      );
                    }).toList(),
                  ),
                  Text('Tell us more', style: appTypography.bodyLarge),
                  TextField(
                    controller: _messageController,
                    maxLines: 5,
                    decoration: InputDecoration(
                      hintText: 'What went well? What could be better?',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(Dimens.corners),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: AppButton(
                      title: isSubmitting ? 'Submitting...' : 'Submit Feedback',
                      onPressed: isSubmitting || user == null
                          ? null
                          : () {
                              if (_rating == 0 ||
                                  _messageController.text.trim().isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Please add a rating and a message',
                                    ),
                                  ),
                                );
                                return;
                              }

                              context.read<FeedbackCubit>().submit(
                                AppFeedback(
                                  uid: user.uid,
                                  userEmail: user.email,
                                  rating: _rating,
                                  category: _category,
                                  message: _messageController.text.trim(),
                                ),
                              );
                            },
                      margin: EdgeInsets.zero,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
