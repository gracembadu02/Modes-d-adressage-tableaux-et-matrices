/********************************************************************************
*																				*
*	Programme qui lit, affiche et vérifie un sudoku.                          	*
*																				*
*															                    *
*	Auteurs: 																	*
*																				*
********************************************************************************/




.include "/root/SOURCES/ift209/tools/ift209.as"



.global main


.section ".text"

/* Début du programme */

main:	adr		x20,Sudoku          //x20 contient l'adresse de base du sudoku

        mov		x0,x20              //Paramètre: adresse du sudoku
        bl      LireSudoku			//Appelle le sous-programme de lecture

		mov		x0,x20				//Paramètre: adresse du sudoku
		bl		AfficherSudoku		//Appelle le sous-programme d'affichage

		mov		x0,x20				//Paramètre: adresse du sudoku
		bl		VerifierSudoku		//Appelle le sous-programme de vérification

		mov		  x0,#0				//0: tous les tampons
		bl        fflush			//Vidange des tampons

		mov		  x0,#0				//0: aucune erreur
		bl        exit				//Fin du programme


//#########################################################  DEBUT LECTURE  ################################################################

LireSudoku:
        SAVE
		mov		x19,x0		     	//x19 = adresse du Sudoku
		mov		x20,#9				// x20 = MAXLIGNES
		mov		x21,#9				// x21 = MAXCOLONNES
		mov		x22,#0				// indice i
		mov		x23,#0				// indice j
		mov		x28,#1				// valeur d'incrementation
		bl		boucleLecture1		// branche a boucleLecture1
		RESTORE
        ret

// bouche de lecture 1
boucleLecture1:
		cmp		x22,x20				//if( i < 9)
		b.lt	boucleLecture2		// branche a boucleLecture2
		b		finBoucle			// sinon branche finBoucle


boucleLecture2:
		cmp		x23,x21				//if( j< 9)
		b.lt	LectureClavier		//branche a LectureClavier
		b		LigneSuivante		// sinon branche a LigneSuivante

LectureClavier:
	    // lecture de la variable puis stocker dans temp
	    adr     x0, scfmt1			// x0 = adresse(scfmt1)
	    adr     x1, temp			// x1 = adresse(temp)
	    bl      scanf				// lire(x0,x1)

	    // recuperation de la variable lue
	    ldr    	w24, temp           // w24 = mem[temp]
	    b       calcul_Index_Ecriture_Memoire				// branche calcul_Index_Ecriture_Memoire


calcul_Index_Ecriture_Memoire:
	    mul     x25, x22, x20		// x25 = i* MAXCOLONNES
	    add     x25, x25, x23       // index = (i* MAXCOLONNES) +j
	    add     x25, x25, x19		// adresse = Sudoku + ((i* MAXCOLONNES) +j)

	    // ecriture dans la memoire
	    strb    w24, [x25]			// stocke dans l'adresse x25 la valeur w24
	    b       ColonneSuivante		// branche a ColonneSuivante


LigneSuivante:
		add		x22,x22,x28		// i++
		mov		x23,#0			// remettre j = 0
		b		boucleLecture1	// retourne à boucle 1

ColonneSuivante:
		add		x23,x23,x28		// j++
		b		boucleLecture2	// retourne a boucle 2




//#########################################################  FIN LECTURE  ################################################################



//#########################################################  DEBUT AFFICHAGE  ################################################################
AfficherSudoku:
        SAVE
		mov		x19,x0		     	//x19 = adresse du Sudoku
		mov		x20,#9				// x20 = MAXLIGNES
		mov		x21,#9				// x21 = MAXCOLONNES
		mov		x22,#0				// indice i
		mov		x23,#0				// indice j
		mov		x26,#1
		bl		boucleAffichage1	//  branche a boucleAffichage1
		b		finBoucle


boucleAffichage1:
		cmp		x22,x20				//if( i < 9)
		b.lt	Verifie_Separateur_Vertical			//branche Verifie_Separateur_Vertical

		//afficher un separateur
		adr		x0,ptfmt1     		// x0 = adresse(scfm1)
		bl		printf				//afficher
		RESTORE
        ret

boucleAffichage2:
		cmp		x23,x21				//if ( j  < 9)
		b.lt	Verifie_Separateur_Horizontal		//branche Verifie_Separateur_Horizontal
		b		IncrementerLigne	//sinon branche IncrementerLigne


