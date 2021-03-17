obj-m+=mcp251x.o

all:
	make -C /lib/modules/$(shell uname -r)/build M=$(shell pwd) modules

clean:
	make -C /lib/modules/$(shell uname -r)/build M=$(shell pwd) clean

modules_install: all
	make -C /lib/modules/$(shell uname -r)/build M=$(shell pwd) modules_install
	$(DEPMOD)

test: all
	ifconfig can0 down || true
	sleep 1
	rmmod mcp251x || true
	sleep 1
	insmod mcp251x.ko
	sleep 1
	ip link set can0 type can bitrate 125000 restart-ms 50
	ifconfig can0 up
	sleep 1
	cansend can0 1F334455#1122334455667788
	ifconfig can0
	dmesg -c

install:
	cp mcp251x.ko /lib/modules/5.10.17+/kernel/drivers/net/can/spi/mcp251x.ko
