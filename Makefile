CLIENT := cformat
LENGTH_SIZE := 2 # default value of makePacketBasedInstance
TYPE_SIZE := 1 # default value of makePacketBasedInstance

CFLAGS += -Wall

MODULE := de.lucaswerkmeister.cformat
VERSION := 1.3.1
JAR := $(MODULE)-$(VERSION).jar

bindir := $(shell systemd-path user-binaries)
libdir := $(shell systemd-path user-library-private)
systemd_unit_dir := $(shell systemd-path user-shared)/systemd/user

$(CLIENT): client.c
	$(CC) $(CPPFLAGS) $(CFLAGS) -DLENGTH_SIZE=$(LENGTH_SIZE) -DTYPE_SIZE=$(TYPE_SIZE) $^ $(LDFLAGS) $(LOADLIBES) $(LDLIBS) -o $@

$(JAR): source/de/lucaswerkmeister/cformat/*.ceylon
	ceylon compile,fat-jar $(MODULE)

install: $(CLIENT) $(JAR)
	mkdir -p $(bindir) $(libdir) $(systemd_unit_dir)
	install $(CLIENT) $(bindir)
	cp $(JAR) $(libdir)
	cp cformat.service cformat.socket $(systemd_unit_dir)

uninstall:
	$(RM) $(bindir)/$(CLIENT) $(libdir)/$(JAR) $(systemd_unit_dir)/cformat.service $(systemd_unit_dir)/cformat.socket
	rmdir -p --ignore-fail-on-non-empty $(bindir) $(libdir) $(systemd_unit_dir)

.PHONY: install uninstall
