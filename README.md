# shipTerm
A tool for me to use while DM space TTRPGs. A terminal for controling and tracking star ship values.
## Design Brief
shipTerm is the name of a hypothetical terminal program that will be used in conjunction with my Homebrewed dnd world. The Initial idea is a terminal that a player can actually interact with their starship on their own laptop. 

The program will keep track of resources including but not limited to the ships HP, the ship's mods and included technology, the ships fuel reserves, the ships shields, the ships Available armaments, the ships speed, the ships current star system, the nearby star systems that the ship can jump to. I would like to track all of the information that you need to run a starfinder game, so I will need to research the starfinder ship mechanics, and figure out how to implement that. To smooth the changing of ship types I would like some kind of json file upload of new ship info into the system, and save files. 

In addition to this, my program will contain some representation of the galaxy, with information about the stars including, number of planets, distance from the center, distance from the ship, the ruling faction, if there is one, the type of star, and the nearest stars that are connected to each system. I would like to have brief information about the planets in each system, and perhaps a few interesting landmarks as well. This would all be procedurally generated, so I can have the galaxy generate itself, and then go add the capitol systems, and other information. One way I can look into is to code a graph of nodes, with each node containing the info for each star. The galaxy will use polar coordinates to make mapping easier.

With this information the pilot will be able to chart a course through the galaxy, and use whatever FTL drive is fitted to the ship to change the ships current location. I would like for each star drive to contain different rules for how far they can jump. This would allow the program to change it's behavior's depending on which ship is loaded. 

Next, the program can have a random encounter generator disguised as a Scan Feature. When the Pc's enter a new solar system they can choose to scan the system, then the random encounter can roll on a table to see what happens. In my mind there is more logic depending on the civilization level, and proximity to capitol systems. 
