# 🏨 Rapport de Pilotage de la Performance d'une Chaîne Hôtelière avec Power BI
> **Projet UrbanStay** — Analyse, modélisation et visualisation des indicateurs clés de performance (KPIs)

---

## 1. Introduction

Dans le cadre de la mise en œuvre d’un dispositif de pilotage de la performance appliqué au secteur hôtelier, ce rapport présente une démarche d’analyse décisionnelle fondée sur l’exploitation de données opérationnelles à l’aide de **Power BI**. 

Le projet **UrbanStay** s’inscrit dans une logique de valorisation des données afin de produire des indicateurs fiables, interprétables et mobilisables pour l’aide à la décision. L’enjeu consiste à transformer des données brutes issues d’une base **PostgreSQL** en informations structurées permettant d’évaluer l’activité, d’identifier les tendances significatives et de formuler des recommandations à portée opérationnelle et managériale.

---

## 2. Objectifs du projet

L’objectif principal du projet **UrbanStay** est de construire un tableau de bord Power BI permettant de piloter la performance d’une chaîne hôtelière à partir de données issues d’une base PostgreSQL. Il s’agit de transformer des données opérationnelles brutes en indicateurs fiables, lisibles et exploitables afin de faciliter l’analyse de l’activité et l’aide à la décision.

* **Suivre les indicateurs clés de performance :** Notamment le chiffre d’affaires, le nombre de réservations, le panier moyen, le taux d’annulation et la durée moyenne de séjour.
* **Identifier les tendances d’activité :** Selon les périodes, les canaux de réservation, les segments clients et les types de chambres.
* **Repérer les écarts de performance :** Entre les hôtels, les catégories de chambres ou les modes de réservation afin de mettre en évidence les leviers d’amélioration.
* **Fiabiliser les données :** En corrigeant les incohérences, en traitant les valeurs manquantes et en structurant un modèle de données cohérent.
* **Proposer des recommandations opérationnelles :** Pour améliorer la rentabilité, réduire les annulations et mieux piloter l’activité commerciale.

---

## 3. Contexte du projet et source des données

Le projet repose sur la base de données **UrbanStay**, préalablement créée dans DBeaver puis connectée à Power BI. Cette base comprend quatre tables principales : `clients`, `reservations`, `chambres` et `hotels`. 

L’ensemble de ces données permet d’étudier plusieurs dimensions de la performance hôtelière, notamment l’activité commerciale, les comportements de réservation, la performance par typologie de chambre, l’efficacité des canaux de distribution et la contribution des différents segments de clientèle.

---

## 4. Préparation et fiabilisation des données

La préparation des données constitue une étape déterminante dans la construction d’un dispositif de pilotage fiable. Les traitements réalisés dans **Power Query** ont porté sur :
* La vérification des types de données (`INTEGER`, `VARCHAR`, `NUMERIC`, `SERIAL`, `DATE`).
* L’harmonisation des formats textuels et la correction des incohérences observées (noms de villes uniformisés en majuscules, canaux de réservation normalisés).
* La suppression des espaces parasites présents dans la colonne des segments clients (*Trim*).
* Le traitement des valeurs manquantes : remplacement par la modalité `"Non renseigné"` pour le pays des clients.

> ⚠️ **Choix méthodologique sur `montant_total` :**
> Le traitement de la colonne `montant_total` de la table `reservations` répond à un choix précis. Huit valeurs manquantes ayant été identifiées, **elles n’ont pas été imputées** afin d’éviter l’introduction d’un biais dans les analyses financières, en particulier dans le calcul du panier moyen. Ce choix contribue à préserver la validité des résultats tout en signalant explicitement une limite de qualité des données.

---

## 5. Modèle de données

Le modèle de données retenu correspond à un **modèle en flocon simplifié**. La table `reservations` constitue la table de faits, tandis que les tables `clients`, `chambres` et `hotels` constituent les dimensions d’analyse. 

La table `hotels` n’est pas reliée directement à la table `reservations` : la relation transite par la table `chambres`, ce qui permet de représenter de manière hiérarchique l’organisation des établissements et de leurs chambres.

