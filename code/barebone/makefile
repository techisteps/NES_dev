CA65 = ca65
LD65 = ld65
Fname = barebone

.phony: default clean

default: $(Fname).nes

# ld65 -t nes -o barebone.nes barebone.o
$(Fname).o: $(Fname).s
	$(CA65)	$(Fname).s -o $(Fname).o
	
# ca65 barebone.s -o barebone.o
$(Fname).nes: $(Fname).o
	$(LD65) -t nes -o $(Fname).nes $(Fname).o


clean:
	rm $(Fname).nes $(Fname).o