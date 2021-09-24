SRCFILE = firmware
 
compile: $(SRCFILE).asm
	gavrasm $(SRCFILE)
 
clean:
	rm -f $(SRCFILE).asm~ $(SRCFILE).hex $(SRCFILE).obj $(SRCFILE).lst $(SRCFILE).cof