### Règles de gestion et relations :
* Un hôtel possède plusieurs chambres ($1 \rightarrow N$).
* Une chambre appartient à un seul hôtel ($N \rightarrow 1$).
* Une chambre peut être associée à plusieurs réservations au cours du temps ($1 \rightarrow N$).
* Une réservation concerne une seule chambre ($N \rightarrow 1$).
* Un client peut effectuer plusieurs réservations ($1 \rightarrow N$).
* Une réservation appartient à un seul client ($N \rightarrow 1$).

### Synthèse des relations du modèle

| Table source | Table liée | Clé de relation | Cardinalité | Interprétation métier |
| :--- | :--- | :--- | :--- | :--- |
| **`hotels`** | `chambres` | `id_hotel` | `1 → N` | Un hôtel peut disposer de plusieurs chambres, tandis qu’une chambre appartient à un seul hôtel. |
| **`chambres`** | `reservations` | `id_chambre` | `1 → N` | Une chambre peut être réservée plusieurs fois au cours du temps, mais chaque réservation concerne une seule chambre. |
| **`clients`** | `reservations` | `id_client` | `1 → N` | Un client peut effectuer plusieurs réservations, tandis qu’une réservation est associée à un seul client. |

Ce schéma relationnel garantit une analyse cohérente des réservations en reliant chaque transaction à un client, à une chambre et, indirectement, à un hôtel.

---

## 6. Indicateurs clés et mesures DAX

Les mesures DAX élaborées ont pour objectif de traduire les données transactionnelles en indicateurs de performance synthétiques. Elles s'articulent autour de deux axes :
1. **La performance financière :** Chiffre d'affaires et Panier moyen.
2. **La performance opérationnelle :** Volume de réservations, Taux d'annulation et Durée moyenne de séjour.

### Synthèse des mesures DAX

| Mesure | Rôle dans l’analyse | Fonctions DAX utilisées | Formule DAX indicative |
| :--- | :--- | :--- | :--- |
| **Chiffre d’affaires** | Mesurer le montant total généré par les réservations. | `SUM` | `CA = SUM(reservations[montant_total])` |
| **Nombre de réservations** | Compter le volume total de réservations enregistrées. | `COUNTROWS` | `Nombre de réservations = COUNTROWS(reservations)` |
| **Réservations annulées** | Identifier le volume de réservations ayant le statut annulé. | `CALCULATE`, `COUNTROWS`, `FILTER` | `Réservations annulées = CALCULATE(COUNTROWS(reservations), reservations[statut] = "Annulée")` |
| **Taux d’annulation** | Évaluer la part des réservations annulées dans l’ensemble des réservations. | `DIVIDE` | `Taux d’annulation = DIVIDE([Réservations annulées], [Nombre de réservations])` |
| **Panier moyen** | Calculer le montant moyen d’une réservation (sans imputer les montants omis). | `AVERAGE` | `Panier moyen = AVERAGE(reservations[montant_total])` |
| **Durée de séjour** | Calculer le nombre de jours entre la date d’arrivée et la date de départ. | `DATEDIFF` | `Durée séjour = DATEDIFF(reservations[date_arrivee], reservations[date_depart], DAY)` |
| **Durée moyenne de séjour** | Mesurer la durée moyenne passée par les clients dans les établissements. | `AVERAGE` | `Durée moyenne séjour = AVERAGE(reservations[Durée séjour])` |

---

## 7. Conception du tableau de bord Power BI

Le tableau de bord Power BI a été structuré en **trois pages complémentaires** afin de proposer une lecture progressive de la performance :

1. **Page 1 — Vision Synthétique & KPIs Globaux :**
   - Vision d'ensemble des indicateurs clés (CA, nombre de réservations, durée moyenne de séjour).
   - Évolution mensuelle du chiffre d'affaires.
   - Filtres dynamiques interactifs.
2. **Page 2 — Analyse Temporelle :**
   - Analyse de la saisonnalité des réservations (évolution par année et par mois).
   - Identification des pics et des creux d'activité.
3. **Page 3 — Analyse Comparative & Segments :**
   - Analyse croisée par canal de réservation, segment client et type de chambre.

