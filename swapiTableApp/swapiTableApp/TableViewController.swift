//
//  TableViewController.swift
//  swapiTableApp
//
//  Created by Riley Gibbs on 12/5/19.
//  Copyright © 2019 Riley Gibbs. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {
    
    var people: [SwapiCharacter]?
    let BASE_URL = "https://swapi.co/api/people/?page="
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tasks: [URLSessionTask?] = (1...9).map({(page: Int) in getCharactersPage(pageNum: page)})
        people = []
        for task in tasks {
            if let task = task {
                task.resume()
            }
        }
        
    }
    
    func getCharactersPage(pageNum: Int) -> URLSessionTask? {
        guard let url: URL = URL(string: "\(BASE_URL)\(pageNum)") else { return nil }
        let task = URLSession.shared.dataTask(with: url) {
            (data, response, error) in
            guard let httpResponse = response as? HTTPURLResponse,
                (200...299).contains(httpResponse.statusCode),
                let data = data,
                let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                else {
                    return
            }
            guard let characters = json["results"] as? [[String: Any]] else {
                return
            }
            for character in characters {
                if let parsedCharacter = self.parseSwapiCharacter(character) {
                    self.people?.append(parsedCharacter)
                }
            }
            self.people?.sort(by: {(a, b) in a.name < b.name})
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        return task
    }
    
    func parseSwapiCharacter(_ character: [String: Any]) -> SwapiCharacter? {
        guard let name = character["name"] as? String,
            let gender = character["gender"] as? String,
            let birthYear = character["birth_year"] as? String,
            let films = character["films"] as? [String],
            let species = character["species"] as? [String]
            else {
            return nil
        }
        let person = SwapiCharacter(name: name, gender: gender, films: films, species: species, birthYear: birthYear)
        return person
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return people!.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

        // Configure the cell...
        if indexPath.row < people!.count {
            let name = people![indexPath.row].name
            cell.textLabel?.text = name
        } else {
            cell.textLabel?.text = "Error!"
        }
        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        let destination = segue.destination as! DetailsController
        destination.character = self.people![self.tableView.indexPathForSelectedRow!.row]
    }
}
