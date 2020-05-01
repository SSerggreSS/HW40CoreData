//
//  ViewController.swift
//  HW40CoreData
//
//  Created by Сергей on 19.04.2020.
//  Copyright © 2020 Sergei. All rights reserved.
//
/*
Вот эта тема очень интересная, так что задания нужно выполнить обязательно :)

✅Ученик.

✅1. Создайте класс студента с пропертисами firstName, lastName, dateOfBirth, gender, grade
✅2. Также создайте статическую таблицу куда все эти данные выводятся и где их можно менять (с текст филдами, сенгментед контролами и тд)
✅3. Пропертисы вашего студента меняйте тем же образом что и в предыдущих уроках (через делегаты и акшины)

✅Студент.

✅4. Повесте обсервера на все пропертисы студента и выводите в консоль каждый раз, когда проперти меняется
✅5. Также сделайте метод "сброс", который сбрасывает все пропертисы, а в самом методе не используйте сеттеры, сделайте все через айвары, но сделайте так, чтобы обсервер узнал когда и что меняется. (типо как в уроке)

✅Мастер.

✅забудьте про UI

✅6. Создайте несколько студентов и положите их в массив, но обсервер оставьте только на одном из них
✅7. У студентов сделайте weak проперти "friend". Сделайте цепочку из нескольких студентов, чтобы один был друг второму, второй третьему, тот четвертому, а тот первому :)
✅8. Используя метод setValue: forKeyPath: начните с одного студента (не того, что с обсервером) и переходите на его друга, меняя ему проперти, потом из того же студента на друга его друга и тд (то есть путь для последнего студента получится очень длинный)
✅9. Убедитесь что на каком-то из друзей, когда меняется какой-то проперти, срабатывает ваш обсервер

Супермен

✅10. Добавьте побольше студентов
11. Используя операторы KVC создайте массив имен всех студентов
12. Определите саммый поздний и саммый ранний годы рождения
13. Определите сумму всех баллов студентов и средний бал всех студентов

вот такое вот задание!
*/
 
import UIKit

class InfoStudentViewController: UIViewController {
    
    //MARK: UI Properties
    var tableView: UITableView! = nil
    
    //MARK: - Properties
    
    let width = UIScreen.main.bounds.width / 3
    let heightCell: CGFloat = 70.0
    
    @objc dynamic var student = Student(name: "Boris", surname: "Programmirovsky",
                                        dateOfBirth: Date.randomDate(from: 1980, before: 2000),
                                        gender: "Male", trainingClass: "11B")
    
    @objc dynamic var groups = NSMutableArray()
    let keyGroups = "groups"
    @objc dynamic var students = Array<Student>()
    let keyStudents = "students"
    
    //MARK: UI Lazy Properties
    lazy var markLabels: [UILabel] = {
        
        var labels = [UILabel]()
        
        for _ in 0...4 {
            
            let label = UILabel(frame: .zero)
            label.font = Constants.font
            labels.append(label)
            
        }
        
        return labels
    }()
    
    lazy var labelsOfOutput: [UILabel] = {
        
        var labels = [UILabel]()
        
        for i in 0...4 {
            
            let label = UILabel(frame: .zero)
            label.tag = i
            label.font = Constants.font
            labels.append(label)
            
        }
        
        return labels
    }()
    
    lazy var textFields: [UITextField] = {

        var fields = [UITextField]()
        
        for i in 0...3 {
            
            let field = UITextField(frame: .zero)
            
            field.tag = i
            field.delegate = self
            field.font = Constants.font
            field.borderStyle = .line
            fields.append(field)
            
        }
        
        return fields
    }()
    
