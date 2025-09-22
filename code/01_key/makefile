CA65 = ca65
LD65 = ld65
Fname = key

.phony: default clean

default: $(Fname).nes

# ld65 -t nes -o barebone.nes barebone.o
$(Fname).o: $(Fname).s
	$(CA65)	-g $(Fname).s -o $(Fname).o
	
# ca65 barebone.s -o barebone.o
$(Fname).nes: $(Fname).o
	$(LD65) --dbgfile $(Fname).dbg --mapfile $(Fname).map -t nes -o $(Fname).nes $(Fname).o
# 	$(LD65) -v -C rom_config.cfg -o $(Fname).nes $(Fname).o


clean:
	rm $(Fname).nes $(Fname).o $(Fname).nes.deb