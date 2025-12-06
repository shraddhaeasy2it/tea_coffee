import 'package:flutter/material.dart';
import 'package:tea_coffee/Auth/login_screen.dart';

class OnboardingContent {
  final String image;
  final String title;
  final String subtitle;

  OnboardingContent({
    required this.image,
    required this.title,
    required this.subtitle,
  });
}

final onboardingItems = [
  OnboardingContent(
    image: "assets/image1.png",
    title: "Effortless Vendor Management",
    subtitle: "Add and manage tea & coffee \n"
    " vendors smoothly in one place.",
  ),
  OnboardingContent(
    image: "assets/image2.png",
    title: "Daily Sales & Deliveries",
    subtitle: "Track quantity, billing, collection and pending payments.",
  ),
  OnboardingContent(
    image: "assets/image3.png",
    title: "Business Insights",
    subtitle: "Get professional reports and insights to grow your vendor business.",
  ),
];

// MAIN ONBOARDING SCREEN

class OnboardingMain extends StatefulWidget {
  const OnboardingMain({super.key});

  @override
  State<OnboardingMain> createState() => _OnboardingMainState();
}

class _OnboardingMainState extends State<OnboardingMain> {
  final PageController _pageController = PageController();
  int currentIndex = 0;

  void _navigateToLogin() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Stack(
        children: [
          SafeArea(
            child: Column(
              children: [
                // ---------------- PAGE VIEW ----------------
                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: onboardingItems.length,
                    onPageChanged: (index) {
                      setState(() {
                        currentIndex = index;
                      });
                    },
                    itemBuilder: (context, index) {
                      return OnboardingPage(
                        image: onboardingItems[index].image,
                        title: onboardingItems[index].title,
                        subtitle: onboardingItems[index].subtitle,
                      );
                    },
                  ),
                ),

                const SizedBox(height: 8),

                // ---------------- DOT INDICATOR ----------------
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    onboardingItems.length,
                    (index) => AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      width: currentIndex == index ? 22 : 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: currentIndex == index
                            ? Theme.of(context).colorScheme.primary
                            : Theme.of(context).colorScheme.tertiary,
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // ---------------- NAV BUTTONS ----------------
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // PREVIOUS
                      TextButton(
                        onPressed: currentIndex == 0
                            ? null
                            : () {
                                _pageController.previousPage(
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.easeInOut,
                                );
                              },
                        child: Text(
                          "Previous",
                          style: TextStyle(
                            color: currentIndex == 0
                                ? const Color.fromARGB(255, 131, 131, 131)
                                : Theme.of(context).colorScheme.primary,
                                fontWeight: FontWeight.w600
                          ),
                        ),
                      ),

                      // NEXT OR FINISH
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).colorScheme.primary,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () {
                          if (currentIndex == onboardingItems.length - 1) {
                            _navigateToLogin();
                          } else {
                            _pageController.nextPage(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            );
                          }
                        },
                        child: Text(
                          currentIndex == onboardingItems.length - 1
                              ? "Finish"
                              : "Next",
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
          Positioned(
            top: 40,
            right: 20,
            child: TextButton(
              onPressed: _navigateToLogin,
              child: Text(
                'Skip',
                style: TextStyle(color: Theme.of(context).colorScheme.primary, fontSize: 18,fontWeight: FontWeight.w700),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ------------------------------------------------------------
// SINGLE ONBOARDING PAGE WIDGET
// ------------------------------------------------------------
class OnboardingPage extends StatelessWidget {
  final String image;
  final String title;
  final String subtitle;

  const OnboardingPage({
    super.key,
    required this.image,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // ---------------- TOP HALF: IMAGE ----------------
        Expanded(
          flex: 6, // Takes half of the available space
          child: Container(
            width: double.infinity,
            child: Image.asset(
              image,
              fit: BoxFit.cover, // Makes image cover the entire half
            ),
          ),
        ),

        // ---------------- BOTTOM HALF: TEXT CONTENT ----------------
        Expanded(
          flex: 4, // Takes the other half of the available space
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // TITLE
                Text(
                  title,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
        
                const SizedBox(height: 16),
        
                // SUBTITLE
                Text(
                  subtitle,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface,
                    fontSize: 16,
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}