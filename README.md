# Scripts FTP

Scripts publics que j'ai fait sur le serveur Feed the Patrick.

## Disclaimer
Je ne fais *aucun* support sur ce qui se trouve dans ce repo. Si vous arrivez à déchiffrer mon code, tant mieux, sinon tant pis.

## Saison 1
### Dossier reacteur
C'est les scripts des 3 ordinateurs utilisés pour le réacteur d'aypierre. Le code n'est pas vraiment flexible, c'est donc assez dur de l'adapter pour votre usage si vous ne connaissez pas bien le Lua.

* **main.lua:** Script de l'ordinateur avec l'écran.
* **ccs.lua:** Script de l'ordinateur près du réacteur.
* **frames.lua:** Script de l'ordinateur en dessous, pour les frames.

## Saison 2
### horloge.lua
Un script très simple qui affiche l'heure du monde avec un écran connecté à l'avant de l'ordinateur. Utilise un capteur OpenCCSensors avec une carte Sonic à l'arrière de l'ordinateur.
### glasses.lua
Le script utilisé pour mes lunettes. Il n'est pas dans le dossier zombies car il va être utilisé pour d'autres choses.
### Dossier zombies
C'est les scripts des 3 ordinateurs + 2 turtles utilisées pour la ferme à XP automatisée.

* **jarxp.lua:** Script de l'ordinateur qui diffuse l'XP qu'a le brain in a jar
* **shard.lua:** Script de l'ordinateur qui contrôle la soul cage et son spawn
* **piston.lua:** Script de l'ordinateur qui contrôle le piston avant les turtles
* **turtle.lua:** Script des turtles tueuses
* **ecran.lua:** Script de l'écran extérieur qui affiche l'XP
