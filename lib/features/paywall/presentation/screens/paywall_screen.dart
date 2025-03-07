// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:quittr/features/paywall/domain/entities/product.dart';
// import '../bloc/paywall_bloc.dart';

// class PaywallScreen extends StatefulWidget {
//   const PaywallScreen({super.key});

//   @override
//   State<PaywallScreen> createState() => _PaywallScreenState();
// }

// class _PaywallScreenState extends State<PaywallScreen> {
//   @override
//   void initState() {
//     // context.read<SubscriptionBloc>().add(CheckIAPAvailabilityEvent());

//       context.read<SubscriptionBloc>()
//       ..add(CheckIAPAvailabilityEvent())
//       ..add(StartListeningToPurchaseUpdatesEvent());

//     super.initState();
//   }

//   String? selectedSubscriptionId;

//   @override
//   Widget build(BuildContext context) {
//     return BlocListener<SubscriptionBloc, IAPState>(
//       listener: (context, state) {
//         if (state is IAPErrorState) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(content: Text(state.errorMessage)),
//           );
//         }
//         if (state is PurchaseSuccessState) {
//           Navigator.popUntil(context, (route) => route.isFirst);
//           Navigator.pushNamed(context, '/home');
//         }
//       },
//       child: Scaffold(
//         body: Container(
//           decoration: BoxDecoration(
//             gradient: LinearGradient(
//               begin: Alignment.topCenter,
//               end: Alignment.bottomCenter,
//               colors: [
//                 Theme.of(context).colorScheme.primaryContainer.withAlpha(76),
//                 Theme.of(context).colorScheme.surface,
//               ],
//             ),
//           ),
//           child: SafeArea(
//             child: Column(
//               children: [
//                 Expanded(
//                   child: SingleChildScrollView(
//                     child: Padding(
//                       padding: const EdgeInsets.all(24.0),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             'Choose Your Plan',
//                             style: Theme.of(context)
//                                 .textTheme
//                                 .headlineMedium
//                                 ?.copyWith(
//                                   fontFamily: GoogleFonts.poppins().fontFamily,
//                                   fontWeight: FontWeight.bold,
//                                   color: Theme.of(context).colorScheme.primary,
//                                 ),
//                           ),
//                           const SizedBox(height: 8),
//                           Text(
//                             'Select the plan that works best for you',
//                             style:
//                                 Theme.of(context).textTheme.bodyLarge?.copyWith(
//                                       color: Theme.of(context)
//                                           .colorScheme
//                                           .onSurfaceVariant,
//                                     ),
//                           ),
//                           const SizedBox(height: 32),
//                           // BlocBuilder<PaywallBloc, PaywallState>(
//                           //   builder: (context, state) {
//                           //     if (state.isLoading) {
//                           //       return const Center(
//                           //         child: CircularProgressIndicator(),
//                           //       );
//                           //     }

//                           //     return Column(
//                           //       children: state.products.map((product) {
//                           //         return Padding(
//                           //           padding: const EdgeInsets.only(bottom: 16),
//                           //           child: _SubscriptionCard(
//                           //             product: product,
//                           //             isSelected:
//                           //                 selectedSubscriptionId == product.id,
//                           //             onSelected: (selected) {
//                           //               setState(() {
//                           //                 selectedSubscriptionId =
//                           //                     selected ? product.id : null;
//                           //               });
//                           //             },
//                           //           ),
//                           //         );
//                           //       }).toList(),
//                           //     );
//                           //   },
//                           // ),

//                           BlocConsumer<SubscriptionBloc, IAPState>(
//                             listener: (context, state) {
//                               if (state is IAPErrorState) {
//                                 ScaffoldMessenger.of(context).showSnackBar(
//                                   SnackBar(
//                                       content:
//                                           Text('Error: ${state.errorMessage}')),
//                                 );
//                               }
//                             },
//                             builder: (context, state) {
//                               if (state is ProductsFetchingState) {
//                                 return const Center(
//                                     child: CircularProgressIndicator());
//                               } else if (state is ProductsFetchedState) {
//                                 if (state.products.isEmpty) {
//                                   return Center(
//                                       child: Text('No products available.'));
//                                 }
//                                 return Column(
//                                   children: state.products.map((product) {
//                                     return ListTile(
//                                       title: Text(product.title),
//                                       subtitle: Text(product.price),
//                                       onTap: () {
//                                         // Handle product selection
//                                       },
//                                     );
//                                   }).toList(),
//                                 );
//                               }
//                               return Center(child: Text('No products loaded.'));
//                             },
//                           ),

