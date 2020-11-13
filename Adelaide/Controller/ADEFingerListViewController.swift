//
//  ADEFingerListViewController.swift
//  Adelaide
//
//  Created by Charles on 2020/11/13.
//

import UIKit

class ADEFingerListViewController: UIViewController, UIGestureRecognizerDelegate {

    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var searchBar: UISearchBar!

    private var fringerList = [ADEFringer]()
    private var originFingerList = [ADEFringer]()

    let frigeImageView = UIImageView()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getFringerData()
        let tap = UITapGestureRecognizer(target: self, action: #selector(clickView))
        tap.delegate = self
        view.addGestureRecognizer(tap)
    }
    
    @objc func clickView() {
        view.endEditing(true)
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if searchBar.isFirstResponder {
            return true
        }
        return false
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetailFinger" {
            if let indexPath = collectionView.indexPathsForSelectedItems?.first, let detailVC = segue.destination as? ADEFringerDetailViewController {
                let finger = fringerList[indexPath.item]
                detailVC.finger =  finger
                detailVC.delegate = self
            }
        } else if segue.identifier == "showRandom" {
            if let randomVC = segue.destination as? ADEFingerRandomViewController {
                randomVC.fingerList = fringerList
                randomVC.delegate = self
            }
        }
    }

}

extension ADEFingerListViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.fringerList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ADEFingerListCell", for: indexPath) as! ADEFingerListCell
        let url = URL(string: "http://www.partiklezoo.com/fringer/images/\(self.fringerList[indexPath.item].image)")!
        cell.urlImgView.kf.setImage(with: url)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.size.width/2 - 10;
        return CGSize(width: width, height: 9/16.0*width)

    }


}

extension ADEFingerListViewController: ADEFringerDetailDelegate {
    func clickInsterested(fingerId: String, name: String) {
        let b = UserDefaults.standard.bool(forKey: "HasSendInterestedFor\(fingerId)")
        if b {
            _ = SCLAlertView().showWarning("Notices", subTitle: "You have sended for \(name) once")
            return
        }
        
        guard let url = URL(string: "http://partiklezoo.com/fringer/?action=register") else { return }

        LoadingIndicatorView.show()

        let dataTask = URLSession.shared.dataTask(with: url) { (data, urlResponse, error) in
            DispatchQueue.main.async {
                if error == nil {
                    _ = SCLAlertView().showSuccess("Notices", subTitle: "You have sended for \(name) once")
                }
                UserDefaults.standard.set(true, forKey: "HasSendInterestedFor\(fingerId)")
                UserDefaults.standard.synchronize()
                LoadingIndicatorView.hide()
            }

        }
        dataTask.resume()

    }
    
    func clickLike(fingerId: String, complection: @escaping (String, String) -> Void) {
        let b = UserDefaults.standard.bool(forKey: "Replace")

        let urlString = b ? "http://partiklezoo.com/fringer/?action=rate&rating=like&id=\(fingerId)&replace=true" : "http://partiklezoo.com/fringer/?action=rate&rating=like&id=\(fingerId)"
        
        guard let url = URL(string: urlString) else {
            return
        }
        LoadingIndicatorView.show()
        let dataTask = URLSession.shared.dataTask(with: url) { (data, urlResponse, error) in
            DispatchQueue.main.async {
                LoadingIndicatorView.hide()
                if (error != nil) { return }
                if let data = data, let dic = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? Dictionary<String, String> {
                   let like = ADELike()
                    like.setValuesForKeys(dic)
                    complection(like.likes, like.dislikes);

                }
            }

        }
        dataTask.resume()

    }
    
    func clickDislike(fingerId: String, complection: @escaping (String, String) -> Void) {
        let b = UserDefaults.standard.bool(forKey: "Replace")
        let urlString = b ? "http://partiklezoo.com/fringer/?action=rate&rating=dislike&id=\(fingerId)&replace=true" : "http://partiklezoo.com/fringer/?action=rate&rating=dislike&id=\(fingerId)"
        guard let url = URL(string: urlString) else { return }
        LoadingIndicatorView.show()
        let dataTask = URLSession.shared.dataTask(with: url) { (data, urlResponse, error) in
            DispatchQueue.main.async {
                LoadingIndicatorView.hide()
                if (error != nil) { return }
                if let data = data, let dic = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? Dictionary<String, String> {
                   let like = ADELike()
                    like.setValuesForKeys(dic)
                    complection(like.likes, like.dislikes);
                }
            }

        }
        dataTask.resume()

    }
    
}

extension ADEFingerListViewController {
    fileprivate func getFringerData() {
        guard let url = URL(string: "http://www.partiklezoo.com/fringer/?") else { return }
        LoadingIndicatorView.show()
        let dataTask = URLSession.shared.dataTask(with: url) { (data, urlResponse, error) in
            DispatchQueue.main.async {
                LoadingIndicatorView.hide()
                if (error != nil) { return }
                if let data = data, let array = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? Array<Dictionary<String, String>> {
                    self.fringerList.removeAll()
                    for dictionary in array {
                        let fringer = ADEFringer()
                        fringer.setValuesForKeys(dictionary)
                        fringer.desc = dictionary["description"] ?? ""
                        self.fringerList.append(fringer)
                    }
                    self.originFingerList = self.fringerList

                    self.collectionView.reloadData()
                }
            }

        }
        dataTask.resume()

    }
}


extension ADEFingerListViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if searchBar.text?.count == 0 {
            fringerList = originFingerList
        } else {
            fringerList = originFingerList.filter({ model -> Bool in
                return (model.name.contains(searchBar.text ?? "")) || (model.artist.contains(searchBar.text ?? "")) || (model.venue.contains(searchBar.text ?? ""))
            })
        }

        collectionView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        fringerList = originFingerList
        collectionView.reloadData()
    }
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if (searchText.count == 0) {
            fringerList = originFingerList
        } else {
            fringerList = originFingerList.filter({ model -> Bool in
                return (model.name.contains(searchText) || model.artist.contains(searchText) || model.venue.contains(searchText))
            }).sorted(by: { (model1, model2) -> Bool in
                return model1.name.compare(model2.name) == .orderedAscending
//                        && model1.likes.compare(model2.name) == .orderedDescending
            })
        }

        collectionView.reloadData()
    }
}
