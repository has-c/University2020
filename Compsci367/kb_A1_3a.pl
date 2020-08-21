purine(adenine).
purine(guanine).
pyrimidine(thymine).
pyrimidine(cytosine).
   
bond_rule(adenine, thymine).
bond_rule(thymine, adenine). 

base(B) :- (purine(B);pyrimidine(B)).
    
bondswith(B1,B2) :- (\+(bond_rule(B1,B2)),
   	((purine(B1),
        B2=cytosine);
    (pyrimidine(B1),
        B2=guanine)));
    bond_rule(B1, B2).