AS = as
LD = ld


ARMV8:	tp3.o
	@echo
	@echo ------------------
	@echo Edition des liens
	@echo ------------------
	@echo

	$(LD) -e Main tp3.o -o tp3 -lc



tp3.o: tp3.as
	@echo
	@echo ---------------------------------------------
	@echo Compilation programme principal, tp3.as
	@echo ---------------------------------------------
	@echo

	$(AS) -gstabs tp3.as -o tp3.o
