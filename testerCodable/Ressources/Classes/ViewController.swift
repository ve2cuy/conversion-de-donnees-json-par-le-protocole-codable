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
//  M-A-J
//
//  ================================================================

// Importer les librairies requises par la classe courante
import UIKit

// Définition de la classe
// ===========================================================
class ViewController: UIViewController {
    
    // Surcharge de certaines méthodes utiles de la super classe
    // =======================================================
    override func viewDidLoad() {
        super.viewDidLoad()
        obtenirLaCitationDuJour()
        //obtenirDonnéesDeMesActions()
    } // viewDidLoad()

    // =======================================================
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    } // didReceiveMemoryWarning()
    
} // class ViewController
// ===========================================================

// ===========================================================
// MARK:- Les extensions de la classe ViewController
// Note: Pas de propiétés de stockage dans les extensions.
//       Par exemple, ceci n'est pas possible;
//
//       let pi2 = 3.141592 * 2
//
//       Par contre, il est possible d'utiliser
//       des propriétés calculées;
//
//       var pi2: Double {return pi * 2}


extension ViewController {
    
    //MARK:- Obtenir les données
    
    // =======================================================
    func obtenirLaCitationDuJour(){
       let uneURL = "http://prof-tim.cstj.qc.ca/cours/xcode/sources/apitim.php?mode=rnd&quant=5&format=json"
        if let _data = NSData(contentsOf: URL(string: uneURL)!) as Data? {
            // Note: Class.self veut dire "de type Class"
            let données = try! JSONDecoder().decode(Citation.self, from: _data)
            print(données)
            
            for contenu in données.resultat {
                // Note: ?? est le 'nil-coalescing operator'
                let auteur = contenu.pensee_auteur ?? "Erreur: Nom de l'auteur non disponible"
                let pensée = contenu.pensee_texte  ?? "Erreur: Pensée de l'auteur non disponible"
                print ("\(auteur) a dit:\n\t \(pensée)\n\n")
            }
        } // if let
    } // obtenirLaCitationDuJour()
    
    // =======================================================
    func obtenirDonnéesDeMesActions(){
        // Exemple d'utilisation de l'API finance Yahoo:
        // http://query.yahooapis.com/v1/public/yql?q=select * from yahoo.finance.quotes where symbol in ('MSFT','YHOO','FB','INTC','HPQ','AAPL','AMD','COKE')&env=store://datatables.org/alltableswithkeys&format=json
        
        // Il faudra convertir certains caractères en séquence d'échappement WEB
        // pour rendre l'URL compatible avec la classe URL.
        // http://query.yahooapis.com/v1/public/yql?q=select%20*%20from%20yahoo.finance.quotes%20where%20symbol%20in%20('MSFT','YHOO','FB','INTC','HPQ','AAPL','AMD','COKE')&env=store://datatables.org/alltableswithkeys&format=json
        
        // Construire l'URL vers l'API finance de Yahoo et remplacer les caractères invalides.
        // Liste des car à convertir
        let caracteresAConvertirEnFormatWeb = CharacterSet(charactersIn: " ").inverted
        // Former le début de l'URL
        
        _ = "http://query.yahooapis.com/v1/public/yql?q="
            // Ajouter la requête SQL et remplacer les ' ' par %20
            + "select * from yahoo.finance.quotes where symbol in ('MSFT','YHOO','FB','INTC','HPQ','AAPL','AMD','COKE')".addingPercentEncoding(withAllowedCharacters: caracteresAConvertirEnFormatWeb)!
            // Ajouter la fin de l'URL
            + "&env=store://datatables.org/alltableswithkeys&format=json"
        
        // Voici un script php qui simule l'API YahooFinance
        let uneURL = "http://prof-tim.cstj.qc.ca/cours/xcode/sources/apiyahoo/api-yahoofinance.php?format=json"
        
        //MARK:- Exécuter la commande seulement en mode DEBUG
        #if DEBUG
         print(uneURL)
        #endif
        
        if let _data = NSData(contentsOf: URL(string: uneURL)!) as Data? {
            // Note: YahooFinance veut dire "de type YahooFinance"
            let données = try! JSONDecoder().decode(YahooFinance.self, from: _data)
            print(données)
            
            for contenu in données.query.results.quote {
                let prix = contenu.Ask ?? 0
                print ("\(contenu.Symbol): \(prix)")
            }
        } // if let
        
    } // obtenirDonnéesDeMesActions
    
}  // extension ViewController

