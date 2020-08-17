base(adenine).
base(thymine).
base(cytosine).
base(guanine).
purine(adenine).
purine(guanine).
pyrimidine(thymine).
pyrimidine(cytosine).

bonded(adenine, thymine).
bonded(cytosine, guanine). 

bondswith(B1,B2) :-
    base(B1), base(B2), 
    ((purine(B1), pyrimidine(B2));(purine(B2), pyrimidine(B1))), (bonded(B1,B2)).

aminoacid('F').
aminoacid('L').
aminoacid('I').
aminoacid('M').
aminoacid('V').
aminoacid('S').
aminoacid('P').
aminoacid('T').
aminoacid('A').
aminoacid('Y').
aminoacid('STOP').
aminoacid('H').
aminoacid('Q').
aminoacid('N').
aminoacid('K').
aminoacid('D').
aminoacid('E').
aminoacid('C').
aminoacid('W').
aminoacid('R').
aminoacid('G').


triplets('TTT').
triplets('TTC').
triplets('CTT').
triplets('CTC').
triplets('CTA').
triplets('CTG').
triplets('ATT').
triplets('ATC').
triplets('ATA').
triplets('ATG').
triplets('GTT').
triplets('GTC').
triplets('GTA').
triplets('GTG').
triplets('TCT').
triplets('TCC').
triplets('TCA').
triplets('TCG').
triplets('CCT').
triplets('CCC').
triplets('CCA').
triplets('CCG').
triplets('ACT').
triplets('ACC').
triplets('ACA').
triplets('ACG').
triplets('GCT').
triplets('GCC').
triplets('GCA').
triplets('GCG').
triplets('TAT').
triplets('TAC').
triplets('TAA').
triplets('TAG').
triplets('TGA').
triplets('CAT').
triplets('CAC').
triplets('CAA').
triplets('CAG').
triplets('AAT').
triplets('AAC').
triplets('AAA').
triplets('AAG').
triplets('GAT').
triplets('GAC').
triplets('GAA').
triplets('GAG').
triplets('TGT').
triplets('TGC').
triplets('TGG').
triplets('CGT').
triplets('CGC').
triplets('CGA').
triplets('CGG').
triplets('AGT').
triplets('AGC').
triplets('AGA').
triplets('AGG').
triplets('GGT').
triplets('GGC').
triplets('GGA').
triplets('GGG').

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
mapping('TAA','STOP').
mapping('TAG','STOP').
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
mapping('TGA','STOP').
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

%”KRSFIEDLLFNKV”
codesFor(Genome, SubSeq) :-
    extract_triplet(Genome, SubSeq).


%%Translate Predicate
translate_td([], []).
translate_td([Triplet|TripletList], [AminoAcid|AminoAcidList]) :-
  mapping(Triplet, AminoAcid),
  translate_td(TripletList, AminoAcidList).

%Create Triplet Predicate
extract_triplet(Genome, StringOutput) :- 
    string_chars(Genome, List),
    sliding_window(List, 3,Window),
    concat_outer(Output, Window),
    translate_td(Output, TranslatedOutput),
    inner_concate(StringOutput, TranslatedOutput).

%sliding window
sliding_window(L, Size, LSubL):-
  length(SubL, Size),
  append(SubL, _, SubLO),
  findall(SubL, append(_, SubLO, L), LSubL).

%convert lists of lists to list of strings
concat_outer([], []).
concat_outer([Triplet|TripletList], [Window|WindowList]) :-
    inner_concate(Triplet, Window),
    concat_outer(TripletList, WindowList).

%concatenate list into string
inner_concate(X,List):-
   atom_chars(X,List).  