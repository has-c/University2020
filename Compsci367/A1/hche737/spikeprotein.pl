
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
/* Question 3a 
Author: Hasnain Cheena, 190411106
I tried but didn't get it to work correctly
*/
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
purine(adenine).
purine(guanine).
pyrimidine(thymine).
pyrimidine(cytosine).
   
bond_rule(adenine, thymine).
bond_rule(thymine, adenine). 

base(B) :- (purine(B);pyrimidine(B)).
    
bondsWith(B1,B2) :- (\+(bond_rule(B1,B2)),
   	((purine(B1),
        B2=cytosine);
    (pyrimidine(B1),
        B2=guanine)));
    bond_rule(B1, B2).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
/* Question 3b 
Author: Hasnain Cheena, 190411106
Warning: Takes 10 seconds to run
*/
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Remember to set the correct working directory
%working_directory(_, 'C:/Users/hasna/OneDrive/Desktop/Git Repos/University2020/Compsci367/A1').

%DNA Mapping
mapping('TTT','F').
mapping('TTC','F').
mapping('TTA','L').
mapping('TTG','L').
mapping('CTT','L').
mapping('CTC','L').
mapping('CTA','L').
mapping('CTG','L').
mapping('ATT','I').
mapping('ATC','I').
mapping('ATA','I').
mapping('ATG','M').
mapping('GTT','V').
mapping('GTC','V').
mapping('GTA','V').
mapping('GTG','V').
mapping('TCT','S').
mapping('TCC','S').
mapping('TCA','S').
mapping('TCG','S').
mapping('CCT','P').
mapping('CCC','P').
mapping('CCA','P').
mapping('CCG','P').
mapping('ACT','T').
mapping('ACC','T').
mapping('ACA','T').
mapping('ACG','T').
mapping('GCT','A').
mapping('GCC','A').
mapping('GCA','A').
mapping('GCG','A').
mapping('TAT','Y').
mapping('TAC','Y').
mapping('TAA','*').
mapping('TAG','*').
mapping('CAT','H').
mapping('CAC','H').
mapping('CAA','Q').
mapping('CAG','Q').
mapping('AAT','N').
mapping('AAC','N').
mapping('AAA','K').
mapping('AAG','K').
mapping('GAT','D').
mapping('GAC','D').
mapping('GAA','E').
mapping('GAG','E').
mapping('TGT','C').
mapping('TGC','C').
mapping('TGA','*').
mapping('TGG','W').
mapping('CGT','R').
mapping('CGC','R').
mapping('CGA','R').
mapping('CGG','R').
mapping('AGT','S').
mapping('AGC','S').
mapping('AGA','R').
mapping('AGG','R').
mapping('GGT','G').
mapping('GGC','G').
mapping('GGA','G'). 
mapping('GGG','G').


%open and read file
read_file(Genome, List) :-
    upcase_atom(Genome, UpperCaseGenome),
    atom_concat(UpperCaseGenome, 'sequence.fasta', Filename),
    open(Filename, read, File),
    read_string(File, _, Body),
    string_chars(Body, FileList),   
    delete(FileList, '\n', List).

%slice list given index positions
sublist(List, From, To, SubList) :-
    findall(E, (between(From, To, I), nth1(I, List, E)), SubList).

%trim genome string 
slice_list(List, SubList) :-
    length(List, N),
    Q is div(N,3),
    To is Q*3,
    From =367,
    sublist(List, From, To, SubList).

%partition genome list into triplets
part([], []).
part([X,Y,Z|GenomeList], [AminoAcid|AminoAcidList]) :-
    atom_chars(Triplet, [X,Y,Z]),
    mapping(Triplet, AminoAcid),
    part(GenomeList, AminoAcidList).

%main
codesFor(Genome,Amino) :- 
    read_file(Genome,List),
    slice_list(List, StrippedList),
    part(StrippedList, AList),
    atomic_list_concat(AList,AminoSeq),atom(AminoSeq),
  	sub_string(AminoSeq, _,_,_,Amino).

 