# MBW-Complex-Formation
Code used in 'Quantitative analysis of MBW complex formation in the context of trichome patterning'


=== MATLAB Code ===

calc_complex_full.m
Description: Solves Eq. 32 in the paper and plots the results.

crn_full.m
Description: The set of ODEs that represent the chemical reaction network (CRN). These are solved in calc_complex.full.m and depends on s_prod.csv and s_sub.csv which contain the stochiometric matrices.

=== Python Code ===

complex.py
Description: The code used to create the standalone application (packaged by pyinstaller).

=== CSV Files ===

s_prod.csv
Description: Stochiometric matrix for the products of the CRN.

s_sub.csv
Descritpion: Stochiometric matrix for the substrates of the CRN.

Protein complex combinations.csv
Description: Raw data that is visualized by complex.py.
