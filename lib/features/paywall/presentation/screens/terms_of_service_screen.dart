import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TermsOfServiceScreen extends StatelessWidget {
  const TermsOfServiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Terms of Service',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Last Updated: ${DateTime.now().year}',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(height: 24),
            _buildSection(
              context,
              'Subscription Terms',
              'By subscribing to Quittr, you agree to the following terms:\n\n'
                  '• Subscription automatically renews unless auto-renew is turned off at least 24-hours before the end of the current period\n'
                  '• Your account will be charged for renewal within 24-hours prior to the end of the current period\n'
                  '• You can manage your subscription and turn off auto-renewal by going to your Account Settings after purchase',
            ),
            const SizedBox(height: 24),
            _buildSection(
              context,
              'Privacy Policy',
              'We respect your privacy and are committed to protecting your personal data. Our app collects minimal information necessary for the functioning of the service.',
            ),
            const SizedBox(height: 24),
            _buildSection(
              context,
              'Cancellation Policy',
              'You can cancel your subscription at any time through your device\'s subscription management settings. Refunds are subject to the platform\'s (Apple/Google) refund policies.',
            ),
            const SizedBox(height: 24),
            _buildSection(
              context,
              'Contact Us',
              'If you have any questions about these Terms, please contact us at support@quittr.com',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(BuildContext context, String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          content,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                height: 1.5,
              ),
        ),
      ],
    );
  }
}
