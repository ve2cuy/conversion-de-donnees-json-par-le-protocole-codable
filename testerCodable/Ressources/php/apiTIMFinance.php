<?php
    /*
     Projet:   Protocole Codable
     Fichier:  api.yahoofinance.php
     Auteur:   Alain Boudreault
     Date:     2017.10.04
     Description:
     //  ============================================================================================
     //  À l'usage exclusif des étudiants et étudiantes de
     //  Techniques d'Intégration Multimédia
     //  du cégep de Saint-Jérôme.
     //  --------------------------------------------------------------------------------------------
     //  Il est interdit de reproduire, en tout ou en partie, à des fins commerciales,
     //  le code source, les scènes, les éléments graphiques, les classes et
     //  tout autre contenu du présent projet sans l’autorisation écrite de l'auteur.
     //
     //  Pour obtenir l’autorisation de reproduire ou d’utiliser, en tout ou en partie,
     //  le présent projet, veuillez communiquer avec:
     //
     //  Alain Boudreault, aboudrea@cstj.qc.ca, ve2cuy.wordpress.com
     //
     //  ============================================================================================
     //  Description:
     //
     //         L'API yahoo.finance n'étant plus disponible depuis 2017.11.01,
     //         ce programme simule l'API yahoo.finance.
     //
     //         Limitation: Les actions disponibles sont pré-déterminées.
     //
     //                     Le prix de départ est pré-déterminé mais pourra varier
     //                     de +- 10% à chaque exécution du script
     //
     //
     
     ------------------------------------------------------------------------------
     M-A-J:
     
     ------------------------------------------------------------------------------
     */
    
    // Les Constantes de l'app
    $porteFeuille = [
    ["Symbol" => "MSFT", "Ask" => 23.50, "Name" => "Microsoft"],
    ["Symbol" => "APPL", "Ask" => 93.34, "Name" => "Apple inc."],
    ["Symbol" => "FB", "Ask" => 88.90, "Name" => "Facebook"],
    ["Symbol" => "HP", "Ask" => 34.45, "Name" => "HP inc"],
    ["Symbol" => "AMD", "Ask" => 45.34, "Name" => "AMD corporation"],
    ["Symbol" => "COKE", "Ask" => 66.66, "Name" => "Coca cola"],
    ["Symbol" => "GDDY", "Ask" => 23.45, "Name" => "Godaddy"],
    ["Symbol" => "AMEX", "Ask" => 67.12, "Name" => "American express"],
    ["Symbol" => "TIM", "Ask" => 123.10, "Name" => "TIM Corp"],
    ["Symbol" => "CSTJ", "Ask" => 33.33, "Name" => "CSTJ to go"],
    ["Symbol" => "NICE", "Ask" => 123.00, "Name" => "The Nice co."],
    ["Symbol" => "ABC", "Ask" => 1.23, "Name" => "ABC inc."],
    ["Symbol" => "PI", "Ask" => 3.14, "Name" => "The PI co."],
    ["Symbol" => "DNTL", "Ask" => 45.11, "Name" => "Dont tell inc."],
    ["Symbol" => "PMSS", "Ask" => 25.44, "Name" => "Prod sur support inc."],
    ["Symbol" => "MCDO", "Ask" => 12.35, "Name" => "McDonald's"]
    ];
    
    // print_r($porteFeuille);
    
    $donneesBidons =  [
    "AverageDailyVolume"      => "10498500",
    "Bid"                     => "40.86",
    "AskRealtime"             => null,
    "BidRealtime"             => null,
    "BookValue"               => "36.39",
    "Change_PercentChange"    => "-0.23 - -0.55%",
    "Change"                  => "-0.23",
    "Commission"              => null,
    "Currency"                => "USD",
    ];
    
    // Début des traitements
    
    // Retour des données en format json
    $format =  isset($_GET["format"]) ? $_GET["format"] : "json";
    if ($format == "json") {
        // Dictionnaire du résultat final
        $resultat = array();
        // Tableau des actions
        $infoActions = array();
        
        $indicePortefeuille = 0;
        foreach ($porteFeuille as $action) {
            $actionCourante = array();
            // Obtenir les champs du portefeuille : ASK, Name et Symbol
            
            foreach($action as $x => $x_value) {
                
                if ($x == "Ask") {
                    $valeur = $x_value;
                    // Faire varier le prix
                    if ( mt_rand(0, 5) == 0) {
                        // 20% des fois, changer le prix
                        $direction = 1;
                        if ( mt_rand(0, 3) == 0) {
                            // 33% des fois, simuler une diminution du prix
                            $direction = -1;
                        }
                        $x_value = $valeur *  ( 1 + (mt_rand(0, 10) / 100) * $direction);
                        $porteFeuille[$indicePortefeuille]["Ask"] = $x_value;
                    }
                }
                
                $actionCourante[$x] = $x_value;
                $indicePortefeuille++;
            }
            // Ajouter les données bidons
            foreach($donneesBidons as $champ => $valeur) {
                $actionCourante[$champ] = $valeur;
            }
            
            $infoActions[] = $actionCourante;
        } // foreach ($porteFeuille as $action)
        
        
        $resultat['query'] = array("api.yahoofinance"    => "version 2017.10.04",
                                   "Auteur_API"      => "Alain Boudreault, AKA Puyansude, AKA ve2cuy",
                                   "type_requete"    => "json",
                                   "droit_auteur"    => "Cette API est à l'usage exclusif des étudiantes et étudiants de 'Production Multimédia sur Support' de tim.cstj.qc.ca'",
                                   "site_web"        => 'http://prof-tim.cstj.qc.ca/cours/xcode/wp/index.php/contenu/',
                                   "adresse_IP"      => $_SERVER['REMOTE_ADDR'],
                                   "created"         => date(DATE_RFC2822),
                                   "count"           => $nbResultats,
                                   "lang"            => "fr-ca",
                                   "results"         => array("quote" => $infoActions)
                                   );
        // Envoyer les données, en format json, vers le client
        echo json_encode($resultat, JSON_PRETTY_PRINT);
    } // if format == json
    
    ?>

