require 'rbconfig'


TARGET = 'factorial'
C_SRC = %w{ main.c }
HS_SRC = %w{ factorial.hs }

CONF = RbConfig::MAKEFILE_CONFIG
VALS = %w{prefix includedir RUBY_BASE_NAME ruby_version rubyhdrdir arch MKDIR_P INSTALL INSTALL_PROGRAM}.map{|k|
          "#{k}=#{CONF[k]}"
        }.join("\n")

File.open("Makefile", "w") {|f|
  f.puts <<__MAKEFILE__
TARGET=#{TARGET}.#{CONF['DLEXT']}
HS_SRC=#{HS_SRC.join(' ')}
C_SRC=#{C_SRC.join(' ')}

#{VALS}
CFLAGS=-I$(rubyhdrdir) -I$(rubyhdrdir)/$(arch) -lHSrts -lffi -shared -dynamic -no-hs-main
STUB=$(HS_SRC:.hs=_stub.o)

all : $(TARGET)

$(STUB) : $(HS_SRC)
	ghc $<

$(TARGET) : $(C_SRC) $(STUB) $(HS_SRC:.hs=.o)
	ghc -o $@ $(CFLAGS) $^

install:
	$(MKDIR_P) ../lib/#{TARGET}/
	$(INSTALL_PROGRAM) $(TARGET) ../lib/#{TARGET}/

clean:
	rm -f $(TARGET) $(C_SRC:.c=.o) $(HS_SRC:.hs=.hi) $(HS_SRC:.hs=.o) $(HS_SRC:.hs=_stub.)*
__MAKEFILE__
}
