.PHONY: train

jupyter:
	export PYTHONPATH=`pwd`; screen .venv/bin/jupyter notebook --ip 0.0.0.0 --port=8109 --no-browser .

browser:
	export PYTHONPATH=`pwd`; screen .venv/bin/jupyter notebook --ip 0.0.0.0 --port=8109 .

setup:
	virtualenv >/dev/null 2>&1 || python3 -m pip install --user virtualenv
	test -d .venv || virtualenv --python=python3.6 .venv
	poetry >/dev/null 2>&1 || python3 -m pip install --user poetry
	poetry install
	.venv/bin/jupyter nbextension enable --py widgetsnbextension

# See https://github.com/sdispater/poetry/issues/100
define get_requirements
import tomlkit
with open('poetry.lock') as t:
    lock = tomlkit.parse(t.read())
    for p in lock['package']:
        if not p['category'] == 'dev':
            print(f"{p['name']}=={p['version']}")
endef
export get_requirements

requirements.txt: poetry.lock
	.venv/bin/python -c "$$get_requirements" | grep -v pywin > $@