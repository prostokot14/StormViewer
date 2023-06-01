//
//  TableViewController.swift
//  Project1
//
//  Created by Антон Кашников on 09.02.2023.
//

import UIKit

final class TableViewController: UITableViewController {
    // MARK: - Private Properties
    private var pictures = [String]()

    // MARK: - UIViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Storm Viewer"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareTapped))
        
        let fm = FileManager.default
        let path = Bundle.main.resourcePath!
        let items = try! fm.contentsOfDirectory(atPath: path) // in this case we got the path straight from iOS – we didn’t type it in by hand, so if reading from our own app’s bundle doesn’t work then clearly something is very wrong indeed, so that's because we use "try!"

        for item in items {
            if item.hasPrefix("nssl") {
                pictures.append(item)
            }
        }
        
        pictures.sort()
    }

    // MARK: - UITableViewController
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        pictures.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Picture", for: indexPath)
        cell.textLabel?.text = pictures[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 1: try loading the "Detail" view controller and typecasting it to be DetailViewController
        if let vc = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController {
            // 2: success! Set its selectedImage property
            vc.selectedImage = pictures[indexPath.row]
            vc.selectedPictureNumber = indexPath.row + 1
            vc.totalPictures = pictures.count
            // 3: now push it onto the navigation controller
            navigationController?.pushViewController(vc, animated: true)
        }
    }

    // MARK: - Private Methods
    @objc private func shareTapped() {
        let activityVC = UIActivityViewController(activityItems: ["Hello! This is great app! Try it now!"], applicationActivities: nil)

        if #available(iOS 16.0, *) {
            activityVC.popoverPresentationController?.sourceItem = navigationItem.rightBarButtonItem
        } else {
            activityVC.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        }

        present(activityVC, animated: true)
    }
}
