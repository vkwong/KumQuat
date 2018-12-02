//
//  DormChannel.swift
//  
//
//  Created by labuser on 11/25/18.
//

import UIKit

class DormChannel: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var dormPicker: UIPickerView!
    
    var dorms: [String]!
    var college: String!
    var dbHandler: DBHandler!
    var userId: Int!
    
    @IBOutlet weak var selectedDorm: UIPickerView!
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return dorms[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return dorms.count
    }
    
    

 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dbHandler = DBHandler()
        userId = UserDefaults().integer(forKey: "id")
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func joinDormChannel(_ sender: UIButton) {
        let index = selectedDorm.selectedRow(inComponent: 0)
        let dorm = dorms[index]
        if dbHandler.update(newData: dorm, id: userId!, cond: 3) && dbHandler.update(newData: college!, id: userId!, cond: 4){
            print("dorm updated to \(dorm)")
            print("college updated to \(college!)")
            UserDefaults.standard.set(dorm, forKey: "dorm")
            UserDefaults.standard.set(college!, forKey: "school")
            performSegue(withIdentifier: "dormSelected", sender: self)
        } else {
            return
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
