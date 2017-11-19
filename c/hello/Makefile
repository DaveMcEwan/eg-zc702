
SELF := $(shell basename $(PWD))

# Zynq on ZC702 is running linux so use arm-linux-gnueabi-
# For bare-metal target use arm-none-gnueabi-
CROSS := arm-linux-gnueabi-

# Setup variables used by make's implicit rules.
# https://www.gnu.org/software/make/manual/html_node/Catalogue-of-Rules.html
AR := $(CROSS)ar
AS := $(CROSS)as
CC := $(CROSS)gcc
CPP := $(CROSS)cpp
LD := $(CROSS)ld

# More warnings.
CFLAGS := -Wall -Wextra

# The minimal linux does not have shared libraries to dynamically link to so
# executable must be statically linked.
# Otherwise, when running ./foo you get an error like:
#	-sh: ./foo: No such file or directory
LDFLAGS := -static

# Link to libraries.
#LDLIBS := -lm

# First target is the default so name it as such.
default: $(SELF)

DEPS := another.o
$(SELF): $(DEPS)

.PHONY : clean
clean:
	-rm -f *.o
	-rm -f $(SELF)

# For this target to work you need to have ssh setup appropriately using
# ~/.ssh/config on the host.
# I.e. containing something like this:
#	Host zc702
#		Hostname 192.168.0.10
#		User root
#		StrictHostKeyChecking no
#		UserKnownHostsFile /dev/null
#		LogLevel QUIET
run:
	scp $(SELF) zc702:~/
	ssh zc702 -C "./$(SELF)"