//                           const SizedBox(height: 32),
//                           // Text(
//                           //   'Everything you need to succeed:',
//                           //   style: GoogleFonts.poppins(
//                           //     fontSize: 18,
//                           //     fontWeight: FontWeight.w600,
//                           //   ),
//                           // ),
//                           // const SizedBox(height: 16),

//                           // // Features list with icons
//                           // ..._buildFeaturesList(context),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//                 BlocBuilder<PaywallBloc, PaywallState>(
//                   builder: (context, state) {
//                     return Container(
//                       padding: const EdgeInsets.all(24),
//                       decoration: BoxDecoration(
//                         color: Theme.of(context).colorScheme.surface,
//                         boxShadow: [
//                           BoxShadow(
//                             color: Colors.black.withAlpha(12),
//                             blurRadius: 10,
//                             offset: const Offset(0, -5),
//                           ),
//                         ],
//                       ),
//                       child: Column(
//                         mainAxisSize: MainAxisSize.min,
//                         children: [
//                           FilledButton(
//                             onPressed: state.isPurchasing ||
//                                     selectedSubscriptionId == null
//                                 ? null
//                                 : () {
//                                     context
//                                         .read<PaywallBloc>()
//                                         .add(PurchaseProductEvent(
//                                           selectedSubscriptionId!,
//                                         ));
//                                   },
//                             style: FilledButton.styleFrom(
//                               minimumSize: const Size.fromHeight(56),
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(12),
//                               ),
//                             ),
//                             child: state.isPurchasing
//                                 ? const SizedBox(
//                                     height: 20,
//                                     width: 20,
//                                     child: CircularProgressIndicator(
//                                       strokeWidth: 2,
//                                     ),
//                                   )
//                                 : GestureDetector(
//                                     onTap: () {
//                                       context
//                                           .read<SubscriptionBloc>()
//                                           .add(FetchProductsEvent({
//                                             'gold_plan',
//                                             'diamond_plan',
//                                             'platinum_plan',
//                                           }));
//                                     },
//                                     child: Text(
//                                       'Subscribe',
//                                       style: GoogleFonts.poppins(
//                                         fontSize: 18,
//                                         fontWeight: FontWeight.w600,
//                                       ),
//                                     ),
//                                   ),
//                           ),
//                           const SizedBox(height: 16),
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               TextButton(
//                                 onPressed: () {
//                                   // TODO: Implement restore purchase
//                                 },
//                                 child: Text(
//                                   'Restore Purchase',
//                                   style: GoogleFonts.poppins(
//                                     fontWeight: FontWeight.w500,
//                                   ),
//                                 ),
//                               ),
//                               Container(
//                                 margin:
//                                     const EdgeInsets.symmetric(horizontal: 8),
//                                 width: 4,
//                                 height: 4,
//                                 decoration: BoxDecoration(
//                                   shape: BoxShape.circle,
//                                   color: Theme.of(context).colorScheme.outline,
//                                 ),
//                               ),
//                               TextButton(
//                                 onPressed: () {
//                                   // TODO: Show terms of service
//                                 },
//                                 child: Text(
//                                   'Terms of Service',
//                                   style: GoogleFonts.poppins(
//                                     fontWeight: FontWeight.w500,
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ],
//                       ),
//                     );
//                   },
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   List<Widget> _buildFeaturesList(BuildContext context) {
//     final features = [
//       {
//         'icon': Icons.psychology_outlined,
//         'title': 'Personalized Recovery Plan',
//         'description': 'Tailored to your specific needs and goals',
//       },
//       {
//         'icon': Icons.insights_outlined,
//         'title': 'Advanced Progress Tracking',
//         'description': 'Monitor your journey with detailed analytics',
//       },
//       {
//         'icon': Icons.group_outlined,
//         'title': 'Community Support',
//         'description': 'Connect with others on the same journey',
//       },
//       {
//         'icon': Icons.workspace_premium_outlined,
//         'title': 'Premium Content',
//         'description': 'Access exclusive meditation and therapy content',
//       },
//     ];

//     return features
//         .map((feature) => Padding(
//               padding: const EdgeInsets.only(bottom: 16),
//               child: Row(
//                 children: [
//                   Container(
//                     padding: const EdgeInsets.all(12),
//                     decoration: BoxDecoration(
//                       color: Theme.of(context).colorScheme.primaryContainer,
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                     child: Icon(
//                       feature['icon'] as IconData,
//                       color: Theme.of(context).colorScheme.primary,
//                     ),
//                   ),
//                   const SizedBox(width: 16),
//                   Expanded(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           feature['title'] as String,
//                           style: GoogleFonts.poppins(
//                             fontWeight: FontWeight.w600,
//                             fontSize: 16,
//                           ),
//                         ),
//                         Text(
//                           feature['description'] as String,
//                           style:
//                               Theme.of(context).textTheme.bodyMedium?.copyWith(
//                                     color: Theme.of(context)
//                                         .colorScheme
//                                         .onSurfaceVariant,
//                                   ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ))
//         .toList();
//   }
// }

// class _SubscriptionCard extends StatelessWidget {
//   final Product product;
//   final bool isSelected;
//   final Function(bool) onSelected;

//   const _SubscriptionCard({
//     required this.product,
//     required this.isSelected,
//     required this.onSelected,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       elevation: isSelected ? 4 : 1,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(16),
//         side: BorderSide(
//           color: isSelected
//               ? Theme.of(context).colorScheme.primary
//               : Colors.transparent,
//           width: 2,
//         ),
//       ),
//       child: InkWell(
//         onTap: () => onSelected(!isSelected),
//         borderRadius: BorderRadius.circular(16),
//         child: Container(
//           padding: const EdgeInsets.all(20),
//           child: Row(
//             children: [
//               Radio<bool>(
//                 value: true,
//                 groupValue: isSelected,
//                 onChanged: (value) => onSelected(value ?? false),
//               ),
//               const SizedBox(width: 12),
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Row(
//                       crossAxisAlignment: CrossAxisAlignment.end,
//                       children: [
//                         Text(
//                           product.title,
//                           style: GoogleFonts.poppins(
//                             fontSize: 20,
//                             fontWeight: FontWeight.bold,
//                             color: Theme.of(context).colorScheme.primary,
//                           ),
//                         ),
//                       ],
//                     ),
//                     Text(
//                       product.description,
//                       style: Theme.of(context).textTheme.bodyMedium?.copyWith(
//                             color:
//                                 Theme.of(context).colorScheme.onSurfaceVariant,
//                           ),
//                     ),
//                   ],
//                 ),
//               ),
//               const SizedBox(width: 12),
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.end,
//                 children: [
//                   Text(
//                     product.localizedPrice,
//                     style: GoogleFonts.poppins(
//                       fontSize: 22,
//                       fontWeight: FontWeight.bold,
//                       color: Theme.of(context).colorScheme.primary,
//                     ),
//                   ),
//                   Text(
//                     _getPeriodText(product.id),
//                     style: GoogleFonts.poppins(
//                       fontSize: 12,
//                       color: Theme.of(context).colorScheme.onSurfaceVariant,
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   String _getPeriodText(String productId) {
//     switch (productId) {
//       case 'monthly':
//         return 'per month';
//       case 'yearly':
//         return 'per year';
//       default:
//         return 'per period';
//     }
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import '../bloc/paywall_bloc.dart';

class PaywallScreen extends StatefulWidget {
  const PaywallScreen({super.key});

  @override
  State<PaywallScreen> createState() => _PaywallScreenState();
}

class _PaywallScreenState extends State<PaywallScreen> {
  ProductDetails? selectedProduct;

  @override
  void initState() {
    super.initState();
    context.read<SubscriptionBloc>()
      ..add(CheckIAPAvailabilityEvent())
      ..add(StartListeningToPurchaseUpdatesEvent())
      ..add(FetchProductsEvent({'gold_plan', 'diamond_plan', 'platinum_plan'}));
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SubscriptionBloc, IAPState>(
      listener: (context, state) {
        if (state is IAPErrorState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.errorMessage)),
          );
        }
        if (state is PurchaseSuccessState) {
          Navigator.popUntil(context, (route) => route.isFirst);
          Navigator.pushNamed(context, '/home');
        }
      },
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Theme.of(context).colorScheme.primaryContainer.withAlpha(76),
                Theme.of(context).colorScheme.surface,
              ],
            ),
          ),
          child: SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Choose Your Plan',
                            style: Theme.of(context)
                                .textTheme
                                .headlineMedium
                                ?.copyWith(
                                  fontFamily: GoogleFonts.poppins().fontFamily,
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Select the plan that works best for you',
                            style:
                                Theme.of(context).textTheme.bodyLarge?.copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurfaceVariant,
                                    ),
                          ),
                          const SizedBox(height: 32),
                          BlocBuilder<SubscriptionBloc, IAPState>(
                            builder: (context, state) {
                              if (state is ProductsFetchingState) {
                                return const Center(
                                    child: CircularProgressIndicator());
                              }
                              if (state is ProductsFetchedState) {
                                return Column(
                                  children: state.products.map((product) {
                                    return Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 16),
                                      child: _SubscriptionCard(
                                        product: product,
                                        isSelected:
                                            selectedProduct?.id == product.id,
                                        onSelected: (selected) {
                                          setState(() {
                                            selectedProduct =
                                                selected ? product : null;
                                          });
                                        },
                                      ),
                                    );
                                  }).toList(),
                                );
                              }
                              if (state is IAPErrorState) {
                                return Center(child: Text(state.errorMessage));
                              }
                              return const SizedBox.shrink();
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withAlpha(12),
                        blurRadius: 10,
                        offset: const Offset(0, -5),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      BlocBuilder<SubscriptionBloc, IAPState>(
                        builder: (context, state) {
                          final isProcessing =
                              state is PurchaseProcessingState ||
                                  state is RestoringPurchasesState;

                          return FilledButton(
                              onPressed: isProcessing || selectedProduct == null
                                  ? null
                                  : () {
                                      context.read<SubscriptionBloc>().add(
                                            PurchaseProductEventNew(
                                                selectedProduct!),
                                          );
                                    },
                              style: FilledButton.styleFrom(
                                minimumSize: const Size.fromHeight(56),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: isProcessing
                                  ? const SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                      ),
                                    )
                                  : Text(
                                      'Subscribe',
                                      style: GoogleFonts.poppins(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ));
                        },
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextButton(
                            onPressed: () {
                              context
                                  .read<SubscriptionBloc>()
                                  .add(RestorePurchasesEvent());
                            },
                            child: Text(
                              'Restore Purchase',
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 8),
                            width: 4,
                            height: 4,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Theme.of(context).colorScheme.outline,
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              // TODO: Show terms of service
                            },
                            child: Text(
                              'Terms of Service',
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SubscriptionCard extends StatelessWidget {
  final ProductDetails product;
  final bool isSelected;
  final Function(bool) onSelected;

  const _SubscriptionCard({
    required this.product,
    required this.isSelected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: isSelected ? 4 : 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: isSelected
              ? Theme.of(context).colorScheme.primary
              : Colors.transparent,
          width: 2,
        ),
      ),
      child: InkWell(
        onTap: () => onSelected(!isSelected),
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Radio<bool>(
                value: true,
                groupValue: isSelected,
                onChanged: (value) => onSelected(value ?? false),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          product.title,
                          style: GoogleFonts.poppins(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      product.description,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color:
                                Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    product.price,
                    style: GoogleFonts.poppins(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  Text(
                    _getPeriodText(product.id),
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getPeriodText(String productId) {
    if (productId.contains('monthly')) {
      return 'per month';
    } else if (productId.contains('yearly')) {
      return 'per year';
    } else {
      return 'per period';
    }
  }
}
