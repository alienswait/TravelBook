//
//  ListViewController.swift
//  TravelBook
//
//  Created by Mertcan Ünek on 20.07.2023.
//

import UIKit
import CoreData

class ListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    

    @IBOutlet weak var tableView: UITableView!
    
    var titleArray = [String]()
    var idArrray = [UUID]()
    var choosenTitle = ""
    var choosenTitleId: UUID?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.add, target: self, action: #selector(addButtonClicked))
        tableView.delegate = self
        tableView.dataSource = self
        
        getData()
    }
    
    func getData(){
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Places")
        request.returnsObjectsAsFaults = false
        
        do{
            let results = try context.fetch(request)
            
            if results.count > 0 {
                
                self.titleArray.removeAll(keepingCapacity: false)
                self.idArrray.removeAll(keepingCapacity: false)
                
                for result in results as! [NSManagedObject] {
                    if let title = result.value(forKey: "title") as? String {
                        self.titleArray.append(title)
                    }
                    
                    if let id = result.value(forKey: "id") as? UUID {
                        self.idArrray.append(id)
                    }
                    
                    tableView.reloadData()
                }
            }
                
                
        }catch{
            print("error")
        }
        
    }
    
    @objc func addButtonClicked(){
        
        choosenTitle = ""
        
        performSegue(withIdentifier: "toViewController", sender: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titleArray.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = titleArray[indexPath.row]
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        choosenTitle = titleArray[indexPath.row]
        choosenTitleId = idArrray[indexPath.row]
        
        performSegue(withIdentifier: "toViewController", sender: nil)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toViewController"{
            let destinationVc = segue.destination as! ViewController
            destinationVc.selectedTitle = choosenTitle
            destinationVc.selectedTitleId = choosenTitleId
        }
    }
    
    
    
    
    
    


   

}
