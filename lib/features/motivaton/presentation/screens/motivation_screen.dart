import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_it/get_it.dart';
import 'package:quittr/features/motivaton/data/data_sources/motivation_quotes_local_datasource.dart';
import 'package:quittr/features/motivaton/data/repository/motivational_quotes_repository_impl.dart';
import 'package:quittr/features/motivaton/domain/repository/motivation_quotes_repository.dart';
import 'package:quittr/features/motivaton/domain/usecases/get_motivationalQuotes.dart';
import 'package:quittr/features/motivaton/presentation/bloc/motivational_quotes_bloc.dart';

class MotivationScreen extends StatefulWidget {
  const MotivationScreen({super.key});

  @override
  State<MotivationScreen> createState() => _MotivationScreenState();
}

class _MotivationScreenState extends State<MotivationScreen> {
  final sl = GetIt.instance;
  // late MotivationalQuotesBloc _quotesBloc;

  @override
  void initState() {
    // Create the bloc in initState and keep a reference to it
    // _quotesBloc = MotivationalQuotesBloc(sl());
    // // Add the event after bloc is created
    // _quotesBloc.add(MotivationalQuotesGetEvent());
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          MotivationalQuotesBloc(sl())..add(MotivationalQuotesGetEvent()),
      child: Scaffold(
        body: Stack(
          children: [
            Container(
              width: double.infinity,
              height: double.infinity,
              child: SvgPicture.asset(
                "assets/images/motivational_background.svg",
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8.0, vertical: 50),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: const Icon(
                      Icons.close,
                      size: 25,
                    ),
                  ),
                  Text(
                    "Motivation",
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  ),
                  Container(
                    height: 25,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(),
                    ),
                    child: const Icon(
                      Icons.question_mark_rounded,
                      size: 15,
                    ),
                  )
                ],
              ),
            ),
            Align(
              alignment: Alignment.center,
              child:
                  BlocBuilder<MotivationalQuotesBloc, MotivationalQuotesState>(
                builder: (context, state) {
                  if (state is MotivationalQuotesLoading) {
                    return const CircularProgressIndicator();
                  }
                  if (state is MotivationalQuotesSuccess) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: AnimatedOpacity(
                        duration: Duration(seconds: 1),
                        key: Key(state.currentQuoteIndex.toString()),
                        opacity: state.opacity,
                        child: Text(
                          textAlign: TextAlign.center,
                          state
                              .motivationalQuotes[state.currentQuoteIndex].text,
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ),
                    );
                  }
                  return Text("no qoutes");
                },
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Builder(
                builder: (context) => GestureDetector(
                  onTap: () {
                    context
                        .read<MotivationalQuotesBloc>()
                        .add(MotivationalQuotesFadeOut());
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: BlocBuilder<MotivationalQuotesBloc,
                        MotivationalQuotesState>(
                      builder: (context, state) {
                        return Container(
                          width: double.infinity,
                          height: 60,
                          decoration: BoxDecoration(
                            color: state is MotivationalQuotesSuccess &&
                                    state.buttonPressed
                                ? Colors.white.withOpacity(0.5)
                                : Colors.white,
                            borderRadius:
                                const BorderRadius.all(Radius.circular(20)),
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.recycling),
                              SizedBox(width: 5),
                              Text("Regenerate"),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