    lazy var segmentedControl: UISegmentedControl = {
       
        let segmControl = UISegmentedControl(frame: .zero)
        segmControl.addTarget(self, action: #selector(actionSelectGender(sender:)), for: .valueChanged)
        segmControl.insertSegment(withTitle: "Male", at: 0, animated: true)
        segmControl.insertSegment(withTitle: "Female", at: 1, animated: true)
        
        return segmControl
    }()
    
    lazy var textFieldForEnterTheOperators: UITextField = {
        
        let textField = UITextField(frame: CGRect(x: 10,y: 500,
                                                  width: 390, height: 40))
        textField.tag = 4
        textField.delegate = self
        textField.borderStyle = .roundedRect

        return textField
    }()
    
    lazy var outputResultOfOperationsLabel: UILabel = {
        
        let label = UILabel(frame: CGRect(x: 410, y: 500, width: 390, height: 40))
        label.backgroundColor = .yellow
        
        return label
    }()
    
    //MARK: - Computed Property
    
    var createGroup: Group {
        
        var students = [Student]()
        let group = Group()
        
        for _ in 0...5 {
            
            students.append(Student.createRandomStudent())
            
        }
        
        group.students = students as NSArray
        
        return group
    }
    
    //MARK: - Life Circle
    override func loadView() {
        super.loadView()
        
        setupView()
        
        groups.add(createGroup)
        groups.add(createGroup)

        addObserversOnAllPropertiesOfStudent()
        
    }
    
    //MARK: - Actions
    
   @objc private func actionSelectGender(sender: UISegmentedControl) {
        
    let stringOfGender = segmentedControl.selectedSegmentIndex == 0 ? Constants.gender.male :
                                                                      Constants.gender.female
    
    labelsOfOutput[3].text = stringOfGender
    student.gender = stringOfGender
    
    }
    
    //MARK: - Help Functions
    
    private func setupView() {
        
        tableView = UITableView(frame: .zero, style: .grouped)
        tableView.dataSource = self
        tableView.delegate = self
        view = tableView
      
        view.addSubview(textFieldForEnterTheOperators)
        view.addSubview(outputResultOfOperationsLabel)
        
    }
    //Functions of create Cells
    private func createCellWith(firstLabel: UILabel, secondLabel: UILabel, textField: UITextField?,
                                inRow row: Int) -> UITableViewCell {
                    
        let cell = UITableViewCell()
        
        let texts = textForEachElementOfCellIn(row: row)
        
        let labelName = firstLabel
        labelName.backgroundColor = .red
        labelName.text = texts.namedLabelText
        
        cell.addSubview(labelName)
    
        let labelForOutputName = secondLabel
        labelForOutputName.backgroundColor = .yellow
        labelForOutputName.text = texts.namedTextOfOutput
        
        cell.addSubview(labelForOutputName)
    
        if let textField = textField {
            
        let textFieldInputName = textField
        textFieldInputName.placeholder = texts.namedTextPleceholder
        
        cell.addSubview(textFieldInputName)
            
        } else {
            
            cell.addSubview(segmentedControl)
            
        }
        
        return cell
    }
    
    func outputDataAccording(pathOperator: String) -> (fullKeyPath: String, resultOperation: String) {
    
        var fullKeyPath = ""
        
        var resultOperation = "Result: "
        
        students = self.value(forKeyPath: "groups.@unionOfArrays.students") as! [Student]
        
        let keyPathOperator = KeyPathOperatorType(rawValue: pathOperator) ?? KeyPathOperatorType.avg
        
        switch keyPathOperator {
            
            case .avg :
        
                fullKeyPath = keyPathOperator.createFullPath(leftKeyPath: keyStudents,
                                                             rightKeyPath: Student.keysProperties.assessment)
                let average = (self.value(forKeyPath: fullKeyPath) as? Float) ?? 0
                resultOperation = resultOperation + String(average)
            
            case .count:

                fullKeyPath = keyPathOperator.createFullPath(leftKeyPath: keyStudents,
                                                             rightKeyPath: nil)
                let countStudents = (self.value(forKeyPath: fullKeyPath) as? Int) ?? 0
                resultOperation = resultOperation + String(countStudents)

            case .max:

                fullKeyPath = keyPathOperator.createFullPath(leftKeyPath: keyStudents,
                                                             rightKeyPath: Student.keysProperties.assessment)
                let maxAssessment = self.value(forKeyPath: fullKeyPath) as? Int ?? 0
                resultOperation = resultOperation + String(maxAssessment)

            case .min:

                fullKeyPath = keyPathOperator.createFullPath(leftKeyPath: keyStudents,
                                                             rightKeyPath: Student.keysProperties.assessment)
                let minAssessment = self.value(forKeyPath: fullKeyPath) as? Int ?? 0
                resultOperation = resultOperation + String(minAssessment)
            
            case .sum:

                fullKeyPath = keyPathOperator.createFullPath(leftKeyPath: keyStudents,
                                                             rightKeyPath: Student.keysProperties.assessment)
                let sumAssessment = self.value(forKeyPath: fullKeyPath) as? Int ?? 0
                resultOperation = resultOperation + String(sumAssessment)

            case .distinctUnionOfObjects:
            
                fullKeyPath = keyPathOperator.createFullPath(leftKeyPath: keyGroups,
                                                             rightKeyPath: keyStudents)
                students = self.value(forKeyPath: fullKeyPath) as! [Student]
                resultOperation = resultOperation + "\(students.count)"
            
            case .unionOfObjects:
            
                fullKeyPath = keyPathOperator.createFullPath(leftKeyPath: keyGroups,
                                                             rightKeyPath: keyStudents)
                students = self.value(forKeyPath: fullKeyPath) as! [Student]
                resultOperation = resultOperation + "\(students.count)"
            
            case .distinctUnionOfArrays:
            
                fullKeyPath = keyPathOperator.createFullPath(leftKeyPath: keyGroups,
                                                             rightKeyPath: keyStudents)
                students = self.value(forKeyPath: fullKeyPath) as! [Student]
                resultOperation = resultOperation + "\(students.count)"
            
            case .unionOfArrays:
            
                fullKeyPath = keyPathOperator.createFullPath(leftKeyPath: keyGroups,
                                                             rightKeyPath: keyStudents)
                students = self.value(forKeyPath: fullKeyPath) as! [Student]
                resultOperation = resultOperation + "\(students.count)"
            
            case .distinctUnionOfSets:
            
                fullKeyPath = keyPathOperator.createFullPath(leftKeyPath: keyGroups,
                                                             rightKeyPath: keyStudents)
                resultOperation = resultOperation + "without explanation"
            
            default:
                break
        }
        
        return (fullKeyPath, resultOperation)
    }
    
    //MARK: Deinit
    
    deinit {
        self.student.removeObserver(self, forKeyPath: "name")
        print("student deintialized")
    }
    
}

//MARK: Extensions

//MARK: Help Functions
extension InfoStudentViewController {
  
