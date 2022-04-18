//
//  ViewController.swift
//  GIPHY App - AN
//
//  Created by Alon Nasi on 18  2022.
//

import UIKit
import SwiftyGif
import AVFoundation

class GifViewController: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
//    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var gifCollectionView: UICollectionView!
    @IBOutlet weak var volumeSlider: UISlider!
    
    private let viewModel = GifViewModel()
    private let serverService = ServerService()
    private var musicPlayer = AVAudioPlayer()
    
    private var serverData: SereverModel?
    private var gifsDataArray: [GifData] = []
    private var gifSelected: GifData?
    private var currrentOffset = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        getGifs(query: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //        playMainMusic()
    }
    
    //MARK: - Setup Methods:
    private func setupView() {
        view.overrideUserInterfaceStyle = .light
        searchBar.delegate = self
        gifCollectionView.dataSource = self
        gifCollectionView.delegate = self
        gifCollectionView.register(GifCollectionViewCell.nib, forCellWithReuseIdentifier: GifCollectionViewCell.nibName)
    }
    
    private func getGifs(query: String?) {
        viewModel.getGifs(offset: currrentOffset, query: query) { model in
            if let data = model?.data {
                DispatchQueue.main.async {
                    self.serverData = model
                    self.gifsDataArray.append(contentsOf: data)
                    self.gifCollectionView.reloadData()
                }
            }
        }
    }
    
    //MARK: - Music Methods:
    private func playMainMusic() {
        let soundUrl = Bundle.main.url(forResource: "Africa", withExtension: "mp3")
        musicPlayer = try! AVAudioPlayer(contentsOf: soundUrl!)
        musicPlayer.numberOfLoops = -1
        musicPlayer.volume = volumeSlider.value
        musicPlayer.play()
    }
    
    @IBAction func volumeChanged(_ sender: UISlider) {
        musicPlayer.volume = sender.value
    }
    
}
//MARK: - Search Text Field Methods:
extension GifViewController: UISearchBarDelegate, UISearchDisplayDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        currrentOffset = 0
        gifsDataArray = []
        gifCollectionView.reloadData()
        getGifs(query: searchText)
    }
    
}

//MARK: - CollectionView Methods:
extension GifViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return gifsDataArray.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GifCollectionViewCell.nibName, for: indexPath) as! GifCollectionViewCell
        let gifUrl = gifsDataArray[indexPath.item].images.fixed_width_small.url
        if gifUrl.count >= 0 {
            cell.setupCell(gifUrl: gifUrl)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("hi, you touched me!")
        gifSelected = gifsDataArray[indexPath.item]
        performSegue(withIdentifier: "goToPreview", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToPreview" {
            let destinasionVC = segue.destination as! PreviewViewController
            destinasionVC.gifData = gifSelected
        }
    }
}

extension GifViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = CGSize(width: gifCollectionView.frame.width / 2 - 5, height: 150)
        return size
    }
}

extension GifViewController: UICollectionViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        var populateView = true
        
        let offsetY = scrollView.contentOffset.y
        let contenHeight = scrollView.contentSize.height
        let frameHeight = scrollView.frame.size.height
        if offsetY == (contenHeight - frameHeight) {
            
            if let totalGifsCount = serverData?.pagination.total_count {
                if totalGifsCount > 40 && populateView == true {
                    if currrentOffset < totalGifsCount - 40 {
                        if currrentOffset + 40 > totalGifsCount - 40 {
                            currrentOffset = totalGifsCount - 40
                        } else {
                            currrentOffset = currrentOffset + 40
                        }
                        getGifs(query: searchBar.text)
                        populateView = false
                        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false) { Timer in
                            populateView = true
                        }
                    }
                }
            }
        }
    }
    
}

