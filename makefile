#
DEFAULT: help

# Want to be explicit about using python 2, not 3.
PYTHON = $(shell which python2)
#
VENV_DIR = venv
VENV_BIN_DIR = $(VENV_DIR)/bin
PYTHON_CMD = $(VENV_BIN_DIR)/python
PIP_CMD = $(VENV_BIN_DIR)/pip
#
REQUIREMENTS_FILE = requirements.txt

setup: _setup_virtualenv _setup_git_repos
	ln -Fs etc/default $(VENV_DIR)/etc
	ln -Fs etc/init.d $(VENV_DIR)/etc

_setup_virtualenv:
	virtualenv --python $(PYTHON) $(VENV_DIR)
	$(PIP_CMD) install -r $(REQUIREMENTS_FILE)

_setup_git_repos:
	mkdir -p $(VENV_DIR)/source-files/code-files.git
	mkdir -p $(VENV_DIR)/source-files/test-data.git
	git init $(VENV_DIR)/source-files/code-files.git
	git init $(VENV_DIR)/source-files/test-data.git


info:
	@echo "Python: $(PYTHON)"
	@echo "Virtualenv Dir: $(VENV_DIR)"

clean:
	rm -rf $(VENV_DIR)

help:
	@echo "Please select from one of the following:"
	@echo "	setup	Create virtualenv and git repos"
	@echo "	info	Show various settings"
	@echo "	clean	Remove: $(VENV_DIR)"
	@echo "	help	This message"
# End of file.
