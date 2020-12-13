//
//  CalendarController.swift
//  MyCalendarTest
//
//  Created by Oscar Barbosa on 11/28/20.
//

import UIKit
import FSCalendar
import FirebaseAuth
import Firebase


class CalendarViewController: UIViewController, FSCalendarDataSource, FSCalendarDelegate {
    
    @IBOutlet var calendar: FSCalendar!
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        calendar.delegate = self
        calendar.dataSource = self
        minimumDate(for: calendar)
    }

    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition){
        
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE MM/dd/YYYY"
        let date = formatter.string(from: date)
        
        createAlert(title: "Confirmation", message: "Are you sure you want to book this appointment?", date: date)
    }
    
    func minimumDate(for calendar: FSCalendar) -> Date
    {
       return Date()
    }
    
    func processBookingData(date : String){
        
        let firebaseErrorMsg = "There was an error saving booking data to firestore."
        let firebaseSuccessMsg = "Successfuly saved booking data."
        
        if let bookingSenderID = Auth.auth().currentUser?.uid{
            db.collection("bookings").addDocument(data: ["address": "Test", "date": date, "time" : "3:00PM"]) {
                (error) in
                if let e = error {
                    print(firebaseErrorMsg)
                }
                else{
                    print(firebaseSuccessMsg)
                }
            }
        }
        
        let bookingAlertTitle = "Booking Confirmed!"
        let bookingConfirmationMsg = "Your appointment was successfully booked for  \(date) at 3:00PM."
        let dismissAlertTitle = "Dismiss"
        
        let bookingAlert = UIAlertController(title: bookingAlertTitle, message: bookingConfirmationMsg, preferredStyle: .alert)
        let dismiss = UIAlertAction(title: dismissAlertTitle, style: .cancel, handler: {(action) in
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                self.navigationController?.popToRootViewController(animated: true)
            }
        })
        bookingAlert.addAction(dismiss)
        
        present(bookingAlert, animated: true)
    }
    
    func createAlert(title : String, message : String, date : String){
        
        let confirmationAlert = UIAlertController(title : title, message: message, preferredStyle: .alert)
        let actionOk = UIAlertAction(title: "Yes", style: .cancel, handler: { (action) in
            print("Yes")
            self.processBookingData(date: date)
        })
        let actionCancel = UIAlertAction(title : "No", style: .destructive, handler: {(action) in
            print("No")
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                self.navigationController?.popToRootViewController(animated: true)
            }
        })
        
        confirmationAlert.addAction(actionOk)
        confirmationAlert.addAction(actionCancel)
        
        self.present(confirmationAlert, animated: true)
    }
}
