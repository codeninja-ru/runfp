clean:
	-rm *.res
	-rm *.o
	-rm runfp

build: clean
	fpc -OG -O2 runfp.pas


test: build
	./runfp test.pas
