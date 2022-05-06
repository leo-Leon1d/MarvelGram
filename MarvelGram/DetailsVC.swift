//
//  DetailsVC.swift
//  MarvelGram
//
//  Created by Леонид Исраелян on 25.04.2022.
//

import UIKit
import SDWebImage

class DetailsVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    
    
    @IBOutlet weak var collectionViewEM: UICollectionView!
    var hero: Model?
    
    var filteredHeroes: [Model] = []
    
    @IBOutlet weak var heroDescription: UILabel!
    
    @IBOutlet weak var mainImage: UIImageView!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        collectionViewEM.delegate = self
        collectionViewEM.dataSource = self
        
        self.title = hero!.name
        
        self.heroDescription.text = hero!.description
        
        self.mainImage.sd_setImage(with: URL(string: hero!.thumbnail.path + "." + hero!.thumbnail.extension), completed: nil)
        
        let decoder = JSONDecoder()
        
        if let data = UserDefaults.standard.data(forKey: "heroesInfo"),
           let array = try? decoder.decode([Model].self, from: data) {
            filteredHeroes = array.filter {$0.id != hero!.id}.shuffled()
        }
        
        print(filteredHeroes)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filteredHeroes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell: HeroesCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "BottomHeroes", for: indexPath) as! HeroesCollectionViewCell
        
        let item = filteredHeroes[indexPath.row]
        
        cell.imageViewCell.sd_setImage(with: URL(string: item.thumbnail.path + "." + item.thumbnail.extension), completed: nil)
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 120, height: 120)
    }
    
}
