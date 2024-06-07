//
//  ViewController.swift
//  MyReminders
//
//  Created by isurajparmar85 on 19/05/2024.
//

import UserNotifications
import UIKit

class ViewController: UIViewController {

    @IBOutlet var table: UITableView!
    
    var models = [MyReminder]()
    override func viewDidLoad() {
        super.viewDidLoad()
    
        table.delegate = self
        table.dataSource = self
        // Do any additional setup after loading the view.
    }
    @IBAction func didTapAdd() {
        //show AddViewController
        guard let vc = storyboard?.instantiateViewController(identifier: "add") as? AddViewController else {
            return
            }
        
        vc.title = "New Reminder"
        vc.navigationItem.largeTitleDisplayMode = .never
        vc.completion = {title, body, date in
            DispatchQueue.main.async {
                self.navigationController?.popToRootViewController(animated: true)
                let newReminder = MyReminder(title: title, body: body, date: date)
                self.models.append(newReminder)
                self.table.reloadData()
                
                let content = UNMutableNotificationContent()
                content.title = title
                content.sound = .default
                content.body = body
                let targetDate = date
                
                let trigger = UNCalendarNotificationTrigger(dateMatching: Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: targetDate), repeats: false)
                let request = UNNotificationRequest(identifier: "someLongId", content: content, trigger: trigger)
                UNUserNotificationCenter.current().add(request, withCompletionHandler: { error in
                    if error != nil {
                        print("Something went wrong.")
                    }
                })
            }
        }
        navigationController?.pushViewController(vc, animated: true)
    }

    @IBAction func didTapTest() {
        //fire notification for test purposes
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound], completionHandler: { success, error in
            if success {
                //schedule test
                self.scheduleTest()
            }
            else if error != nil {
                print("Error occured!")
            }
        })
    }
    
    func scheduleTest() {
        let content = UNMutableNotificationContent()
        content.title = "Title"
        content.sound = .default
        content.body = "Very Long Body Very Long Body Very Long Body Very Long Body "
        let targetDate = Date().addingTimeInterval(10)
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: targetDate), repeats: false)
        let request = UNNotificationRequest(identifier: "someLongId", content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: { error in
            if error != nil {
                print("Something went wrong.")
            }
        })
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension ViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = models[indexPath.row].title
        let date = models[indexPath.row].date
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM, dd, YYYY at hh:mm a"
        cell.detailTextLabel?.text = formatter.string(from: date)
        return cell
    }
    
}

struct MyReminder {
    let title: String
    let body: String
    let date: Date
    
}
