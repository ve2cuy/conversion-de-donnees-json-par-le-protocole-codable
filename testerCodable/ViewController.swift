//  ViewController.swift
//  testerCodable
//
//  Created by Alain on 17-10-25.
//  Copyright © 2017 Alain. All rights reserved.
//  ================================================================
//  Description:
//
//   Contenu:
//
//          Le protocole 'Codable'
//          Les extensions de classes
//          NSData(contentsOf: URL(string: uneURL)!))
//          JSONDecoder().decode()
//          L'opérateur ??
//          Timer.scheduledTimer
//          DispatchQueue.main.async
//
//  ================================================================
//  Note:  Il faut ajouter la clé suivante au fichier info.plist
//
//    <key>NSAppTransportSecurity</key>
//    <dict>
//    <key>NSAllowsArbitraryLoads</key>
//    <true/>
//    </dict>
//
//  ================================================================
//  M-A-J 2017.11.04 - https://chart.yahoo.com/table.csv?s=gsbd
//                     https://www.alphavantage.co/support/#api-key
//
//  ================================================================

// Importer les librairies requises par la classe courante
import UIKit

// Définition de la classe
// ===========================================================
class ViewController: UIViewController, UITableViewDataSource {
    
    // Les connexions @IB
    @IBOutlet weak var tableViewDesActions: UITableView!
    
    @IBOutlet weak var uiNbLecturesSurApiYahoo: UILabel!
    
    // Cette propriété va contenir les données reçues de Yahoo
    var donnéesFinanceYahoo:YahooFinance?
    
    var nbLecturesSurApiYahoo = 0
    
    // Surcharge de certaines méthodes utiles de la super classe
    // =======================================================
    override func viewDidLoad() {
        super.viewDidLoad()
        obtenirDonnéesDeMesActions()
        Timer.scheduledTimer(timeInterval: 5,
                             target: self,
                             selector: #selector(self.obtenirDonnéesDeMesActions),
                             userInfo: nil,
                             repeats: true)
    } // viewDidLoad()
    
    // =======================================================
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    } // didReceiveMemoryWarning()
    
} // class ViewController
// ===========================================================


extension ViewController {
    
    //MARK:- Obtenir les données
    // =======================================================
    @objc func obtenirDonnéesDeMesActions(){
        // Exemple d'utilisation de l'API finance Yahoo:
        // http://query.yahooapis.com/v1/public/yql?q=select * from yahoo.finance.quotes where symbol in ('MSFT','YHOO','FB','INTC','HPQ','AAPL','AMD','COKE')&env=store://datatables.org/alltableswithkeys&format=json
        
        // Il faudra convertir certains caractères en séquence d'échappement WEB
        // pour rendre l'URL compatible avec la classe URL.
        // http://query.yahooapis.com/v1/public/yql?q=select%20*%20from%20yahoo.finance.quotes%20where%20symbol%20in%20('MSFT','YHOO','FB','INTC','HPQ','AAPL','AMD','COKE')&env=store://datatables.org/alltableswithkeys&format=json
        
        // Construire l'URL vers l'API finance de Yahoo et remplacer les caractères invalides.
        // Liste des caractères à convertir
        let caracteresAConvertirEnFormatWeb = CharacterSet(charactersIn: " ").inverted
        // Former le début de l'URL
        // NOTE: L'API Yahoo finance n'est plus disponible depuis 2017.11.01
        // let uneURL = "http://query.yahooapis.com/v1/public/yql?q="
        // Ajouter la requête SQL et remplacer les ' ' par %20
        // + "select * from yahoo.finance.quotes where symbol in ('MSFT','YHOO','FB','INTC','HPQ','AAPL','AMD','COKE', 'MOMO', 'EGOV', 'PTOP', 'SINA', 'TWTR', 'YNDX', 'NTES', 'GDDY')".addingPercentEncoding(withAllowedCharacters: caracteresAConvertirEnFormatWeb)!
        // Ajouter la fin de l'URL
        // + "&env=store://datatables.org/alltableswithkeys&format=json"
        
        // Voici un script php qui simule l'API YahooFinance
        let uneURL = "http://prof-tim.cstj.qc.ca/cours/xcode/sources/apiyahoo/api-yahoofinance.php?format=json"
        
        //MARK:- Exécuter la commande seulement en mode DEBUG
        #if DEBUG
            print(uneURL)
        #endif
        
        // Détacher l'opération d'interrogation de l'API finance
        DispatchQueue.main.async ( execute: {
            // Obtenir les données via le Web
            if let _data = NSData(contentsOf: URL(string: uneURL)!) as Data? {
                // Note: YahooFinance.self veut dire "de type YahooFinance"
                do {
                    self.donnéesFinanceYahoo = try JSONDecoder().decode(YahooFinance.self, from: _data)
                    
                    //M-A-J du nombre de lectures vers l'API de Yahoo
                    self.nbLecturesSurApiYahoo += 1
                    self.uiNbLecturesSurApiYahoo?.text = String(self.nbLecturesSurApiYahoo)
                    print("\n\n\(NSDate()) - Lecture numéro \(self.nbLecturesSurApiYahoo)")
                    #if DEBUG
                        self.afficherDonnéesFinanceYahoo()
                    #endif
                    //Réactualiser les données de tableViewDesActions
                    self.tableViewDesActions.reloadData()
                }
                catch {
                    print("Erreur de conversion JSON")
                }
            } // if let
        }) // DispatchQueue()
    } // obtenirDonnéesJSON
    