calcul_Index_Lecture_Memoire:
		mul		x24,x22,x20		   // x24 = i *MAXCOLONNES
		add		x24,x24,x23		   // index = x24 +j
		add		x24,x24,x19		   // x24 = Sudoku + x24

		//ecriture dans la memoire
		ldrb	w25,[x24]		   // w25 = adresse(x24)
		b		afficheElement


afficheElement:
		adr		x0,ptfmt4		  // x0 = adresse(ptfmt4)
		mov		w1,w25			  // w1 = w25
		bl		printf			  //afficher
		b		IncrementerColonne


IncrementerLigne:
		adr		x0,ptfmt5		  //x0 = adresse(ptfmt5)
		bl		printf
		add		x22,x22,x26		 // i++
		mov		x23,#0			 //remettre j =0
		b		boucleAffichage1


IncrementerColonne:
		add		x23,x23,x26		   //j++
		b		boucleAffichage2   //branche a boucleAffichage2


Verifie_Separateur_Horizontal:
		mov		x27,#3			   // x27 =3
		udiv	x28,x23,x27		   // x28 = j/3
		mul		x28,x28,x27		   // x28 = (j/3) *3

		cmp		x28,x23			   //if( x28 == j)
		b.eq	affiche_Separateur_Horizontal // branche affiche_Separateur_Horizontal
		b		calcul_Index_Lecture_Memoire  // sinon va calcul_Index_Lecture_Memoire

affiche_Separateur_Horizontal:
		adr		x0,ptfmt3     		// x0 = adresse(scfm1)
		bl		printf				//afficher
		b		calcul_Index_Lecture_Memoire   //branchement

Verifie_Separateur_Vertical:
		mov		x27,#3				// X27 = 3
		udiv	x28,x22,x27			//x28 = i / 3
		mul		x28,x28,x27			// X28 = (j/3) *3

		cmp		x28,x22				//if( x28 == i )
		b.eq	affiche_Separateur_Vertical		// branche affiche_Separateur_Vertical
		b		boucleAffichage2	// sinon va boucleAffichage2


affiche_Separateur_Vertical:
		adr		x0,ptfmt1     		// x0 = adresse(scfm1)
		bl		printf				//afficher
		b		boucleAffichage2
//#########################################################  FIN AFFICHAGE  ################################################################





//#########################################################  DEBUT VERIFIER  ################################################################
VerifierSudoku:
        SAVE
		mov		x19,x0		     	//x19 = adresse du Sudoku
		mov		x20,#9				//MAXLIGNES = MAXCOLONNES =9
		mov		x21,#0				// indice i
		mov		x22,#0				// indice j
		mov		x23,#0				// indice k
		mov		x24,#1				// Incrementeur
		bl		VerifierLigne
		bl		VerifierColonne

		RESTORE
		ret

//#########################################################  FIN VERIFIER  ################################################################
//#########################################################  DEBUT VERIF LIGNE  ################################################################

VerifierLigne:
		SAVE
		b		VL_Boucle_Ligne		// branche a VL_Boucle_Ligne

VL_Boucle_Ligne:
		cmp		x21,x20				//if( i == 9)
		b.eq	finBoucle			//finBoucle
		b		VL_BoucleColonne	//sinon branche a 	VL_BoucleColonne


VL_BoucleColonne:
		cmp		x22,x20				// if(j == 9)
		b.eq	VL_Next_Ligne		//branche
		add		x23,x22,x24			// k = j +incrementeur
		b		VL_Boucle_Validation // branche a VL_Boucle_Validation

VL_Next_Ligne:
		add		x21,x21,x24			// i = i + incrementeur
		mov		x22,#0				//remettre j a 0
		b		VL_Boucle_Ligne		// branche a VL_Boucle_Ligne

VL_Boucle_Validation:
		cmp		x23,x20				//if ( k == 9 )
		b.eq	VL_Next_Colonne		// branche a VL_Next_Colonne
		b		VL_Validation		//sinon branche a VL_Validation

VL_Next_Colonne:
		add		x22,x22,x24			// j++
		b		VL_BoucleColonne	//branche VL_BoucleColonne


