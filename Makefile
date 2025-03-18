.PHONY: test lint format clean install install-dev

test:
	pytest --cov=embeddb

lint:
	flake8 embeddb
	black --check embeddb
	isort --check-only embeddb

format:
	black embeddb
	isort embeddb

clean:
	rm -rf build/
	rm -rf dist/
	rm -rf *.egg-info
	find . -type d -name __pycache__ -exec rm -rf {} +
	find . -type f -name "*.pyc" -delete

install:
	pip install -e .

install-dev:
	pip install -e ".[embeddings]"
	pip install -r requirements-dev.txt 