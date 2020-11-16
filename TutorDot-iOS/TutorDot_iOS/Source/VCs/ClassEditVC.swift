//
//  ClassEditVC.swift
//  TutorDot_iOS
//
//  Created by Sehwa Ryu on 07/07/2020.
//  Copyright © 2020 Sehwa Ryu. All rights reserved.
//
import UIKit

class ClassEditVC: UIViewController, UIGestureRecognizerDelegate {
    static let identifier:String = "ClassEditVC"

    @IBOutlet weak var headerViewHeightConstraints: NSLayoutConstraint!
    @IBOutlet weak var classLabel: UILabel!
    @IBOutlet weak var classHeaderLabel: UILabel!
    @IBOutlet weak var startTextField: UITextField!
    @IBOutlet weak var endTextField: UITextField!
    
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var classImage: UIImageView!
    var classId : Int!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        headerViewHeightConstraints.constant = view.frame.height * (94/812)
        
    }
    func setUpView() {
        startTextField.textColor = UIColor.black
        endTextField.textColor = UIColor.black
        locationTextField.textColor = UIColor.black
    }

    @IBAction func editButton(_ sender: Any) {
        // 편집 확인하는 actionsheet 열기
        let alert: UIAlertController
        
        alert = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertController.Style.actionSheet)
        
        var cancelAction: UIAlertAction
        var delete: UIAlertAction
        var editAll: UIAlertAction
        
        cancelAction = UIAlertAction(title: "취소", style: UIAlertAction.Style.cancel, handler: { (action: UIAlertAction) in
        })
        
        delete = UIAlertAction(title: "삭제하기", style: UIAlertAction.Style.destructive, handler: { (action: UIAlertAction) in
            self.deleteOneClass()
            self.dismiss(animated: true, completion: nil)
            CalendarVC.calendarShared.viewWillAppear(true)
            
            //CalendarVC.calendarShared.viewDidLoad()
            //CalendarVC.calendarShared.dateCollectionView.reloadData()
            //CalendarVC.calendarShared.self.dateCollectionView.reloadData()
            //CalendarVC.calendarShared.tutorCollectionView.reloadData()
        })
        
        editAll = UIAlertAction(title: "편집하기", style: UIAlertAction.Style.default, handler: { (action: UIAlertAction) in
            self.editAllClick()
            
        })
        
        alert.addAction(cancelAction)
        alert.addAction(editAll)
        alert.addAction(delete)
        self.present(alert,animated: true){
            
        }

        
    
}
    
    func editAllClick() {
        guard let receiveViewController = self.storyboard?.instantiateViewController(identifier: ClassInfoVC.identifier) as? ClassInfoVC else {return}
        
        receiveViewController.modalPresentationStyle = .fullScreen
        self.present(receiveViewController, animated: false, completion: nil)
        
        if let className = self.classLabel.text {
            receiveViewController.classLabel.text = className
            
            // ClassInfoVC에 해당 내용들 넘겨주기
            // 상세 페이지 과외 시작, 끝, 장소 레이블 업데이트
            if let startHour = self.startTextField.text {
                receiveViewController.startTextField.text = startHour
                receiveViewController.classStartDate = startHour
            }
            
            if let endHour = self.endTextField.text {
                receiveViewController.endTextField.text = endHour
                receiveViewController.classEndDate = endHour
            }
            
            if let location = self.locationTextField.text {
                receiveViewController.locationTextField.text = location
            }
            
            if let image = self.classImage.image {
                receiveViewController.imageLabel.image = image
            }
            
            if let classId = self.classId {
                receiveViewController.classId = classId
                print(classId, "classss")
            }
            
        }
    }

    
    
    @IBAction func backButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    

    func deleteOneClass() {
        let classId = self.classId
        ClassInfoService.classInfoServiceShared.deleteOneClassInfo(classId: classId ?? 0) { networkResult in
            switch networkResult {
            case .success(let resultData):
                guard let data = resultData as? [CalendarData] else { return print(Error.self) }
                print("delete success", classId)
                
            case .pathErr : print("Patherr")
            case .serverErr : print("ServerErr")
            case .requestErr(let message) : print(message)
            case .networkFail:
                print("networkFail")
            }
        }
    }

}
