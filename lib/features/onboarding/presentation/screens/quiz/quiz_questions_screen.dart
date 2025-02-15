import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quittr/core/injection_container.dart';
import 'package:quittr/features/onboarding/presentation/screens/quiz/quiz_name_age_screen.dart';
import 'package:quittr/features/onboarding/presentation/widgets/option_tile.dart';
import '../../bloc/quiz_bloc.dart';

class QuizQuestionsScreen extends StatelessWidget {
  const QuizQuestionsScreen({super.key});

  void _onOptionSelected(BuildContext context, String option) {
    context.read<QuizBloc>().add(AnswerQuestion(option));
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<QuizBloc>()..add(LoadQuizQuestions()),
      child: Scaffold(
        body: SafeArea(
          child: BlocConsumer<QuizBloc, QuizState>(
            listener: (context, state) {
              if (state is QuizCompleted) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        QuizNameAgeScreen(quizAnswers: state.answers),
                  ),
                );
              }
            },
            builder: (context, state) {
              if (state is QuizLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              if (state is QuizError) {
                return Center(child: Text(state.message));
              }

              if (state is QuizLoaded) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    LinearProgressIndicator(
                      value: (state.currentQuestionIndex + 1) /
                          state.questions.length,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Question ${state.currentQuestionIndex + 1}/${state.questions.length}',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            state.currentQuestion.question,
                            style: Theme.of(context)
                                .textTheme
                                .headlineSmall
                                ?.copyWith(
                                  fontFamily: GoogleFonts.poppins().fontFamily,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        itemCount: state.currentQuestion.options.length,
                        itemBuilder: (context, index) {
                          final option = state.currentQuestion.options[index];
                          return OptionTile(
                            option: option,
                            onSelected: () {
                              _onOptionSelected(context, option);
                            },
                          );
                        },
                      ),
                    ),
                    SvgPicture.asset(
                      'assets/illustrations/quiz_screen.svg',
                      width: MediaQuery.sizeOf(context).width,
                    ),
                  ],
                );
              }

              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
  }
}
