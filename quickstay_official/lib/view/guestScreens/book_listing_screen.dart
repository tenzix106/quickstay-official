import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pay/pay.dart';
import 'package:quickstay_official/global.dart';
import 'package:quickstay_official/model/posting_model.dart';
import 'package:quickstay_official/payment_gateway/payment_config.dart';
import 'package:quickstay_official/view/guest_home_screen.dart';
import 'package:quickstay_official/widgets/calendar_ui.dart';

class BookListingScreen extends StatefulWidget {
  PostingModel? posting;
  String? hostID;

  BookListingScreen({
    super.key,
    this.posting,
    this.hostID,
  });

  @override
  State<BookListingScreen> createState() => _BookListingScreenState();
}

class _BookListingScreenState extends State<BookListingScreen> {
  PostingModel? posting;
  List<DateTime> bookedDates = [];
  List<DateTime> selectedDates = [];
  List<CalendarUI> calendarWidgets = [];
  bool isPaymentInitiated = false;

  _buildCalendarWidgets() {
    for (int i = 0; i < 12; i++) {
      calendarWidgets.add(CalendarUI(
        monthIndex: i,
        bookedDates: bookedDates,
        selectDate: _selectDate,
        getSelectedDates: _getSelectedDates,
      ));

      setState(() {});
    }
  }

  List<DateTime> _getSelectedDates() {
    return selectedDates;
  }

  _selectDate(DateTime date) {
    if (selectedDates.contains(date)) {
      selectedDates.remove(date);
    } else {
      selectedDates.add(date);
    }

    selectedDates.sort();

    setState(() {});
  }

  _loadBookedDates() {
    posting!.getAllBookingsFromFirestore().whenComplete(() {
      bookedDates = posting!.getAllBookedDates();
      _buildCalendarWidgets();
    });
  }

  _makeBooking() {
    if (selectedDates.isEmpty) {
      return;
    }

    posting!
        .makeNewBooking(selectedDates, context, widget.hostID)
        .whenComplete(() {
      Get.back();
    });
  }

  calculateTotalAmount() {
    if (selectedDates.isEmpty) {
      return;
    }

    double totalBookingPrice = selectedDates.length * posting!.price!;

    bookingPrice = totalBookingPrice;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    posting = widget.posting;
    _loadBookedDates();
  }

  @override
  void dispose() {
    // reset the states when the page is exited
    isPaymentInitiated = false;
    bookingPrice = 0.0;
    paymentResult = "";
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromARGB(255, 76, 215, 208),
                Color.fromARGB(255, 164, 232, 224),
              ],
              begin: FractionalOffset(0.0, 0.0),
              end: FractionalOffset(1.0, 0.0),
              stops: [0.0, 1.0],
              tileMode: TileMode.clamp,
            ),
          ),
        ),
        title: Text(
          "Book ${posting!.name}",
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(25, 25, 25, 0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Text('Sun'),
                Text('Mon'),
                Text('Tues'),
                Text('Wed'),
                Text('Thur'),
                Text('Fri'),
                Text('Sat'),
              ],
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height / 2,
              child: (calendarWidgets.isEmpty)
                  ? Container()
                  : PageView.builder(
                      itemCount: calendarWidgets.length,
                      itemBuilder: (context, index) {
                        return AbsorbPointer(
                          absorbing: isPaymentInitiated,
                          child: calendarWidgets[index],
                        );
                      },
                    ),
            ),
            bookingPrice == 0.0
                ? MaterialButton(
                    onPressed: () {
                      setState(() {
                        calculateTotalAmount(); // refresh the UI after clicking on proceed button to display Apple / Google Pay Option
                        isPaymentInitiated =
                            true; // temporarily disable data selection
                      });
                    },
                    minWidth: double.infinity,
                    height: MediaQuery.of(context).size.height / 14,
                    color: Colors.green,
                    child: const Text(
                      'Proceed',
                      style: TextStyle(color: Colors.white),
                    ),
                  )
                : Container(),
            paymentResult != ""
                ? MaterialButton(
                    onPressed: () {
                      Get.to(GuestHomeScreen());

                      setState(() {
                        paymentResult = "";
                      });
                    },
                    minWidth: double.infinity,
                    height: MediaQuery.of(context).size.height / 14,
                    color: Colors.green,
                    child: const Text(
                      'Amount Paid Successfully',
                      style: TextStyle(color: Colors.white),
                    ),
                  )
                : Container(),
            bookingPrice == 0.0
                ? Container()
                : Platform.isIOS
                    ? ApplePayButton(
                        paymentConfiguration:
                            PaymentConfiguration.fromJsonString(
                                defaultApplePay),
                        paymentItems: [
                          PaymentItem(
                            label: 'Booking Amount',
                            amount: bookingPrice.toString(),
                            status: PaymentItemStatus.final_price,
                          )
                        ],
                        style: ApplePayButtonStyle.black,
                        width: double.infinity,
                        height: 50,
                        type: ApplePayButtonType.buy,
                        margin: const EdgeInsets.only(top: 15.0),
                        onPaymentResult: (result) {
                          print("Payment Result = $result");

                          setState(() {
                            paymentResult = result.toString();
                            isPaymentInitiated = false;
                          });

                          _makeBooking;
                        },
                        loadingIndicator: const Center(
                          child: CircularProgressIndicator(),
                        ),
                      )
                    : GooglePayButton(
                        paymentConfiguration:
                            PaymentConfiguration.fromJsonString(
                                defaultGooglePay),
                        paymentItems: [
                          PaymentItem(
                            label: 'Booking Amount',
                            amount: bookingPrice.toString(),
                            status: PaymentItemStatus.final_price,
                          )
                        ],
                        type: GooglePayButtonType.pay,
                        margin: const EdgeInsets.only(top: 15.0),
                        onPaymentResult: (result) {
                          print("Payment Result = $result");

                          setState(() {
                            paymentResult = result.toString();
                            isPaymentInitiated = false;
                          });

                          _makeBooking();
                        },
                        loadingIndicator: const Center(
                          child: CircularProgressIndicator(),
                        ),
                      ),
          ],
        ),
      ),
    );
  }
}
