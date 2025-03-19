#!/bin/bash
# Build script for EmbedDB

set -e  # Exit on error

# Function to display help
show_help() {
    echo "Build script for EmbedDB"
    echo ""
    echo "Usage: ./build.sh [command]"
    echo ""
    echo "Commands:"
    echo "  clean       - Clean build artifacts"
    echo "  test        - Run tests"
    echo "  coverage    - Run tests with coverage"
    echo "  lint        - Run linting checks"
    echo "  format      - Format code with black and isort"
    echo "  verify      - Verify all main commands work"
    echo "  benchmark   - Run performance benchmarks"
    echo "  build       - Build package"
    echo "  install     - Install package in development mode"
    echo "  install-dev - Install package with development dependencies"
    echo "  publish     - Build and publish package to PyPI"
    echo "  help        - Show this help message"
    echo ""
}

# Clean build artifacts
clean() {
    echo "Cleaning build artifacts..."
    rm -rf build/ dist/ *.egg-info/ .coverage coverage.xml .pytest_cache/ __pycache__/ embeddb/__pycache__/ embeddb/tests/__pycache__/
    find . -name "*.pyc" -delete
    echo "Done!"
}

# Run tests
run_tests() {
    echo "Running tests..."
    python -m pytest
    echo "Done!"
}

# Run tests with coverage
run_coverage() {
    echo "Running tests with coverage..."
    python -m pytest --cov=embeddb --cov-report=term --cov-report=xml
    echo "Done!"
}

# Run linting checks
run_lint() {
    echo "Running linting checks..."
    python -m flake8 embeddb
    python -m black --check embeddb
    python -m isort --check-only embeddb
    echo "Done!"
}

# Format code
format_code() {
    echo "Formatting code..."
    python -m black embeddb
    python -m isort embeddb
    echo "Done!"
}

# Verify all main commands
verify_commands() {
    echo "Verifying all main commands..."
    python examples/verify_commands.py
    echo "Done!"
}

# Run benchmarks
run_benchmarks() {
    echo "Running performance benchmarks..."
    
    # Check if benchmark dependencies are installed
    if ! python -c "import psutil, matplotlib, numpy" &> /dev/null; then
        echo "Installing benchmark dependencies..."
        pip install -r examples/benchmark_requirements.txt
    fi
    
    python examples/benchmark.py
    echo "Done!"
}

# Build package
build_package() {
    echo "Building package..."
    python -m build
    echo "Done!"
}

# Install package in development mode
install_dev() {
    echo "Installing package in development mode..."
    pip install -e .
    echo "Done!"
}

# Install with development dependencies
install_with_dev_deps() {
    echo "Installing package with development dependencies..."
    pip install -e ".[embeddings]"
    pip install -r requirements-dev.txt
    echo "Done!"
}

# Publish package to PyPI
publish_package() {
    echo "Building and publishing package to PyPI..."
    # Check if twine is installed
    if ! command -v twine &> /dev/null; then
        echo "Error: twine is not installed. Please install it with:"
        echo "  pip install twine"
        exit 1
    fi
    
    # Check if build is installed
    if ! python -m build --help &> /dev/null; then
        echo "Error: build is not installed. Please install it with:"
        echo "  pip install build"
        exit 1
    fi
    
    # Build the package
    python -m build
    
    # Ask for confirmation
    echo ""
    echo "Ready to upload to PyPI. Please confirm."
    read -p "Do you want to continue? (y/n) " answer
    if [[ "$answer" != "y" ]]; then
        echo "Upload canceled."
        exit 0
    fi
    
    # Upload to PyPI
    python -m twine upload dist/*
    echo "Done!"
}

# Main script
case "$1" in
    clean)
        clean
        ;;
    test)
        run_tests
        ;;
    coverage)
        run_coverage
        ;;
    lint)
        run_lint
        ;;
    format)
        format_code
        ;;
    verify)
        verify_commands
        ;;
    benchmark)
        run_benchmarks
        ;;
    build)
        build_package
        ;;
    install)
        install_dev
        ;;
    install-dev)
        install_with_dev_deps
        ;;
    publish)
        publish_package
        ;;
    help|--help|-h)
        show_help
        ;;
    *)
        echo "Unknown command: $1"
        show_help
        exit 1
        ;;
esac 