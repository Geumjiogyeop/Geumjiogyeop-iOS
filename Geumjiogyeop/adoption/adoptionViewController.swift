import UIKit
import Alamofire
import SwiftyJSON

struct AllAdoption: Codable {
    let adoption_id: Int
    let name: String
    let gender: String
    let age: Int
    let center: String
    let introduction: String
    let photo: String
    let likes: Int
}

class adoptionViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {


    
    @IBOutlet weak var adoptionavalableButton: CategoryButton!
    @IBOutlet weak var regionButton: CategoryButton!
    @IBOutlet weak var speciesButton: CategoryButton!
    @IBOutlet weak var genderButton: CategoryButton!
    @IBOutlet weak var adoptionCollectionView: UICollectionView!

    var adoptions: [AllAdoption] = [] // 서버에서 가져온 입양 정보를 저장할 배열
    
    enum AdoptionStatus {
        case all
        case available
        case unavailable
    }
    
    struct Region {
        let title: String
        let localizedTitle: String
    }
    
    enum Species {
        case all
        case dog
        case cat
    }
    
    enum Gender{
        case all
        case female
        case male
    }
    
    var posts: String = "dkdkdk"
    
    let regions: [Region] = [
        Region(title: "all", localizedTitle: "지역"),
        Region(title: "seoul", localizedTitle: "서울특별시"),
        Region(title: "gyeonggi", localizedTitle: "경기도"),
        Region(title: "incheon", localizedTitle: "인천광역시"),
        Region(title: "daejeon", localizedTitle: "대전광역시"),
        Region(title: "daegu", localizedTitle: "대구광역시"),
        Region(title: "busan", localizedTitle: "부산광역시"),
        Region(title: "ulsan", localizedTitle: "울산광역시"),
        Region(title: "gangwon", localizedTitle: "강원도"),
        Region(title: "chungcheongbuk", localizedTitle: "충청북도"),
        Region(title: "chungcheongnam", localizedTitle: "충청남도"),
        Region(title: "jeollabuk", localizedTitle: "전라북도"),
        Region(title: "jeollanam", localizedTitle: "전라남도"),
        Region(title: "gyeongsangbuk", localizedTitle: "경상북도"),
        Region(title: "gyeongsangnam", localizedTitle: "경상남도"),
        Region(title: "jeju", localizedTitle: "제주특별자치도")
    ]
    
    var currentAdoptionStatus: AdoptionStatus = .all
    var currentRegion: Region?
    var currentSpecies: Species = .all
    var currentGender: Gender = .all
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setPopupButton()
        adoptionCollectionView.dataSource = self
        adoptionCollectionView.delegate = self
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        adoptionCollectionView.collectionViewLayout = layout
        
