all: main

main:
	iverilog -o bin/main src/*.v

test:
	iverilog -o bin/test_func tests/test_func.v src/*.v
	bin/test_func

clean:
	rm -rf bin/* vcd/*