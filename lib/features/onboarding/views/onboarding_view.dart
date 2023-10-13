import 'package:fernstack/constants/app_colors.dart';
import 'package:fernstack/constants/app_strings.dart';
import 'package:fernstack/features/auth/views/login_view.dart';
import 'package:flutter/material.dart';

class OnboardingModel {
  final String assetPath;
  final String title;
  final String subTitle;
  const OnboardingModel({
    required this.assetPath,
    required this.title,
    required this.subTitle,
  });
}

final List<OnboardingModel> onboardingData = [
  const OnboardingModel(
    assetPath: AppStrings.onboardingOneAsset,
    title: AppStrings.onboardingOneTitle,
    subTitle: AppStrings.onboardingOneSubtitle,
  ),
  const OnboardingModel(
    assetPath: AppStrings.onboardingTwoAsset,
    title: AppStrings.onboardingTwoTitle,
    subTitle: AppStrings.onboardingTwoSubtitle,
  ),
  const OnboardingModel(
    assetPath: AppStrings.onboardingThreeAsset,
    title: AppStrings.onboardingThreeTitle,
    subTitle: AppStrings.onboardingThreeSubtitle,
  ),
  const OnboardingModel(
    assetPath: AppStrings.onboardingFourAsset,
    title: AppStrings.onboardingFourTitle,
    subTitle: AppStrings.onboardingFourSubtitle,
  ),
];

class OnboardingView extends StatefulWidget {
  const OnboardingView({super.key});

  @override
  State<OnboardingView> createState() => _OnboardingViewState();
}

class _OnboardingViewState extends State<OnboardingView> {
  late final PageController _pageController;
  int _pageIndex = 0;

  @override
  void initState() {
    _pageController = PageController(initialPage: 0);
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              itemCount: onboardingData.length,
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _pageIndex = index;
                });
              },
              itemBuilder: (context, index) {
                return OnboardingWidget(
                  assetPath: onboardingData[index].assetPath,
                  title: onboardingData[index].title,
                  subTitle: onboardingData[index].subTitle,
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              bottom: 50,
              left: 30,
              right: 30,
            ),
            child: Row(
              children: [
                ...List.generate(onboardingData.length, (index) {
                  return Indicator(isActive: index == _pageIndex);
                }),
                const Spacer(),
                CustomButton(
                  pageController: _pageController,
                  isLastPage: _pageIndex == onboardingData.length - 1,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class CustomButton extends StatelessWidget {
  final PageController _pageController;
  final bool isLastPage;
  const CustomButton({
    super.key,
    required PageController pageController,
    this.isLastPage = false,
  }) : _pageController = pageController;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
      width: isLastPage ? 120 : 50,
      height: 50,
      child: FilledButton(
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.deepPurple,
          padding: EdgeInsets.zero,
        ),
        child: isLastPage
            ? RichText(
                text: TextSpan(
                  text: "Log In ",
                  style: Theme.of(context)
                      .primaryTextTheme
                      .titleMedium!
                      .copyWith(fontWeight: FontWeight.w500),
                  children: const [
                    WidgetSpan(
                      child: Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: 18,
                      ),
                    )
                  ],
                ),
              )
            : const Icon(
                Icons.arrow_forward_ios_rounded,
              ),
        onPressed: () {
          if (isLastPage) {
            Navigator.push(
              context,
              LoginView.route(),
            );

            // Navigator.pushReplacement(context, LoginView.route());
          } else {
            _pageController.nextPage(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeInOut,
            );
          }
        },
      ),
    );
  }
}

class Indicator extends StatelessWidget {
  final bool isActive;
  const Indicator({
    super.key,
    this.isActive = false,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(
        milliseconds: 200,
      ),
      curve: Curves.easeInOut,
      width: isActive ? 30 : 8,
      height: 8,
      margin: const EdgeInsets.symmetric(horizontal: 2),
      decoration: BoxDecoration(
        color: isActive ? AppColors.deepPurple : AppColors.grey,
        borderRadius: BorderRadius.circular(5),
      ),
    );
  }
}

class OnboardingWidget extends StatelessWidget {
  final String assetPath;
  final String title;
  final String subTitle;
  const OnboardingWidget({
    super.key,
    required this.assetPath,
    required this.title,
    required this.subTitle,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Image.asset(
          assetPath,
          fit: BoxFit.cover,
          height: size.height * 0.65,
        ),
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          child: Text(
            title,
            textAlign: TextAlign.start,
            style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          child: Text(
            subTitle,
            textAlign: TextAlign.start,
            style: Theme.of(context)
                .textTheme
                .titleMedium!
                .copyWith(color: Colors.black54, height: 1.5),
          ),
        ),
      ],
    );
  }
}
