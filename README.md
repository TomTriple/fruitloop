FRUITLOOP
=========
Implementation of the LOOP programming language which compiles to JavaScript. See: http://de.wikipedia.org/wiki/LOOP-Programm.


DEPENDENCIES
============
- Ruby >= 1.9.2p290, not tested with other versions
- Node.js >= 0.5.6


HOWTO
=====
- Run "ruby main.rb add.loop" to compile and execute "add.loop". The same goes for the other examples. 
- The result of a computation will always be located in variable "xa". 


GRAMMAR
=======
S ::= P$
P ::= id A X
    | loop id do P end X 
A ::= : B
B ::= = C
C ::= id D
    | number
D ::= + number
    | - number
X ::= ; P X | Epsilon




