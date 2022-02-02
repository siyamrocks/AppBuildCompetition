/*
This is the code to see social status for GCPS schools.
*/

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_starter/models/models.dart';
import 'package:flutter_starter/ui/components/segmented_selector.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:webview_flutter/webview_flutter.dart';

class Social extends StatefulWidget {
  @override
  _SocialState createState() => _SocialState();
}

class _SocialState extends State<Social> {
  String currentOption = "0"; // Selected option

  // List of options user can choose.
  final List<MenuOptionsModel> options = [
    MenuOptionsModel(
        key: "0", value: "Twitter", icon: FontAwesomeIcons.twitter),
    MenuOptionsModel(
        key: "1", value: "Facebook", icon: FontAwesomeIcons.facebook),
  ];

  // Controller for WebView widget.
  WebViewController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Center(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 5),
            // Show options users can choose.
            child: SegmentedSelector(
              selectedOption: currentOption,
              menuOptions: options,
              onValueChanged: (value) {
                setState(() {
                  currentOption = value;
                  String html;
                  // Show Twitter
                  if (currentOption == "0") {
                    html =
                        '<a class="twitter-timeline" href="https://twitter.com/GwinnettSchools?ref_src=twsrc%5Etfw">Tweets by GwinnettSchools</a> <script async src="https://platform.twitter.com/widgets.js" charset="utf-8"></script>';
                  }
                  // Show Facebook
                  if (currentOption == "1") {
                    html =
                        '<iframe class="iframe-fb border" style="width:100%; height:100%" scrolling="no" frameborder="0" allowTransparency="true" allow="encrypted-media" src="https://www.facebook.com/plugins/page.php?href=https%3A%2F%2Fwww.facebook.com%2FGwinnettSchools%2F&tabs=timeline"></iframe>';
                  }
                  controller.loadUrl(Uri.dataFromString(html,
                          mimeType: 'text/html', encoding: utf8)
                      .toString());
                });
              },
            ),
          ),
        ),
        Expanded(
            child: WebView(
          javascriptMode: JavascriptMode.unrestricted,
          initialUrl: "about:blank",
          onWebViewCreated: (webController) {
            // Load default social media (Twitter)
            controller = webController;
            controller.loadUrl(Uri.dataFromString(
                    '<a class="twitter-timeline" href="https://twitter.com/GwinnettSchools?ref_src=twsrc%5Etfw">Tweets by GwinnettSchools</a> <script async src="https://platform.twitter.com/widgets.js" charset="utf-8"></script>',
                    mimeType: 'text/html',
                    encoding: utf8)
                .toString());
          },
        ))
      ],
    );
  }
}
