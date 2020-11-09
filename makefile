#
DEFAULT: help

# Want to be explicit about using python 2, not 3.
PYTHON = $(shell which python2)
#
# TODO don't assume that we are running make from the same dir as the makefile
BASE_DIR = $(CURDIR)
VENV_DIR = $(BASE_DIR)/venv
VENV_BIN_DIR = $(VENV_DIR)/bin
VENV_ETC_DIR = $(VENV_DIR)/etc
MASTER_DIR = $(VENV_DIR)/master
SLAVE_DIR = $(VENV_DIR)/slave
MASTER_RUNNER = $(VENV_BIN_DIR)/buildbot
MASTER_DEFAULT = $(VENV_ETC_DIR)/default/buildmaster
SLAVE_RUNNER = $(VENV_BIN_DIR)/buildslave
SLAVE_DEFAULT = $(VENV_ETC_DIR)/default/buildslave
PYTHON_CMD = $(VENV_BIN_DIR)/python
PIP_CMD = $(VENV_BIN_DIR)/pip
#
GIT_BASE_DIR = $(VENV_DIR)/source-files
GIT_CODE_DIR = $(GIT_BASE_DIR)/code-files.git
GIT_TEST_DATA_DIR = $(GIT_BASE_DIR)/test-data.git
#
REQUIREMENTS_FILE = requirements.txt

venv: _setup_virtualenv _setup_git_repos
	mkdir -p $(VENV_DIR)/etc/init.d
	mkdir -p $(VENV_DIR)/etc/default
	mkdir -p $(VENV_DIR)/master
	mkdir -p $(VENV_DIR)/slave

config: _create_master
	sed \
		-e 's|{{USER}}|$(USER)|g' \
		-e 's|{{MASTER_DIR}}|$(MASTER_DIR)|g' \
		-e 's|{{MASTER_DEFAULT}}|$(MASTER_DEFAULT)|g' \
		-e 's|{{MASTER_RUNNER}}|$(MASTER_RUNNER)|g' \
		templates/default-master.sh \
		> $(VENV_ETC_DIR)/default/buildmaster
	sed \
		-e 's|{{USER}}|$(USER)|g' \
		-e 's|{{MASTER_DIR}}|$(MASTER_DIR)|g' \
		-e 's|{{MASTER_DEFAULT}}|$(MASTER_DEFAULT)|g' \
		-e 's|{{MASTER_RUNNER}}|$(MASTER_RUNNER)|g' \
		templates/init-master.sh \
		> $(VENV_ETC_DIR)/init.d/buildmaster
	sed \
		-e 's|{{SLAVE_DEFAULT}}|$(SLAVE_DEFAULT)|g' \
		-e 's|{{SLAVE_RUNNER}}|$(SLAVE_RUNNER)|g' \
		templates/init-slave.sh \
		> $(VENV_ETC_DIR)/init.d/buildslave
	chmod u+x $(VENV_ETC_DIR)/init.d/buildmaster
	chmod u+x $(VENV_ETC_DIR)/init.d/buildslave
	cp master.cfg $(MASTER_DIR)

_create_master:
	$(MASTER_RUNNER) create-master $(MASTER_DIR)

_setup_virtualenv:
ifeq (, $(wildcard $(VENV_DIR)))
	@echo "Creating virtualenv: $(VENV_DIR)"
	virtualenv --python $(PYTHON) $(VENV_DIR)
endif
	$(PIP_CMD) install -r $(REQUIREMENTS_FILE)
	#$(DEV_PYTHON_CMD) setup.py develop

_setup_git_repos:
ifeq (, $(wildcard $(GIT_CODE_DIR)))
	@echo "Creating code git repo: $(GIT_CODE_DIR)"
	mkdir -p $(VENV_DIR)/source-files/code-files.git
	git init $(VENV_DIR)/source-files/code-files.git
endif
ifeq (, $(wildcard $(GIT_TEST_DATA_DIR)))
	@echo "Creating test data git repo: $(GIT_CODE_DIR)"
	mkdir -p $(VENV_DIR)/source-files/test-data.git
	git init $(VENV_DIR)/source-files/test-data.git
endif

info:
	@echo "User: $(USER)"
	@echo "Python: $(PYTHON)"
	@echo "Virtualenv Dir: $(VENV_DIR)"
	@echo "Master dir: $(MASTER_DIR)"
	@echo "Slave dir: $(SLAVE_DIR)"
	@echo "Master runner: $(MASTER_RUNNER)"
	@echo "Slave runner: $(SLAVE_RUNNER)"

clean:
	rm -rf $(VENV_DIR)

help:
	@echo "Please select from one of the following:"
	@echo "	config	Create config files from templates"
	@echo "	venv	Create virtualenv and git repos"
	@echo "	info	Show various settings"
	@echo "	clean	Remove: $(VENV_DIR)"
	@echo "	help	This message"
# End of file.
