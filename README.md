# BibliographeR : a set of tools to help your bibliographic research

Date: 2019-02-29

## Abstract

The number of scientific articles is constantly increasing. It is sometimes impossible to read all the articles in certain areas. Among this great diversity of articles, some may be more interesting than others. It is difficult to select which articles are essential in a field. The contemporary way to judge the scientific quality of an article is to use the impact factor or the number of citations. However, these parameters may lead to a lack of certain articles that are not very well cited but are very innovative. It is therefore essential to ask the question of what makes an article fundamental in a field. Using the "fulltext" package in our Shiny web application we show how the analysis of a bibliography using a network is a good way to visualize the state of the art in a field.  We  searched for different parameters to judge scientific quality using data science approaches. Recent research has shown that the work of small research teams can lead to scientific innovations. In this sense, the analysis of scientific articles by global techniques could play an important role in the discovery of these advances.

- [Resultats](https://github.com/propan2one/BibliographeR/blob/master/results/NOTEBOOK-resultats.md)

- [src](https://github.com/propan2one/BibliographeR/blob/master/src/)

- [raw](https://github.com/propan2one/BibliographeR/blob/master/raw/)

- [doc](https://github.com/propan2one/BibliographeR/blob/master/doc/)

## Mise en place du projet

Idéalement, il va falloir s'attaquer à une bibliographie déjà étudiée, dans mon cas j'ai celle d'une partie de mon sujet de thèse (que je connais vaguement), avec les 2 mots clés "herpesvirus" + "oyster" :

- 136 articles (seulement !) qui traitent du sujet

- Ces articles sont de 1972 à nos jours

- Présents chez plusieurs publisher avec différents cas de figure (Nature, journaux peu connu etc)

### 1) Utiliser [fulltext](https://github.com/ropensci/fulltext) pour récolter les 1eres données sur NCBI avec [entrez](https://github.com/ropensci/rentrez) des différents articles

- les DOI (le lien https)

- Les auteurs (en avec leurs universitées car certains auteurs ont des noms confondant pouvant fausser l'occurence (comme par exemple avec "Li et al")) et l'université pourrait être un facteur à prendre en compte pour traiter des petites teams (genre à interpréter avec le classement de Shangai)

- Les mots clés

- Les résumés

- Autres (les futurs chose qui nous viendrons surment à l'esprit !)

### 2) A partir des DOI, webscrapper (il va peut être falloir passer par des `if` pour gérer les différents cas de balises)

- Les figures sur les sites, en les nommant par leurs numéros (donc la balise pour les noms de plots ?)!

- La liste des **références** (articles associé et auteurs cités) pour faire le réseau

- Comment on traite les datas d'articles inaccessibles (aka on peut pas ce rendre sur le DOI, vieux articles)
(si pas de doi on traite pas, je vois pas ce qu'on peut faire dans ce cas c'est la loose, faut voir avec une biblio format bibtex par exemple, si les noms des auteurs ont été rentrés genre à la main on peut toujours inclure l'article dans un réseau avec des auteurs sinon on met de côté)

### 3) Traitements des données scrappées générer

- Courbes d'évolution (par années / mois) des articles en fonctions des thèmes
    - Pour 1 mot clé donné
    - Pour les mots clés associés (d'ou le réseau ?)
    - Par rapport à l'évolution dans le temps, existe t-il des mois plus propices à la publication d'articles que d'autre du coup ? (A noel publié c'est plus simple :p)

Optionnel ; 
- Quelles sont les mots clés avec le plus grand nombre d'articles, je parie que cancérologie est en bonne position !! (voir, faire un top10)

- Peut ont créer une bibliothèque de mots clés communs par thème (biologie/math etc..)

    - Parler à des scientifiques de différents domaines pour essayer d'avoir le type de d'analyse pour une expérience donnée

### 4) Travailler sur des techniques d'image recognition pour classifer les plots

- Déterminer la base de données d'images, c'est à dire sur quels plots on va utiliser (tradeoff plot utile vs image dispo), on peut se baser sur les [classiques](https://www.datanovia.com/en/blog/ggplot-examples-best-reference/) et en rajouter par la suite.

- La base de données d'images à générer en scrappant Google images et en récupérerant genre 1000 images des différentes catégorie de plots.

**Remarque** : à garder en tête pour l'analyse global des datas :

### 5) Critère d'évaluations d'un article

- Impact factor
    "À ce jour, le Journal Citation Reports (JCR), développée par Clarivate Analytics (anciennement Thomson Reuters), est la seule ressource permettant de trouver le facteur d'impact de plus de 8 000 revues scientifiques. Les revues scientifiques répertoriées dans JCR sont celles indexées par Web of Science." 
    Sauf que c'est pas en free access ! 
- SNIP - "Source normalized impact per paper" 
- SCIMAGO journal and country rank (https://www.scimagojr.com/index.php)  Alors ça ça à l'air trop cool !!! Par contre leur appli (https://www.scimagojr.com/shapeofscience/) rame à mort (ou alors c'est mon PC, à vérifier)
    - on a accès très facilement à la notation de 31
- Eigenfactor 

Lien intéressant avec qqs indices, en francais : 
(https://guides.biblio.polymtl.ca/mise_en_valeur_de_la_recherche/impact_revues)

Lien qu'à l'air encore mieux avec plein d'indices et en anglais cette fois : 

Measuring Your Impact: Impact Factor, Citation Analysis, and other Metrics: Journal Impact Factor (IF)
Overview of h-index, Eigenfactor, Impact Factor (IF), Journal Citation Reports, Citation Analysis, and other tools.
(https://researchguides.uic.edu/if/impact)

- Citation analysis:

Citation analysis can be used to determine the citation impact of authors, articles, and journals. 

- h-index/ g-index

Beyond basic citation counts, there are measures such as the h-index and the g-index which are used to quantify the impact of an individual author.

- Use/download data:

This method relies on usage data such as the number of downloads for an article to help determine impact.  

- Journal impact factor:

To rank journals within a discipline or a sub-discipline, or to determine the average citation count for a journal use Journal Citation Reports ( from Thomson Reuters) or SCImago (from Elsevier).

- Scientometrics 2.0/ Altmetrics:

There is a growing movement examining the measurement of scholarly impact drawn from Web 2.0 data.   (Priem and Hemminger, 2010).
Subject Guide
Sandy DeGroote's picture
Sandy DeGroote
Email Me
Contact:
Professor & Scholarly Communications Librarian
312-413-9494
Subjects:
Copyright & Scholarly Publishing


- Les retweets !! (je pense pas que pour un scientific paper ce soit vraiment pertinent)

- On peut essayer de catégoriser comment les plots ont été générés (graphprisme / STAT/ matplotlib / R, [les utilisateur de R on évidemment un score plus haut xD]

- Type de journal : Journaux open source, journaux bizarre etc..

- On pourra voir quels sont les liens entre les plots : un line plot va t-il être suivi par un heatmap ? (on tente une chaine de markov ?)
    - On peut aussi catégoriser la suite de plot/analyse pour un type d'expérience donné (exemple pour une Transcriptomic analysis : line plot (abondance de transcrit) suivi de heatmap suivi de d'analyse GOterm)
    
- Quelques liens sur l'évaluation de la qualité d'un article scientifique : 
    - https://www.researchgate.net/post/What_are_the_standards_for_quality_scientific_research
    - https://www.researchgate.net/post/What_are_the_criteria_to_define_the_quality_of_a_publication_on_parasitology
    - https://www.guidelines.kaowarsom.be/annex_dimension_scientific_quality


### 6) data 

Tableau 1 : sortie CSV NCBI ou fichier BIB

Tableau 2 : Institutions avec des cohordonnées pour la map : https://zenodo.org/record/2465689

Tableau 3 : Les différentes indices par revues https://www.scimagojr.com/journalrank.php?out=xls

Tableau 4 : Bdd avec les https://zenodo.org/record/2754830

- sjr inice h pour chaque revue :


## Organisation 

- retroplanning avant deadline 

- Déploiment d'une appli shiny (allé voir shinyapp.io)
ça je gère ça va j'en ai déployé qqunes c'est easy

![retroplanning](retroplanning_BibliographR.jpg)

## Deadline

- Abstract selection - April 15, 2019

- Slides must be sent to slides@user2019.fr no later than June, 21.

- useR! 2019 Toulouse - France July 9-12, 2019

## Bibliographie

https://www.nature.com/articles/d41586-019-00350-3 
https://lingfeiwu.github.io/smallTeams/#next
