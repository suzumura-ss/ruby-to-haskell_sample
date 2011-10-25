require 'rbconfig'


TARGET = 'factorial'
C_SRC = %w{ main.c }
HS_SRC = %w{ factorial.hs }
HS_LIBS = %w{ base integer-gmp ghc-prim }

CONF = RbConfig::MAKEFILE_CONFIG
VALS = %w{prefix includedir RUBY_BASE_NAME ruby_version rubyhdrdir arch MKDIR_P INSTALL INSTALL_PROGRAM}.map{|k|
          "#{k}=#{CONF[k]}"
        }.join("\n")
GHC_LIBDIR=`ghc --print-libdir`.strip
FLAGS = "FLAGS=-I$(rubyhdrdir) -I$(rubyhdrdir)/$(arch) -shared -dynamic -no-hs-main -lHSrts -lffi\n" \
       + "FLAGS+=-no-auto-link-packages -I#{GHC_LIBDIR}/include -L#{GHC_LIBDIR}\n" \
       + HS_LIBS.map{|l|
          'FLAGS+=' + `ghc-pkg describe #{l}|sed -ne 's/library-dirs: /-L/p;s/hs-libraries: /-l/p;'`.gsub(/\n/, ' ')
         }.join("\n") \
       + "\nFLAGS+=-lgmp\n"

File.open("Makefile", "w") {|f|
  f.puts <<__MAKEFILE__
TARGET=#{TARGET}.#{CONF['DLEXT']}
HS_SRC=#{HS_SRC.join(' ')}
C_SRC=#{C_SRC.join(' ')}

#{VALS}
#{FLAGS}
STUB=$(HS_SRC:.hs=_stub.o)

all : $(TARGET)

$(STUB) : $(HS_SRC)
	ghc $<

$(TARGET) : $(C_SRC) $(STUB) $(HS_SRC:.hs=.o)
	ghc -o $@ $^ $(FLAGS)

install:
	$(MKDIR_P) ../lib/#{TARGET}/
	$(INSTALL_PROGRAM) $(TARGET) ../lib/#{TARGET}/

clean:
	rm -f $(TARGET) $(C_SRC:.c=.o) $(HS_SRC:.hs=.hi) $(HS_SRC:.hs=.o) $(HS_SRC:.hs=_stub.)*
__MAKEFILE__
}
