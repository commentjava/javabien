EXT := byte
CC := ocamlbuild

MAIN_DIR := MAIN
MAIN := Main

MLY_FILES := $(shell find . -name '*.mly' )
MLL_FILES := $(shell find . -name '*.mll' )
ML_FILES := $(shell find . -name '*.ml' )

TEST_DIR := Test
TEST_FILES = $(shell find $(TEST_DIR) -name '*Test.ml')
TESTS := $(basename $(notdir $(TEST_FILES)))
TEST_BINS := $(addsuffix .$(EXT), $(TESTS))
RUN_TESTS := $(addprefix test-, $(TEST_BINS))

all: $(MAIN).$(EXT)

# Builds
$(MAIN).$(EXT): $(ML_FILES) $(MLL_FILES) $(MLY_FILES) Makefile
	$(CC) $(MAIN).$(EXT)

$(TEST_BINS): $(ML_FILES) $(MLL_FILES) $(MLY_FILES) Makefile
	$(CC) $(TEST_DIR)/$@

# Tests
test-all: $(RUN_TESTS)

$(RUN_TESTS): $(TEST_BINS)
	./$(subst test-,,$@)

test-list:
	@for t in $(RUN_TESTS) ; do \
	echo "$$t" ; \
	done;
	@echo "test-all"

clean:
	$(CC) -clean

.PHONY: all clean test-all test-list
