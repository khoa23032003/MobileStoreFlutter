import 'package:doanthuchanh/Page/Trangchu/TrangChu.dart';
import 'package:doanthuchanh/layout/homePage.dart';
import 'package:doanthuchanh/model/history/history_detail.dart';
import 'package:doanthuchanh/model/history/history_screen.dart';
import 'package:doanthuchanh/value/app_font.dart';
import 'package:flutter/material.dart';

class Thanhcong extends StatefulWidget {
  const Thanhcong({super.key});

  @override
  State<Thanhcong> createState() => _ThanhcongState();
}

class _ThanhcongState extends State<Thanhcong> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(alignment: Alignment.center, children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(alignment: Alignment.topCenter, children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Stack(
                    alignment: Alignment.topCenter,
                    children: [
                      Center(
                        child: Container(
                          height: 350,
                          width: 400,
                          // color: backgroundColor,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(30),
                              boxShadow: const [
                                BoxShadow(
                                    color: Colors.black,
                                    blurRadius: 10,
                                    offset: Offset(0, 2))
                              ]),

                          child: const Center(
                              child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Bạn đã đặt hàng thành công !',
                                //style: AppStyles.h1,
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Center(
                                  child: Text(
                                'Đơn hàng sẽ được xử lí và gửi đi trong thời gian sớm nhất.',
                              ))
                            ],
                          )),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ]),

            //button
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Expanded(
                child: Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        flex: 1,
                        child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const HistoryScreen()));
                            },
                            child: const Padding(
                              padding: EdgeInsets.all(18.0),
                              child: Text('Xem lại đơn hàng'),
                            )),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        flex: 1,
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.grey),
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Mainpage()));
                            },
                            child: const Padding(
                              padding: EdgeInsets.all(18.0),
                              child: Text(
                                'Quay lại trang chủ',
                                style: TextStyle(color: Colors.white),
                              ),
                            )),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ]),
    );
  }
}