    private func showPopoverWith(pickerType: PickerType, sourseView: UIView) {
       
        let popoverViewController = PopoverViewController(pickerType: pickerType)
        popoverViewController.delegate = self
        popoverViewController.modalPresentationStyle = .popover
        popoverViewController.preferredContentSize = CGSize(width: 300, height: 300)
        
        let popover = popoverViewController.popoverPresentationController
        popover?.permittedArrowDirections = [.down, .up]
        popover?.sourceView = sourseView
        
        present(popoverViewController, animated: true, completion: nil)
        
    }
    
    private func textForEachElementOfCellIn(row: Int) ->
                                           (namedLabelText: String, namedTextOfOutput: String,
                                            namedTextPleceholder: String) {
            
            var result = (namedLabelText: "", namedTextOfOutput: "", namedTextPleceholder: "")
            
            switch row {
                case 0:
                    
                    result.namedLabelText = "Name:"
                    result.namedTextOfOutput = student.name
                    result.namedTextPleceholder = "Enter Name Please"
                
                case 1:
                
                    result.namedLabelText = "Surname:"
                    result.namedTextOfOutput = student.surname
                    result.namedTextPleceholder = "Enter Surname Please"
                
                case 2:
                
                    result.namedLabelText = "Date Of Birth:"
                    result.namedTextOfOutput = student.dateOfBirth.stringFromDate(withFormat: "dd/MM/yyyy")
                    result.namedTextPleceholder = "Tap For Input"
                
                case 3:
                    
                    result.namedLabelText = "Gender:"
                    result.namedTextOfOutput = student.gender
                
                case 4:
                    
                    result.namedLabelText = "Training Class:"
                    result.namedTextOfOutput = student.trainingClass
                    result.namedTextPleceholder = "Tap For Input"
                
                default:
                    break
            }
            
            return result
    }
    
}

//MARK: Key Value Observing

extension InfoStudentViewController {
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        
        print("""
              keyPath = \(keyPath ?? "")
              object = \(object ?? "")
              change = \(change ?? [NSKeyValueChangeKey.newKey: ""])
              context = \(context.debugDescription)
              """)
        
    }
    
    private func addObserversOnAllPropertiesOfStudent() {
    
        let options = NSKeyValueObservingOptions([.new, .old])
        
        student.addObserver(self, forKeyPath: "name",        options: options, context: nil)
        student.addObserver(self, forKeyPath: "surname",     options: options, context: nil)
        student.addObserver(self, forKeyPath: "dateOfBirth", options: options, context: nil)
        student.addObserver(self, forKeyPath: "gender",      options: options, context: nil)
        student.addObserver(self, forKeyPath: "grade",       options: options, context: nil)
        
    }
    
}

//MARK: - UITableViewDataSourse

