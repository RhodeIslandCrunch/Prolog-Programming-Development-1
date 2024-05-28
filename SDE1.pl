/*
Flower garden 1D V4
Rules: 
1) The garden consists of 1 row, each with N plantings (N is at least 4).  One flower species occupies each planting.  The Row is horizontal layed out with plantings from 0 at the to N at the right. You will use a Prolog list to represent the row.
3) Flowers have Name, Size, Wet/Dry, Color.
2) A given flower species can only be used once per row.
3) No two adjacent plantings can have the same color flower.
5) No two adjacent plantings can have flowers whose size is more than one size difference.  Sizes are small, med, tall so small next to small is fine, small next to medium is fine, but small next to tall is not.
6) the two outermost plantings (1 and N) are dry, the two innermost are wet, the ones in between (if there are any) can take either.
*/

flower(daisies, med, wet, yellow).
flower(roses, med, dry, red).
flower(petunias, med, wet, pink).
flower(daffodils, med, wet, yellow).
flower(begonias, tall, wet, white).
flower(snapdragons, tall, dry, red).
flower(marigolds, short, wet, yellow).
flower(gardenias, med, wet, red).
flower(gladiolas, tall, wet, red).
flower(bird_of_paradise, tall, wet, white).
flower(lilies, short, dry, white).
flower(azalea, med, dry, pink).
flower(buttercup, short, dry, yellow).
flower(poppy, med, dry, red).
flower(crocus, med, dry, orange).
flower(carnation, med, wet, white).
flower(tulip, short, wet, red).
flower(orchid, short, wet, white).
flower(chrysanthemum, tall, dry, pink).
flower(dahlia, med, wet, purple).
flower(geranium, short, dry, red).
flower(lavender, short, dry, purple).
flower(iris, tall, dry, purple).
flower(peonies, short, dry, pink).
flower(periwinkle, med, wet, purple).
flower(sunflower, tall, dry, yellow).
flower(violet, short, dry, purple).
flower(zinnia, short, wet, yellow).


/*
plantassign(N, List)
creates the lists for the plan while selecting a flower species for each spot in the garden
*/
plantassign(N, List) :-
    length(List, N),
    assign_flowers(List).

assign_flowers([]).
assign_flowers([H | Rest]) :-
    flower(Flower, _ , _ , _),
    H = Flower,
    assign_flowers(Rest).
/*
uniquecheck(List)
check to make sure the assignment hasn't violated rules about duplicate flowers
*/
uniquecheck([]).
uniquecheck([H | T]) :-
    \+ member(H, T),
    uniquecheck(T).
/*
colorcheck(List)
check to make sure color rules are kept
*/
colorcheck([]).
colorcheck([_]).
colorcheck([Flower1, Flower2 | Rest]) :-
    \+ same_color(Flower1, Flower2),
    colorcheck([Flower2 | Rest]).

/*
predicate to check if two flowers have the same color.
*/
same_color(Flower1, Flower2) :-
    flower(Flower1, _,_ , Color),
    flower(Flower2,_ , _, Color).
/* 
sizecheck(List)
check to be sure size rules are followed
*/
sizecheck([]).
sizecheck([_]).
sizecheck([Flower1, Flower2 | Rest]) :-
    size_difference(Flower1, Flower2),
    sizecheck([Flower2 | Rest]).

size_difference(Flower1, Flower2) :-
    flower(Flower1, Size1, _, _),
    flower(Flower2, Size2, _, _),
    size_difference_helper(Size1, Size2).

/*
size_difference_helper(small, tall).
size_difference_helper(tall, small).
*/

size_difference_helper(short, short).
size_difference_helper(short, med).
size_difference_helper(med, med).
size_difference_helper(med, short).
size_difference_helper(med, tall).
size_difference_helper(tall, tall).
size_difference_helper(tall, med).


/*
wetcheck(N, List)
make sure wet/dry rules are followed
*/
/*
First some helper predicates
*/
wet(Flower) :-
    flower(Flower, _, wet, _).
dry(Flower) :-
    flower(Flower, _, dry, _).

firstDry([H|_]) :-
    dry(H).
lastDry([H]) :-
    dry(H).
lastDry([_|T]) :-
    lastDry(T).


dryBed(List) :-
    firstDry(List),
    lastDry(List).
/*
 * These are not technically first and last wet
 * but instead
 * we split the list [__ | T] [H|__]
 * and use those 
*/
split(List, Left, Right, N) :-
    Half is N // 2,
    length(Left, Half),
    append(Left, Right, List).


lastWet([H]) :-
    wet(H).

lastWet([_|T]) :-
    lastWet(T).

firstWet([H|_]) :-
    wet(H).

wetBed(N,List) :-
    split(List, Left, Right, N),
    lastWet(Left),
    firstWet(Right)
    .

wetcheck(N,List) :-
    dryBed(List),
    wetBed(N,List).
/*
writegarden(List)
wwrite complete garden plan
*/
writegarden([]).
writegarden([H|T]) :-
    write(H),
    write('\t'),
    writegarden(T).
    
/*
gardenplan(N, List)
assign plants and check rules, then print the plan. 
*/
    
isValid(N,List) :-
    wetcheck(N, List),
    sizecheck(List),
    uniquecheck(List),
    colorcheck(List).

gardenplan(N,List) :-
    plantassign(N, List),
    isValid(N,List),
    writegarden(List),
    nl
    .
/*
The list in each argument is the same.  There is a list of N plantings.  The "plantassign" should fill in the flowers of a candidate plan, and then the various "check" predicates verify the rules.
*/

/*
These are extra credit extensions to the flower assignment.  Each item is worth 5 extera points.  At most two items can be applied for extra credit.
*/

/*
Extra Credit Item One.

gardencheck(N, M, List)
The list (plan) is already filled with flowers.  Use existing check routines to verify the plan is valid
*/
gardencheck(N, M, List) :-
	length(List, M),
    sanityPrint(N,M),
    isValid(N,List),
	writegarden(List),
    nl
    .

sanityPrint(N,M) :-
    write('Expected value of M should be : '),
    write(N),
    write(' Real value of M is : '),
    write(M),
    nl.
/*
Extra Credit Item two.

gardenplan(N, M, List)
If the List is unbound, create a plan as in the original spec.  If the List is bound and filled with flowers, run gardencheck(N, M, List)
*/
	gardenPlan(N,M,List) :-
    (   
    ground(List) ->  
    	gardencheck(N,M,List);
    	gardenplan(N,List)
	).
/*
Extra Credit Item Three.

What is the largest garden you can make with the flowers provided?  N and M should be close to the same value.
*/
/*
 * The largest possible would be 27 as that is the number of unique species of flower 
 * Let this be M 
 *  
*/