VL_Validation:
		mul		x25,x21,x20			// x25 = i* MAXCOLONNES
		add		x25,x25,x22			// x25 = x25 +j
		add		x25,x25,x19			// x25 = Sudoku +(x25 +j)

		mul		x26,x21,x20			// x26 = i * MAXCOLONNES
		add		x26,x26,x23			// x26 = x26 +k
		add		x26,x26,x19			// x26 = Sudoku + x26 +k

		ldrb	w27,[x25]			// w27 = mem[x25]
		ldrb	w28,[x26]			// w28 = mem[x26]

		cmp		w27,w28				// if(w27 == w28)
		b.eq	VL_Error			// branche a VL_Error
		b		VL_Increm_K			//sinon branche a VL_Increm_K


VL_Error:
		add		x28,x21,x24			// x28 = i + incrementeur
		adr		x0,ptfmt6			// x0 = adresse(ptfmt6)
		mov		x1,x28				// x1 = x28
		bl		printf				//afficher
		b		VL_Next_Ligne		// branche VL_Next_Ligne


VL_Increm_K:
		add		x23,x23,x24			// k++
		b		VL_Boucle_Validation // va VL_Boucle_Validation

//#########################################################  FIN VERIF LIGNE  ################################################################

//#########################################################  DEBUT VERIF COLONNE  ################################################################
VerifierColonne:
		SAVE
		b		VC_Boucle_Ligne

VC_Boucle_Ligne:
		cmp		x21,x20			     //if( i == 9)
		b.eq	finBoucle			 // FinBoucle
		b		VC_BoucleColonne	 // sinon va VC_BoucleColonne


VC_BoucleColonne:
		cmp		x22,x20				// if(j == 9)
		b.eq	VC_Next_Ligne		// branche a VC_Next_Ligne
		add		x23,x22,x24			// k = j + incrementeur
		b		VC_Boucle_Validation //branche VC_Boucle_Validation

VC_Next_Ligne:
		add		x21,x21,x24			// i++
		mov		x22,#0				// remettre j=0
		b		VC_Boucle_Ligne		// branche a VC_Boucle_Ligne

VC_Boucle_Validation:
		cmp		x23,x20				// if( k == 9)
		b.eq	VC_Next_Colonne		// branche a VC_Next_Colonne
		b		VC_Validation		//sinon va VC_Validation

VC_Next_Colonne:
		add		x22,x22,x24			//j++
		b		VC_BoucleColonne    //branche a VC_BoucleColonne


VC_Validation:
		mul		x25,x22,x20			// x25 = j * MAXCOLONNES
		add		x25,x25,x21			// x25 = x25 + i
		add		x25,x25,x19			// x25 = Sudoku + x25

		mul		x26,x23,x20			// x26 = k * 9
		add		x26,x26,x21			// x26 = x26 + i
		add		x26,x26,x19			// x26 = Sudoku + x26

		ldrb	w27,[x25]			// w27 = mem[x25]
		ldrb	w28,[x26]			// W28 = mem[x26]

		cmp		w27,w28				// if(w27 == w28)
		b.eq	VC_Error            // branche a VC_Error
		b		VC_Increm_K   		//sinon branche VC_Increm_K


VC_Error:
		add		x28,x21,x24			// x28 = i + incrementeur
		adr		x0,ptfmt7			// x0 = adresse(ptfmt7)
		mov		x1,x28			    // x21 = x28
		bl		printf				// afficher
		b		VC_Next_Ligne		// branche a VC_Next_Ligne


VC_Increm_K:
		add		x23,x23,x24			//k++
		b		VC_Boucle_Validation // branche a VC_Boucle_Validation
//#########################################################  FIN VERIF COLONNE  ################################################################



finBoucle:
		RESTORE
		ret

.section ".rodata"


scfmt1:     .asciz  "%d"
ptfmt1:     .asciz	"|---|---|---|\n"
ptfmt2:		.asciz	"0 "
ptfmt3:     .asciz	"|"
ptfmt4:		.asciz  "%d"
ptfmt5:		.asciz	"|\n"
ptfmt6:		.asciz	"Le sudoku contient une erreur dans la ligne %d\n"
ptfmt7:		.asciz	"Le sudoku contient une erreur dans la colonne %d\n"
ptfmt8:		.asciz	"\n\nla valeur est %d\n\n"


.section ".bss"
Sudoku: .skip 81
		.align 4
temp:	.skip 4