extension InfoStudentViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let iPathRow = indexPath.row
        
        var cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        
        let cellBounds = cell.bounds
        let cellOrigin = cell.frame.origin
        
        let frameForFirstElementInCell =  CGRect(x: cellBounds.origin.x, y: cellBounds.origin.y,
                                                 width: width, height: heightCell)
        let frameForSecondElementInCell = CGRect(x: cellOrigin.x + width, y: cellOrigin.y,
                                                 width: width, height: heightCell)
        let frameForThirdElementInCell =  CGRect(x: cellOrigin.x + (width * 2), y: cellOrigin.y,
                                                 width:      width, height: heightCell)
     
        
        if iPathRow < markLabels.count {
            
            markLabels[iPathRow].frame = frameForFirstElementInCell
            labelsOfOutput[iPathRow].frame = frameForSecondElementInCell
            
        }
        
        if iPathRow < textFields.count {
            
            textFields[iPathRow].frame = frameForThirdElementInCell
            
        }
        
        
        switch iPathRow {
            
            case 0:
                
                cell = createCellWith(firstLabel: markLabels[iPathRow], secondLabel: labelsOfOutput[iPathRow],
                                      textField: textFields[iPathRow], inRow: iPathRow)
    
            case 1:
                
                
                cell = createCellWith(firstLabel: markLabels[iPathRow], secondLabel: labelsOfOutput[iPathRow],
                                      textField: textFields[iPathRow], inRow: iPathRow)
                
            case 2:
                
                cell = createCellWith(firstLabel: markLabels[iPathRow], secondLabel: labelsOfOutput[iPathRow],
                                      textField: textFields[iPathRow], inRow: iPathRow)
            
            case 3:
            
                segmentedControl.frame = frameForThirdElementInCell
                cell = createCellWith(firstLabel: markLabels[iPathRow], secondLabel: labelsOfOutput[iPathRow],
                                      textField: nil, inRow: iPathRow)
        
            case 4:
            
                cell = createCellWith(firstLabel: markLabels[iPathRow], secondLabel: labelsOfOutput[iPathRow],
                                      textField: textFields[iPathRow - 1], inRow: iPathRow)
            
            default:
                break
        }
       return cell
    }
    
}

//MARK: - UITableViewDelegate

extension InfoStudentViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return heightCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}


//MARK: - UITextFieldDelegate

extension InfoStudentViewController: UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {

        var isShouldBeginEditing = true

        switch textField.tag {
            case 2:
                
            showPopoverWith(pickerType: .dateOfBirth, sourseView: textField)
            isShouldBeginEditing = false
            self.view.endEditing(true)
            
            case 3:
                
            showPopoverWith(pickerType: .viewTrainingClass, sourseView: textField)
            isShouldBeginEditing = false
            self.view.endEditing(true)
            
            case 4:
                
            showPopoverWith(pickerType: .viewOperators, sourseView: textField)
            isShouldBeginEditing = false
            self.view.endEditing(true)
            
            default:
                break
        }

        return isShouldBeginEditing
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        
        let text = ((textField.text ?? "") as NSMutableString)
        
        let newString = text.replacingCharacters(in: range, with: string)
        
        guard newString.count < 20 else { return false }
        
        switch textField.tag {
            
            case 0:
                
                labelsOfOutput[0].text = newString
                self.setValue(newString, forKeyPath: "student.name")
            
            case 1:
                
                labelsOfOutput[1].text = newString
                setValue(newString, forKeyPath: "student.surname")
            
            case 2:
                
                labelsOfOutput[2].text = newString
            
            default:
                break
        }
        
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        switch textField.tag {
            case 0:
                
                textFields[1].becomeFirstResponder()
            
            case 1:
                
                textFields[2].becomeFirstResponder()
                textFields[1].resignFirstResponder()
            
            default:
                break
        }
        
        return true
    }
    
    
}

//MARK: - PopoverViewControllerDelegate


extension InfoStudentViewController: PopoverViewControllerDelegate {
    
    func pickerViewTraningClass(didChangeTitle onText: String) {
        
        textFields[3].text = onText
        labelsOfOutput[4].text = onText
        student.trainingClass = onText
        
    }
    
    func pickerViewOperators(didChangeTitle onText: String) {
        
        let results = outputDataAccording(pathOperator: onText)
        
        textFieldForEnterTheOperators.text = results.fullKeyPath
        outputResultOfOperationsLabel.text = results.resultOperation
        
    }
    
    func datePicker(didChangeDate onDate: Date) {
        
        let stringOfDate = onDate.stringFromDate(withFormat: "dd/MM/yyyy")
        textFields[2].text = stringOfDate
        labelsOfOutput[2].text = stringOfDate
        student.dateOfBirth = onDate
        
    }
    
}