### Fonctionnalités d'interaction intégrées :
* **Boutons de navigation :** Facilitent le passage d'une vue à l'autre.
* **Infobulles dynamiques (*Tooltips*) :** Apportent du contexte supplémentaire au survol des visuels sans surcharger la page principale.
* **Titre dynamique :** Réagit aux filtres sélectionnés (ex: affichage du pays d'origine du client).
* **Signets et Sélection :** Organisation des visuels dans des conteneurs nettoyés.

---

## 8. Analyse des résultats

L’analyse des données met en évidence plusieurs tendances et enseignements structurants :

* **Saisonnalité & Anomalie de Janvier :**
  * Les mois de janvier, février et novembre enregistrent un chiffre d'affaires faible.
  * **Constat clé :** En janvier, le volume de réservations est proche de celui observé en mai, mais le chiffre d'affaires demeure sensiblement inférieur. Cela s'explique par une politique tarifaire promotionnelle agressive appliquée en début d'année pour maintenir un fond d'activité en période creuse.
* **Performance par Type de Chambre :**
  * La catégorie **Confort** représente **34,43 %** des réservations et présente le taux d'annulation le plus faible (**8,46 %**).
  * Les **Suites** représentent **17 %** des réservations, avec un taux d'annulation de **10 %**.
* **Efficacité des Canaux Digitaux :**
  * Les canaux **Booking** et **Site Web** concentrent plus de **68 %** du total des réservations.
  * Les réservations effectuées en ligne représentent **39,33 %** de l'ensemble et bénéficient d'un taux d'annulation bas (**8,73 %**).
* **Segmentation Clientèle :**
  * Le segment **Loisirs** est le principal moteur de croissance : il génère **60 % du Chiffre d'Affaires** et regroupe **62 % du volume de réservations**.

---

## 9. Points d’attention et recommandations

1. **Maîtriser le taux d’annulation :**
   * Le taux d’annulation global est élevé (proche de **10 %**, soit 192 annulations sur 2 000 réservations). Il convient d'instaurer des prépaiements ou des conditions plus strictes sur les périodes à forte demande.
2. **Optimiser la stratégie tarifaire en période creuse :**
   * Évaluer la rentabilité réelle des rabais accordés en janvier (*Yield Management*) afin de remonter le prix moyen sans sacrifier le volume de remplissage.
3. **Consolider et inciter aux réservations directes :**
   * Renforcer le canal *Site Web* (via des avantages fidélité) afin de basculer une partie du volume de *Booking* vers le canal direct et réduire ainsi les frais de commission d'intermédiation.
4. **Planification opérationnelle :**
   * Alignement des équipes (réception/étage) et programmation des travaux de maintenance exclusivement pendant les creux d'activité prévisibles (octobre/novembre).

---

## 10. Limites de l’analyse

* **Période couverte :** Les données analysées sont quasi-exclusivement concentrées sur l’année **2024**, ce qui empêche la réalisation d'analyses comparatives interannuelles fiables (*Year-over-Year*).
* **Données manquantes :** La présence de 8 valeurs manquantes non imputées sur `montant_total` doit être conservée à l'esprit lors du suivi des agrégats financiers.
* **Perspectives d'enrichissement :** Intégration future souhaitable du coût d’acquisition client (CAC) par canal, des avis clients et du taux d’occupation journalier.

---

## 11. Taux d’occupation hôtelier

Le taux d’occupation hôtelier mesure la part des chambres effectivement occupées par rapport à la capacité totale disponible sur une période donnée :

$$\text{Taux d'occupation} = \frac{\text{Nombre de chambres occupées}}{\text{Nombre total de chambres disponibles}}$$

Dans le cas du projet **UrbanStay**, chaque établissement dispose d'une capacité fixe de **20 chambres**. L'intégration de cet indicateur dans Power BI permettra à terme de croiser la performance tarifaire avec le taux de remplissage effectif des établissements afin de piloter la rentabilité globale via le **RevPAR** (*Revenue Per Available Room*).

---

## 12. Conclusion

La mise en place du tableau de bord Power BI pour le projet **UrbanStay** offre un cadre décisionnel complet alliant la rigueur ETL, la puissance d'un modèle relationnel en flocon et la souplesse d'une restitution visuelle dynamique. Ce rapport constitue une feuille de route analytique solide pour guider les décisions de la direction commerciale et améliorer durablement la rentabilité de la chaîne hôtelière.