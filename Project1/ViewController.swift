//
//  ViewController.swift
//  Project1
//
//  Created by RqwerKnot on 04/10/2022.
//

import UIKit

class ViewController: UITableViewController {
    var pictures: [String] = []
    // for USerDefaults challenge:
    var viewCounts = [String: Int]() {
        didSet {
            save()
            tableView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        title = "Storms Viewer"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let fm = FileManager.default
        let path = Bundle.main.resourcePath!
        let items = try! fm.contentsOfDirectory(atPath: path)
        
        for item in items {
            // let's check if the filename starts with "nssl"
            if item.hasPrefix("nssl") {
                // this a picture from NSSL: National Severe Storms Laboratory
                pictures.append(item)
                //viewCounts[item] = 0
            }
        }
        pictures.sort()
        print(pictures)
        
        // UserDefaults challenge:
        let defaults = UserDefaults.standard
        if let savedData = defaults.data(forKey: "viewCounts") {
            if let decodedData = try? JSONDecoder().decode([String: Int].self, from: savedData) {
                viewCounts = decodedData
            }
        }
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        pictures.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Picture", for: indexPath)
        let pictureName = pictures[indexPath.row]
        let viewCount = viewCounts[pictureName] ?? 0
        
        cell.textLabel?.text = pictureName
        cell.detailTextLabel?.text = "\(viewCount) views"
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController {
            let pictureName = pictures[indexPath.row]
            
            // for USerDefault challenge:
            viewCounts[pictureName] = (viewCounts[pictureName] ?? 0)  +  1
            
            vc.selectedImage = pictureName
            vc.imageNumber = indexPath.row + 1
            vc.ofTotalCount = pictures.count
            
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func save() {
        if let encodedData = try? JSONEncoder().encode(viewCounts) {
            let defaults = UserDefaults.standard
            
            defaults.set(encodedData, forKey: "viewCounts")
        } else {
            print("Failed to encode viewCounts")
        }
    }

}

