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
       
%Translate Predicate
translate_td([], []).
translate_td([Triplet|TripletList], [AminoAcid|AminoAcidList]) :-
    mapping(Triplet, AminoAcid),
    translate_td(TripletList, AminoAcidList).

%Create Triplet Predicate
translate(Genome, StringOutput) :- 
    string_chars(Genome, List),
    slice_list(List, TempList),
    part(TempList, 3, Window),
    concat_outer(Output, Window),
    translate_td(Output, TranslatedOutput),
    inner_concate(StringOutput, TranslatedOutput).

%convert lists of lists to list of strings
concat_outer([], []).
concat_outer([Triplet|TripletList], [Window|WindowList]) :-
    inner_concate(Triplet, Window),
    concat_outer(TripletList, WindowList).

%concatenate list into string
inner_concate(X,List):-
    atom_chars(X,List).  

%split list into triplet nested list
part([], _, []).
part(L, N, [DL|DLTail]) :-
   length(DL, N),
   append(DL, LTail, L),
   part(LTail, N, DLTail).

slice(AsBsCs,P,Q,Bs) :-
   append(AsBs,_Cs,AsBsCs),
   append(As  , Bs,AsBs  ),
   length([_|As],P),
   length( AsBs ,Q).

%trim genome string 
slice_list(List, OutputList) :-
    length(List, N),
    Q is div(N,3),
    L is Q*3,
    F =1,
    slice(List, F, L, OutputList).

codesFor(Genome, Len) :-
    translate(Genome, AminoSeq),
    sub_string(AminoSeq, _,Len,_,'KRSFIEDLLFNKV').