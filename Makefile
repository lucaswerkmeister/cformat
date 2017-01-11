NAME := cformat
LENGTH_SIZE := 2 # default value of makePacketBasedInstance
TYPE_SIZE := 1 # default value of makePacketBasedInstance

CFLAGS += -Wall

$(NAME): client.c
	$(CC) $(CPPFLAGS) $(CFLAGS) -DLENGTH_SIZE=$(LENGTH_SIZE) -DTYPE_SIZE=$(TYPE_SIZE) $^ $(LDFLAGS) $(LOADLIBES) $(LDLIBS) -o $@
