//
//  ViewController.swift
//  ExchangeRates
//
//  Created by Aim on 19/01/21.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var textFieldSourceCurrency: UITextField!
    @IBOutlet weak var textFieldAmount: UITextField!
    @IBOutlet weak var tableviewList: UITableView!
    var exchageRateData:ExchangeRates?
    var arrayAllKeys:[String]?
    let pickerView = UIPickerView()
    var selectedSourceCurrency = 1.0
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupTextFieldSourceCurrency()
        self.setupTextFieldAmount()
        loadDataFromServer()
        _ = Timer.scheduledTimer(timeInterval: 30 * 60, target: self, selector: #selector(loadDataFromServer), userInfo: nil, repeats: true)
        // Do any additional setup after loading the view.
    }
    
    @objc func loadDataFromServer()  {
        if self.exchageRateData == nil{
            Webservices().getExchangeRates() { (exchangeRates,error)  in
                if let exchangeRates = exchangeRates
                {
                    self.exchageRateData = exchangeRates
                    self.arrayAllKeys = Array(self.exchageRateData!.quotes.keys)
                    self.arrayAllKeys = self.arrayAllKeys?.sorted {
                        $0 < $1
                    }
                    self.tableviewList.reloadData()
                    self.pickerView.reloadAllComponents()
                }
            }
        }

    }
    
    func setupTextFieldSourceCurrency() {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
                doneToolbar.barStyle = .default
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.doneButtonAction))
        let items = [flexSpace, done]
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        self.textFieldSourceCurrency.inputAccessoryView = doneToolbar
        self.pickerView.delegate = self
        self.textFieldSourceCurrency.inputView = self.pickerView
    }
    func setupTextFieldAmount() {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
                doneToolbar.barStyle = .default
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.amountDoneButtonAction))
        let items = [flexSpace, done]
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        self.textFieldAmount.inputAccessoryView = doneToolbar
    }
    @objc func amountDoneButtonAction(){
        self.textFieldAmount.resignFirstResponder()
        self.tableviewList.reloadData()
    }
    @objc func doneButtonAction(){
        self.textFieldSourceCurrency.resignFirstResponder()
        let selectedValue = self.arrayAllKeys?[self.pickerView.selectedRow(inComponent: 0)].replaceFirst(of: "USD", with: "")
        self.textFieldSourceCurrency.text = selectedValue
        self.selectedSourceCurrency = self.exchageRateData?.quotes[self.arrayAllKeys![self.pickerView.selectedRow(inComponent: 0)]] ?? 1.0
        self.tableviewList.reloadData()
    }
}


extension ViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.arrayAllKeys?.count ?? 0
    }

    func pickerView( _ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.arrayAllKeys![row].replaceFirst(of: "USD", with: "")
    }

    
}
extension ViewController:UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
       return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrayAllKeys?.count ?? 0
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50.0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "RateTableViewCell", for: indexPath) as? RateTableViewCell else {
            fatalError("ArticleTableViewCell not found")
        }
//        let currrencyRate = self.exchageRateData?.quotes[indexPath.row]
        cell.labelCurrencyName.text = self.arrayAllKeys![indexPath.row].replaceFirst(of: "USD", with: "")
        let rate = (self.exchageRateData?.quotes[self.arrayAllKeys![indexPath.row]]!)!
        let calculatedRate = (Double(self.textFieldAmount.text!) ?? 1.0) * ((rate) / selectedSourceCurrency)  as! Double
        cell.labelAmount.text = String(format: "%.4f", calculatedRate)
       
        return cell
    }
//    func singleTapDetected(in cell: UserTableViewCell)  {
//        if let indexPath = self.tblView.indexPath(for: cell) as? UserTableViewCell { print("singleTap \(indexPath) ") }
//    }
//    func doubleTapDetected(in cell: UserTableViewCell) {
//        if let indexPath = self.tblView.indexPath(for: cell) as? UserTableViewCell { print("doubleTap \(indexPath) ") }
//    }
}

