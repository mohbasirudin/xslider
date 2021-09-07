library xslider;

import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class XSlider {
  static builder({
    required int initialPage,
    required int maxLength,
    double? height,
    bool full = false,
    EdgeInsets? margin,
    bool enableBouncing = true,
    double? rounded,
    bool showIndicator = true,
    Color? colorIndicatorActive,
    bool showButton = false,
    bool indicatorText = false,
    bool autoSlide = true,
    int slideInterval = 5,
    bool buttonCircle = true,
    Alignment? indicatorPosition,
    Color? colorIndicatorDeadactive,
    required Function(BuildContext, int) itemBuilder,
    bool infinityScrolling = false,
  }) {
    PageController pageController = PageController(
      initialPage: initialPage,
      viewportFraction: full ? 1 : 0.8,
    );

    RxInt currentIndex = initialPage.obs;

    bool isIndicatorCircle = !indicatorText;
    bool isButtonCircle = buttonCircle;

    if (autoSlide) {
      Timer.periodic(Duration(seconds: slideInterval), (timer) {
        if (currentIndex.value < (maxLength - 1)) {
          currentIndex.value++;
          pageController.animateToPage(
            currentIndex.value,
            duration: Duration(milliseconds: 500),
            curve: Curves.linear,
          );
        } else {
          if (infinityScrolling) {
            currentIndex.value = 0;
            pageController.jumpToPage(0);
          }
        }
      });
    }

    List<int> indicators = [];
    for (var i = 0; i < maxLength; i++) {
      indicators.add(i);
    }
    return Obx(
      () {
        // print('${currentIndex.value}');

        return Container(
          margin: margin ?? EdgeInsets.zero,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: height ?? Get.width / 2,
                child: Stack(
                  children: [
                    Container(
                      child: PageView.builder(
                        itemCount: maxLength,
                        pageSnapping: true,
                        controller: pageController,
                        physics: enableBouncing
                            ? BouncingScrollPhysics()
                            : AlwaysScrollableScrollPhysics(),
                        onPageChanged: (value) => currentIndex.value = value,
                        itemBuilder: (context, index) => Transform.scale(
                          scale: full
                              ? 1
                              : currentIndex.value == index
                                  ? 0.9
                                  : 0.8,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(rounded ?? 0),
                            child: Container(
                              color: Colors.red,
                              child: itemBuilder(context, index),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Center(
                      child: Visibility(
                        visible: showButton,
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 24),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Visibility(
                                visible: currentIndex.value > 0,
                                child: _buttonArrow(
                                  isCircle: isButtonCircle,
                                  isLeft: true,
                                  onTap: () {
                                    if (currentIndex.value > 0) {
                                      currentIndex.value--;
                                      pageController.animateToPage(
                                          currentIndex.value,
                                          duration: Duration(milliseconds: 500),
                                          curve: Curves.linear);
                                    }
                                  },
                                ),
                              ),
                              Visibility(
                                visible: infinityScrolling ||
                                    currentIndex.value < (maxLength - 1),
                                child: _buttonArrow(
                                  isCircle: isButtonCircle,
                                  onTap: () {
                                    if (currentIndex.value < (maxLength - 1)) {
                                      currentIndex.value++;
                                      pageController.animateToPage(
                                          currentIndex.value,
                                          duration: Duration(milliseconds: 500),
                                          curve: Curves.linear);
                                    } else {
                                      if (infinityScrolling) {
                                        currentIndex.value = 0;
                                        pageController.jumpToPage(0);
                                      }
                                    }
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Visibility(
                visible: showIndicator,
                child: Container(
                  height: 24,
                  constraints: BoxConstraints(
                    minWidth: 80,
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  alignment: indicatorPosition ?? Alignment.center,
                  child: !isIndicatorCircle
                      ? Row(
                          mainAxisSize: MainAxisSize.min,
                          children: indicators.map(
                            (i) {
                              // double size = currentIndex.value == i ? 8 : 6;
                              double size = 8;
                              return Container(
                                margin: EdgeInsets.all(2),
                                width: size,
                                height: size,
                                decoration: BoxDecoration(
                                  color: currentIndex.value == i
                                      ? colorIndicatorActive ?? Colors.blueGrey
                                      : colorIndicatorDeadactive ??
                                          Colors.grey.shade300,
                                  shape: BoxShape.circle,
                                ),
                              );
                            },
                          ).toList(),
                        )
                      : Text(
                          "${currentIndex.value + 1}/$maxLength",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.blueGrey,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  static Widget _buttonArrow({
    bool isLeft = false,
    required var onTap,
    required var isCircle,
  }) {
    double size = 40;
    return Container(
      width: size,
      height: size,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(isCircle ? 80 : 8),
        child: Material(
          color: Colors.blueGrey.shade100,
          child: InkWell(
            child: Center(
              child: Icon(
                isLeft ? Icons.arrow_left : Icons.arrow_right,
                color: Colors.white,
                size: 28,
              ),
            ),
            onTap: onTap,
          ),
        ),
      ),
    );
  }
}
