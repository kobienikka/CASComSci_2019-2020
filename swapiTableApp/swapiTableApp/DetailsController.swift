//
//  DetailsController.swift
//  swapiTableApp
//
//  Created by Riley Gibbs on 12/5/19.
//  Copyright © 2019 Riley Gibbs. All rights reserved.
//

import UIKit

class DetailsController: UIViewController {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var birthYear: UILabel!
    @IBOutlet weak var moviesLabel: UILabel!
    
    var character: SwapiCharacter?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameLabel.text = character!.name
        genderLabel.text = character!.gender
        birthYear.text = character!.birthYear
        moviesLabel.text = ""
        
    }
    
    @IBAction func showMovies(_ sender: UIButton) {
        //moviesLabel.text = String(character!.filmCount)
        moviesLabel.text = ""
        var filmUrls: [URL] = []
        for film in character!.films {
            if let filmUrl = URL(string: film) {
                filmUrls.append(filmUrl)
            }
        }
        for filmUrl in filmUrls {
            let task = URLSession.shared.dataTask(with: filmUrl) {
                (data, response, error) in
                let filmJson = try? JSONSerialization.jsonObject(with: data!, options: []) as? [String: Any]
                if let filmJson = filmJson, let filmTitle = filmJson["title"] as? String {
                    DispatchQueue.main.async {
                        self.moviesLabel.numberOfLines += 1
                        self.moviesLabel.text = "\(self.moviesLabel.text ?? "")\(filmTitle)\n"
                    }
                }
            }
            task.resume()
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