        // 서버에서 입양 정보 가져오기
        getAdoptions()
    }

    override func viewDidLayoutSubviews() {
         super.viewDidLayoutSubviews()
         
         // 컬렉션 뷰 가로 크기 설정
         if let flowLayout = adoptionCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
             flowLayout.itemSize = CGSize(width: adoptionCollectionView.bounds.width - 48, height: 150)
         }
     }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return adoptions.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "adoptionCell", for: indexPath) as! adoptionCell
        
        let adoption = adoptions[indexPath.row]
        cell.adoptionNameLabel.text = adoption.name
        cell.infoLabel.text = "\(adoption.gender) / \(adoption.age)세"
        cell.centerLabel.text = adoption.center
        cell.introductionLabel.text = "\"\(adoption.introduction)\""
        
        let baseURL = "http://175.45.194.93"
        if let imageUrl = URL(string: adoption.photo) {
                    // 이미지를 비동기적으로 가져오기
                    AF.request(imageUrl).responseData { response in
                        switch response.result {
                        case .success(let imageData):
                            if let image = UIImage(data: imageData) {
                                cell.imageView.image = image
                            } else {
                                cell.imageView.image = nil
                            }
                        case .failure(let error):
                            print("Image loading error: \(error)")
                            cell.imageView.image = nil
                        }
                    }
                } else {
                    cell.imageView.image = nil // 이미지 로딩 실패 시 기본 이미지 또는 빈 이미지 설정
                }
        
        return cell
    }
    
    // 서버에서 입양 정보 가져오는 함수
    func getAdoptions() {
        let url = "http://175.45.194.93/adoption/"
        
        AF.request(url, method: .get).responseJSON { response in
            switch response.result {
            case .success(let value):
                if let jsonArray = JSON(value).array {
                    for json in jsonArray {
                        if let data = try? json.rawData(),
                           let adoption = try? JSONDecoder().decode(AllAdoption.self, from: data) {
                            self.adoptions.append(adoption)
                        }
                    }
                    self.adoptionCollectionView.reloadData()
                }
                print("API Sucess")
            case .failure(let error):
                print("API Failure: \(error)")
            }
        }
    }

    
    func setPopupButton() {
        setAdoptionStatusMenu()
        setRegionMenu()
        setSeciesMenu()
        setGenderMenu()
    }
    
    func setAdoptionStatusMenu() {
        let statusMenu = UIMenu(children: [
            UIAction(title: "입양 가능 상태", handler: { [weak self] _ in
                self?.currentAdoptionStatus = .all
                self?.updateButtonAppearance()
                print("입양 가능 상태 선택")
            }),
            UIAction(title: "입양 가능", handler: { [weak self] _ in
                self?.currentAdoptionStatus = .available
                self?.updateButtonAppearance()
                print("입양 가능 선택")
            }),
            UIAction(title: "입양 불가능", handler: { [weak self] _ in
                self?.currentAdoptionStatus = .unavailable
                self?.updateButtonAppearance()
                print("입양 불가능 선택")
            })
        ])
        
        adoptionavalableButton.menu = statusMenu
        adoptionavalableButton.showsMenuAsPrimaryAction = true
    }
    
    func setRegionMenu() {
            var regionMenuItems: [UIAction] = []
            for region in regions {
                regionMenuItems.append(UIAction(title: region.localizedTitle, handler: { [weak self] _ in
                    if region.title == "all" {
                        self?.currentRegion = nil
                    } else {
                        self?.currentRegion = region
                    }
                    self?.updateButtonAppearance()
                    self?.updateRegionButtonTitle() // 추가: 지역 버튼 타이틀 업데이트
                    print("지역 선택: \(region.localizedTitle)")
                }))
            }
            
            let regionMenu = UIMenu(children: regionMenuItems)
            
            regionButton.menu = regionMenu
            regionButton.showsMenuAsPrimaryAction = true
        }
    
    func setSeciesMenu() {
        let speciesMenu = UIMenu(children: [
            UIAction(title: "종류", handler: { [weak self] _ in
                self?.currentSpecies = .all
                self?.updateSpeciesButton()
                print("종류 선택")
            }),
            UIAction(title: "강아지", handler: { [weak self] _ in
                self?.currentSpecies = .dog
                self?.updateSpeciesButton()
                print("강아지 선택")
            }),
            UIAction(title: "고양이", handler: { [weak self] _ in
                self?.currentSpecies = .cat
                self?.updateSpeciesButton()
                print("고양이 선택")
            })
        ])
        
        speciesButton.menu = speciesMenu
        speciesButton.showsMenuAsPrimaryAction = true
    }
    
    func setGenderMenu(){
        let genderMenu = UIMenu(children: [
            UIAction(title: "성별", handler: { [weak self] _ in
                self?.currentGender = .all
                self?.updateGenderButton()
                print("성별 선택")
            }),
            UIAction(title: "여아", handler: { [weak self] _ in
                self?.currentGender = .female
                self?.updateGenderButton()
                print("여아 선택")
            }),
            UIAction(title: "남아", handler: { [weak self] _ in
                self?.currentGender = .male
                self?.updateGenderButton()
                print("남아 선택")
            })
        ])
        
        genderButton.menu = genderMenu
        genderButton.showsMenuAsPrimaryAction = true
    }
    
    func updateButtonAppearance() {
        if currentAdoptionStatus == .all {
            adoptionavalableButton.backgroundColor = UIColor.white
            adoptionavalableButton.setTitleColor(UIColor.black, for: .normal)
            adoptionavalableButton.setTitle("입양 가능 상태", for: .normal)
        } else {
            adoptionavalableButton.backgroundColor = UIColor.orange
            adoptionavalableButton.setTitleColor(UIColor.white, for: .normal)
            
            if currentAdoptionStatus == .available {
                adoptionavalableButton.setTitle("입양 가능", for: .normal)
            } else if currentAdoptionStatus == .unavailable {
                adoptionavalableButton.setTitle("입양 불가능", for: .normal)
            }
        }
    }
    func updateRegionButtonTitle() {
        if let currentRegion = currentRegion {
            regionButton.backgroundColor = UIColor.orange
            regionButton.setTitleColor(UIColor.white, for: .normal)
            regionButton.setTitle(currentRegion.localizedTitle, for: .normal)
        } else {
            regionButton.backgroundColor = UIColor.white
            regionButton.setTitleColor(UIColor.black, for: .normal)
            regionButton.setTitle("지역", for: .normal)
        }
    }
    
    func updateSpeciesButton(){
        if currentSpecies == .all {
            speciesButton.backgroundColor = UIColor.white
            speciesButton.setTitleColor(UIColor.black, for: .normal)
            speciesButton.setTitle("종류", for: .normal)
        } else {
            speciesButton.backgroundColor = UIColor.orange
            speciesButton.setTitleColor(UIColor.white, for: .normal)
            
            if currentSpecies == .dog {
                speciesButton.setTitle("강아지", for: .normal)
            } else if currentSpecies == .cat {
                speciesButton.setTitle("고양이", for: .normal)
            }
        }
    }
    
    func updateGenderButton(){
        if currentGender == .all {
            genderButton.backgroundColor = UIColor.white
            genderButton.setTitleColor(UIColor.black, for: .normal)
            genderButton.setTitle("성별", for: .normal)
        } else {
            genderButton.backgroundColor = UIColor.orange
            genderButton.setTitleColor(UIColor.white, for: .normal)
            
            if currentGender == .female {
                genderButton.setTitle("여아", for: .normal)
            } else if currentGender == .male {
                genderButton.setTitle("남아", for: .normal)
            }
        }
    }
}

class adoptionCell: UICollectionViewCell {
    @IBOutlet weak var imageView: RoundedImageView!
    @IBOutlet weak var adoptionNameLabel: UILabel!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var centerLabel: UILabel!
    @IBOutlet weak var introductionLabel: UILabel!
    @IBOutlet weak var availableButton: UIButton!
    

    
}
