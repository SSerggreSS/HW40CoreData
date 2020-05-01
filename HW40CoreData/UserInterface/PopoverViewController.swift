//
//  PopoverViewController.swift
//  HW40CoreData
//
//  Created by Сергей on 19.04.2020.
//  Copyright © 2020 Sergei. All rights reserved.
//

import Foundation
import UIKit

//MARK: Enum Picker Type

enum PickerType {
    
    case dateOfBirth
    case viewTrainingClass
    case viewOperators
    
}

//MARK: - PopoverViewControllerDelegate

protocol PopoverViewControllerDelegate {
    
    func pickerViewTraningClass(didChangeTitle onText: String)
    func pickerViewOperators(didChangeTitle onText: String)
    func datePicker(didChangeDate onDate: Date)
    
}

class PopoverViewController: UIViewController {
    
    //MARK: - Properties

    private var pickerView: UIPickerView?
    private var pickerDate: UIDatePicker?
    
    private var pickerType: PickerType
    
    var delegate: PopoverViewControllerDelegate?
    
    private var tempStr = ""
    
    //MARK: - Lazy Properties
    
    private let componentsForNamingTrainingClass: [Component] = {
       
        var components = [Component]()
        
        let component0 = Component(name: "Numb")
        component0.items = ["1", "2", "3", "4", "5", "6",
                           "7", "8", "9", "10", "11"]
        components.append(component0)
        
        let component1 = Component(name: "lett")
        component1.items = ["A", "B", "C", "D"]
        components.append(component1)
        
        return components
    }()
    
    private let componentForNamingOperator: Component = {
       
        var component = Component(name: "Operators")
        
        component.items = ["@avg", "@count", "@max", "@min", "@sum",
                           "@distinctUnionOfObjects", "@unionOfObjects",
                           "@distinctUnionOfArrays", "@unionOfArrays", "@distinctUnionOfSets"]
        
        return component
    }()
    
    //MARK: Init
    
    init(pickerType: PickerType) {
        
        self.pickerType = pickerType
        super.init(nibName: nil, bundle: nil)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Life Cycle
    
    override func loadView() {
        super.loadView()
        
        setupView()
        
    }
    
    //MARK: - Actions

    private func setupView() {
        
        switch pickerType {
            
            case .viewTrainingClass:
                
            setupPickerViewTrainingClass()
            
            case .viewOperators:
                
            setupPickerViewOperators()
            
            case .dateOfBirth:
                
            setupDateOfBirthPicker()
            
        }
        
    }
    
    private func setupPickerViewTrainingClass() {
        
        pickerView = UIPickerView(frame: .zero)
        pickerView?.dataSource = self
        pickerView?.delegate = self
        view = pickerView
        
    }
    
    private func setupDateOfBirthPicker() {
        
        pickerDate = UIDatePicker(frame: .zero)
        pickerDate?.datePickerMode = .date
        pickerDate?.minimumDate = Date(timeIntervalSince1970: 0)
        pickerDate?.maximumDate = Date(timeIntervalSinceReferenceDate: 0)
        pickerDate?.addTarget(self, action: #selector(actionDatePicker(sender:)),
                              for: .valueChanged)
        view = pickerDate
    }
    
    private func setupPickerViewOperators() {
        pickerView = UIPickerView(frame: .zero)
        pickerView?.dataSource = self
        pickerView?.delegate = self
        view = pickerView
    }
    
    @objc private func actionDatePicker(sender: UIDatePicker) {
        delegate?.datePicker(didChangeDate: sender.date)
    }
    
}

//MARK: - UIPickerViewDataSource

extension PopoverViewController: UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        
        var numberOfComponents = 0
        
        switch pickerType {
            
            case .viewTrainingClass:
                
                numberOfComponents = componentsForNamingTrainingClass.count
            
            case .viewOperators:
                
                numberOfComponents = 1
            
            default:
                break
        }
        
        return numberOfComponents
    }
    
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        var numberOfRowsInComponent = 0
        
        switch pickerType {
            
            case .viewTrainingClass:
                
                numberOfRowsInComponent = componentsForNamingTrainingClass[component].items.count
            
            case .viewOperators:
                
                numberOfRowsInComponent = componentForNamingOperator.items.count
            
            default:
                break
        }
        
        return numberOfRowsInComponent
    }
    
}

//MARK: - UIPickerViewDelegate

extension PopoverViewController: UIPickerViewDelegate {
    
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        var titleForRow = ""
        
        switch pickerType {
            
            case .viewTrainingClass:
                
                let component = componentsForNamingTrainingClass[component]
                let rows = component.items
                titleForRow = rows[row]
            
            case .viewOperators:
                
                titleForRow = componentForNamingOperator.items[row]
            
            default:
                break
        }
    
        return titleForRow
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        let title = componentsForNamingTrainingClass[component].items[row]
        
        if tempStr.count < 3 {
            
            tempStr += title
            
        } else {
            
            tempStr = title
            
        }
        
        switch pickerType {
            
            case .viewTrainingClass:
                
                delegate?.pickerViewTraningClass(didChangeTitle: tempStr)
            
            case .viewOperators:
                
                let title = componentForNamingOperator.items[row]
                delegate?.pickerViewOperators(didChangeTitle: title)
            
            default:
                break
        }

    }
    
    
}
