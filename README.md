# SmartContract-Voting

## Le jugement majoritaire

### Le vote

Les électeurs attribuent à chaque candidat, une mention parmi une liste de 7 mentions :

- Excellent
- Très bien
- Bien
- Assez Bien
- Passable
- Insuffisant
- A rejeter

### Le dépouillement

Pour chaque candidat, on calcule le pourcentage de chaque mention. On récupère ensuite la mention majoritaire, c'est la mention qui est approuvée par au moins 50 %.

Le gagnant de l'élection est celui qui possède la mention majoritaire la plus haute.
En cas d'égalité on départage avec la différence de pourcentage.