    // =======================================================
    func afficherDonnéesFinanceYahoo(){
        print("\n============================================")
        print("Voici les données du portefeuille d'actions:")
        print("Début ------------------------------------->")
        
        if let _données = donnéesFinanceYahoo {
            for contenu in _données.query.results.quote  {
                let prix = contenu.Ask ?? 0.0
                let symbole = contenu.Symbol ?? "n/a"
                print ("\t\(symbole): \(prix)")
            }
        }
        print("Fin <---------------------------------------\n")
        
    } // afficherDonnéesFinanceYahoo
    
    //MARK:- Les méthodes du protocole UITableViewDataSource
    // =======================================================
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        // si données = nil alors retourner 0
        guard donnéesFinanceYahoo != nil else { return 0 }
        
        return (donnéesFinanceYahoo?.query.results.quote.count)!
        
    } // numberOfRowsInSection
    
    
    // =======================================================
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellule = tableView.dequeueReusableCell(withIdentifier: "modele", for: indexPath) as! CelluleAction
        
        let indice = indexPath.row
        
        // Obtenir l'action courante à partir du tableau des actions
        // en s'assurant que le tableau n'est pas 'nil' - précaution pour le dispatch
        if let actionCourante = donnéesFinanceYahoo?.query.results.quote[indice] {
            
            // Renseigner la couleur de fond des cellules.
            let couleurDeFond =  indice % 2 == 0 ? UIColor(named: "vertFonce") : UIColor(named: "bleuFonce")
            cellule.backgroundColor = couleurDeFond
            
            // Renseigner les champs requis
            let nom      = actionCourante.Name   ?? "n/a"
            let symbole  = actionCourante.Symbol ?? "n/a"
            let prix     = actionCourante.Ask    ?? 0
            cellule.actionCode.text = "\(symbole)"
            cellule.actionTitre.text = "\(nom)"
            // cellule.actionValeur.textColor = UIColor.white
            cellule.imageDirection?.image = nil
            let prixPrécédent = Float(cellule.actionValeur!.text!)!
            
            // Ne pas afficher les flèches de direction à la première lecture des données
            if nbLecturesSurApiYahoo != 1 {
                if  prixPrécédent < prix {
                    // cellule.actionValeur.textColor = UIColor.green
                    cellule.imageDirection?.image = UIImage(named: "arrow_green")
                }
                if  prixPrécédent > prix {
                    // cellule.actionValeur.textColor = UIColor.red
                    cellule.imageDirection?.image = UIImage(named: "arrow_red")
                }
            }
            cellule.actionValeur.text = "\(String(format: "%.2f", prix))"
        } // if let
        
        return cellule
        
    } // cellForRowAt indexPath
    
}  // extension ViewController

