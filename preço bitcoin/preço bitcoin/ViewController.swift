//
//  ViewController.swift
//  preço bitcoin
//
//  Created by César  Ferreira on 20/01/20.
//  Copyright © 2020 César  Ferreira. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var labelPrecoBitcoin: UILabel!
    @IBOutlet weak var button: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.getPriceBitcoin()
    }

    @IBAction func refresh(_ sender: Any) {
        self.getPriceBitcoin()
    }
    
    private func priceFormatter(price: NSNumber) -> String {
        let nf = NumberFormatter()
        nf.numberStyle = .decimal
        nf.locale = Locale(identifier: "pt_BR")
        
        if let priceFinal = nf.string(from: price) {
            return priceFinal
        }
        
        return "0,00"
    }
    
    private func getPriceBitcoin() {
        print("AQUI")
        
        self.button.setTitle("Atualizando...", for: .normal)
        if let url = URL(string: "https://blockchain.info/pt/ticker") {
            let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
                    
                if (error == nil) {
                    if let dataRequest = data {
                        do {
                            if let objectJson = try JSONSerialization.jsonObject(with: dataRequest, options: []) as? [String: Any] {
                                if let brl = objectJson["BRL"] as? [String: Any] {
                                    if let price = brl["buy"] as? Double {
                                        let priceFormatter = self.priceFormatter(price: NSNumber(value: price))
                                        
                                        print(priceFormatter)
                                        
                                        DispatchQueue.main.async(execute: {
                                            self.labelPrecoBitcoin.text = "R$ " + priceFormatter

                                        })
                                    }
                                }
                            }
                        } catch  {
                            print("Erro ao formatar o retorno.")
                        }
                    }
                }
                print("ERROR " + error.debugDescription)

            }
            task.resume()
        }
    }
    
    
    
}

