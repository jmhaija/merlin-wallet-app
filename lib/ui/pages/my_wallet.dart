import 'package:client_app/constants/color_constant.dart';
import 'package:client_app/ui/widgets/balance_widget.dart';
import 'package:client_app/ui/widgets/custom_button.dart';
import 'package:client_app/ui/widgets/transaction_history.dart';
import 'package:client_app/utils/globals.dart';
import 'package:client_app/utils/size_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:client_app/ui/widgets/connections_list_widget.dart';

class MyWalletPage extends StatefulWidget {
  const MyWalletPage({Key? key}) : super(key: key);

  @override
  MyWalletPageState createState() => MyWalletPageState();
}

class MyWalletPageState extends State<MyWalletPage> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
          backgroundColor: ColorConstant.white,
          body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            const BalanceWidget(
              flag: true,
            ),
            Padding(
              padding: getPadding(top: 24.0, left: 40, right: 15),
              child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                CustomButton(
                    height: 40,
                    width: 135,
                    text: 'Send'.tr,
                    variant: ButtonVariant.FillOrangeA500,
                    padding: ButtonPadding.PaddingT10,
                    fontStyle: ButtonFontStyle.PoppinsMedium14,
                    prefixWidget: Container(
                        margin: getMargin(right: 9), child: Icon(Icons.send_rounded, color: ColorConstant.gray50)),
                    onTap: () => {
                          if (globalSettings['environment'] == 'production')
                            showComingSoonToast()
                          else
                            Navigator.pushNamed(context, '/lookup_email')
                        }),
                CustomButton(
                    height: 40,
                    width: 135,
                    text: 'Add Funds'.tr,
                    variant: ButtonVariant.FillFountainBlue,
                    padding: ButtonPadding.PaddingT7,
                    fontStyle: ButtonFontStyle.PoppinsMedium14,
                    prefixWidget: Container(
                        margin: getMargin(right: 8),
                        child: Icon(Icons.file_upload_outlined, color: ColorConstant.gray50)),
                    onTap: () => {
                          if (globalSettings['environment'] == 'production')
                            showComingSoonToast()
                          else
                            ConnectionsListWidget().showConnectionList('load', context)
                        }),
                IconButton(
                    padding: const EdgeInsets.all(5),
                    icon: Icon(
                      Icons.more_vert,
                      color: ColorConstant.black900,
                    ),
                    onPressed: () {
                      final RenderBox renderBox = context.findRenderObject() as RenderBox;
                      final offset = renderBox.localToGlobal(Offset.zero);
                      final top = offset.dy + renderBox.size.height / 3 + 20;
                      final right = offset.dx + 30;
                      final left = right + renderBox.size.width;

                      showMenu(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
                          context: context,
                          position: RelativeRect.fromLTRB(left, top, right, 0.0),
                          items: [
                            PopupMenuItem(
                              height: 50,
                              value: 'Withdraw',
                              onTap: () => {
                                if (globalSettings['environment'] == 'production')
                                  showComingSoonToast()
                                else
                                  {
                                    ConnectionsListWidget().showConnectionList('unload', context),
                                    Navigator.pushNamed(context, '/')
                                  }
                              },
                              child: SizedBox(
                                child: Row(
                                  children: const [
                                    Icon(Icons.file_download_outlined, color: ColorConstant.darkblue),
                                    SizedBox(width: 10.0),
                                    Flexible(child: Text('Withdraw'))
                                  ],
                                ),
                              ),
                            ),
                            PopupMenuItem(
                              height: 50,
                              value: 'Pay Bill',
                              onTap: () => {debugPrint('pay bill clicked'), showComingSoonToast()},
                              child: SizedBox(
                                child: Row(
                                  children: const [
                                    Icon(Icons.receipt, color: ColorConstant.darkblue),
                                    SizedBox(width: 10.0),
                                    Flexible(child: Text('Pay bill'))
                                  ],
                                ),
                              ),
                            ),
                            PopupMenuItem(
                              height: 50,
                              value: 'Manage connections',
                              onTap: () => {
                                if (globalSettings['environment'] == 'production')
                                  showComingSoonToast()
                                else
                                  {
                                    debugPrint('manage connections button clicked'),
                                    Navigator.pushNamed(context, '/').then(
                                      (value) => Navigator.pushNamed(context, '/mybanks_page'),
                                    ),
                                  }
                              },
                              child: SizedBox(
                                child: Row(
                                  children: const [
                                    Icon(Icons.wallet_rounded, color: ColorConstant.darkblue),
                                    SizedBox(width: 10.0),
                                    Flexible(
                                        child: Text(
                                      'Manage connections',
                                    ))
                                  ],
                                ),
                              ),
                            )
                          ]);
                    })
              ]),
            ),
            const Padding(
              padding: EdgeInsets.all(20.0),
              child: TransactionHistory(),
            ),
          ],
        ),
      )),
    );
  }
}
