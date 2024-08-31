import 'package:bi_ufcg/resource/app_colors.dart';
import 'package:bi_ufcg/resource/app_padding.dart';
import 'package:bi_ufcg/screen/home/presenter/home_presenter.dart';
import 'package:flutter/material.dart';

import '../charts/responsive_layout.dart';

List<String> _buttonNames = ["Cursos", "Periodos"];
int _currentSelectedButton = 0;

class CustomAppBar extends StatefulWidget {
  HomePresenter presenter;
  CustomAppBar({super.key, required this.presenter});

  @override
  State<CustomAppBar> createState() => _CustomAppBarState();
}

class _CustomAppBarState extends State<CustomAppBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
        color: AppColors.purpleLight,
        child: Row(children: [
          if (ResponsiveLayout.isComputer(context))
            ...List.generate(
                _buttonNames.length,
                (index) => TextButton(
                    onPressed: () {
                      setState(() {
                        _currentSelectedButton = index;
                        widget.presenter.changeIndexMenu(index);
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(AppPadding.P10 * 2),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              _buttonNames[index],
                              style: TextStyle(
                                color: _currentSelectedButton == index
                                    ? Colors.white
                                    : Colors.white70,
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.all(AppPadding.P10 / 2),
                              width: 60,
                              height: 2,
                              decoration: BoxDecoration(
                                gradient: _currentSelectedButton == index
                                    ? const LinearGradient(
                                        colors: [
                                          AppColors.red,
                                          AppColors.orange,
                                        ],
                                      )
                                    : null,
                              ),
                            ),
                          ]),
                    )))
          else
            Row(
              children: [
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(AppPadding.P10 * 2),
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _currentSelectedButton = 0;
                            widget.presenter.changeIndexMenu(0);
                          });
                        },
                        child: Text(
                          _buttonNames[0],
                          style: TextStyle(
                            fontSize: 10,
                            color: _currentSelectedButton == 0
                                ? Colors.white
                                : Colors.white70,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.all(AppPadding.P10 / 2),
                      width: 60,
                      height: 2,
                      decoration: BoxDecoration(
                        gradient: _currentSelectedButton == 0
                            ? const LinearGradient(
                                colors: [
                                  AppColors.red,
                                  AppColors.orange,
                                ],
                              )
                            : null,
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(AppPadding.P10 * 2),
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _currentSelectedButton = 1;
                            widget.presenter.changeIndexMenu(1);
                          });
                        },
                        child: Text(
                          _buttonNames[1],
                          style: TextStyle(
                            fontSize: 10,
                            color: _currentSelectedButton == 1
                                ? Colors.white
                                : Colors.white70,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.all(AppPadding.P10 / 2),
                      width: 60,
                      height: 2,
                      decoration: BoxDecoration(
                        gradient: _currentSelectedButton == 1
                            ? const LinearGradient(
                                colors: [
                                  AppColors.red,
                                  AppColors.orange,
                                ],
                              )
                            : null,
                      ),
                    ),
                  ],
                )
              ],
            ),
          if (ResponsiveLayout.isComputer(context))
            Container(
              margin: const EdgeInsets.all(AppPadding.P10),
              height: double.infinity,
              decoration: const BoxDecoration(boxShadow: [
                BoxShadow(
                  color: Colors.black45,
                  offset: Offset(0, 0),
                  spreadRadius: 1,
                  blurRadius: 10,
                )
              ], shape: BoxShape.circle),
              child: CircleAvatar(
                backgroundColor: Colors.transparent,
                radius: 50,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: Image.asset(
                    "assets/images/ufcgLogo.png",
                  ),
                ),
              ),
            )
          else
            IconButton(
              color: Colors.white,
              iconSize: 30,
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
              icon: const Icon(Icons.menu),
            ),
          const SizedBox(width: AppPadding.P10),
        ]));
  }
}
