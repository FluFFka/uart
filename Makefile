all: main

main:
	iverilog -o bin/main src/*.v

test:
	iverilog -o bin/test_main tests/test_main.v src/*.v
	bin/test_main

clean:
	rm -rf bin/* vcd/*