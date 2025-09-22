CA65 = ca65
LD65 = ld65
Fname = ctrldemo

.phony: default clean

default: $(Fname).nes

# ld65 -t nes -o barebone.nes barebone.o
$(Fname).o: $(Fname).s
	$(CA65)	-g libs/NMIHandler.s -o NMIHandler.o
	$(CA65)	-g libs/ReadController.s -o ReadController.o
	$(CA65)	-g $(Fname).s -o $(Fname).o


# ca65 barebone.s -o barebone.o
$(Fname).nes: $(Fname).o
	$(LD65) --dbgfile $(Fname).dbg --mapfile $(Fname).map -t nes -o $(Fname).nes $(Fname).o NMIHandler.o ReadController.o
# 	$(LD65) -v -C rom_config.cfg -o $(Fname).nes $(Fname).o

sym: $(Fname).dbg
	./dbg2nl.sh $(Fname).dbg > $(Fname).nes.0.nl


clean:
	rm -f *.nes *.o *.nl *.dbg *.deb *.map