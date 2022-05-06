//
//  ViewController.swift
//  MarvelGram
//
//  Created by Леонид Исраелян on 13.04.2022.
//

import UIKit
import SDWebImage

class GalleryVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    private let stringUrl = "https://static.upstarts.work/tests/marvelgram/klsZdDg50j2.json"
    
    var heroesInfo: [Model] = []
    
    var filteredHeroesInfo: [Model] = []
    
    var selectedHero: Model?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        setupNavigation()
        
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        
        self.searchBar.delegate = self
        
        let decoder = JSONDecoder()
        
        if let data = UserDefaults.standard.data(forKey: "heroesInfo"), let
            heroesInfo = try? decoder.decode([Model].self, from: data) {
            self.heroesInfo = heroesInfo
            self.filteredHeroesInfo = heroesInfo
            
        } else {
            
            getMarvelInfo()
            
        }
        
    }
    
    
    private func setupNavigation() {
        let navBar  = navigationController?.navigationBar
        navBar?.barTintColor = .clear
        navBar?.tintColor = .white
        let marvelLogo = UIImageView(frame: CGRect(x: 0, y: 0, width: 75, height: 30))
        marvelLogo.image = UIImage(named: "marvel-logo")
        marvelLogo.contentMode = .scaleAspectFit
        
        let imageItem = UIBarButtonItem(customView: marvelLogo)
        navigationItem.leftBarButtonItem = imageItem
        navigationItem.backButtonTitle = ""
    }
    
    
    private func getMarvelInfo() {
        
        guard let url = URL(string: stringUrl) else { return }
        let request = URLRequest(url: url)
        URLSession.shared.dataTask(with: request) { [weak self]
            
            data, responce, error in
            
            guard let this = self else { return }
            
            if let error = error {
                print(error)
                return
            }
            
            guard let data = data else { return }
            
            do {
                let keys = try JSONDecoder().decode([Model].self, from: data)
                print(keys[0])
                
                this.heroesInfo = keys.filter {
                    !$0.thumbnail.path.contains("image_not_available")
                }
                
                this.filteredHeroesInfo = this.heroesInfo
                
                let encoder = JSONEncoder()
                
                if let results: Data = try? encoder.encode(this.heroesInfo) {
                    
                    UserDefaults.standard.set(results, forKey: "heroesInfo")
                    
                }
                
            }
            
            catch {
                print(error)
            }
            
            DispatchQueue.main.async {
                this.collectionView.reloadData()
            }
            
        }
        
        .resume()
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        
        let itemsPerRow: CGFloat = 3
        let collectionViewWidth: CGFloat = collectionView.frame.width
        let widthPerItem: CGFloat = collectionViewWidth / itemsPerRow
        return CGSize(width: widthPerItem, height: widthPerItem)
        
        //return CGSize(width: 120, height: 120)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let hero = filteredHeroesInfo[indexPath.row]
        
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "gallery") as! DetailsVC
        
        vc.hero = hero
        
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filteredHeroesInfo.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell: HeroesCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "Heroes", for: indexPath) as! HeroesCollectionViewCell
        
        let heroFromBackend = filteredHeroesInfo[indexPath.row]
        
        cell.imageViewCell.sd_setImage(with: URL(string: heroFromBackend.thumbnail.path + "." + heroFromBackend.thumbnail.extension), completed: nil)
        
        return cell
    }
    
    /* func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
     var hero = heroesInfo[indexPath.row]
     hero = selectedHero
     }
     */
    
}

extension GalleryVC: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if !searchText.isEmpty {
            filteredHeroesInfo = heroesInfo.filter {
                $0.name.lowercased().contains(searchText.lowercased())
            }
            collectionView.reloadData()
            
        } else {
            
            filteredHeroesInfo = heroesInfo
            collectionView.reloadData()
            
        }
    }
    
}

