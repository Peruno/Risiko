# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Development Commands

This project uses UV for Python dependency management:

- **Install dependencies**: `uv sync`
- **Run the application**: `uv run python src/main.py`
- **Run tests**: `uv run pytest`
- **Run a specific test**: `uv run pytest test/test_composite_probabilities.py::test_function_name`
- **Run interactive Python**: `uv run python` (to import and test modules)

## Architecture Overview

This is a Python application that simulates Risk (Risiko) battle probabilities. The codebase is organized into several key components:

### Core Components

- **`src/basic_probabilities.py`**: Contains `BasicProbabilities` class that calculates single dice roll probabilities for different attacker/defender combinations (1v1, 1v2, 2v1, 2v2, 3v1, 3v2)
- **`src/composite_probabilities.py`**: Contains `CompositeProbabilities` class that builds on basic probabilities to calculate complex battle outcomes using recursive and matrix methods
- **`src/simulator.py`**: Contains `Simulator` class that provides the main interface for running simulations and generating matplotlib visualizations
- **`src/main.py`**: Entry point that demonstrates the simulation with a sample 30v20 battle

### Key Algorithms

The application implements multiple mathematical approaches:

1. **Recursive Method**: Direct recursive calculation of win probabilities
2. **Matrix Method**: Dynamic programming approach using matrices for efficient calculation
3. **Precise Calculations**: Methods to calculate exact probabilities for specific outcomes (e.g., winning with exactly N troops remaining)
4. **Safe Attack Mode**: Simulation of conservative attacks where attacker stops at 2 troops

### Testing

- Tests are in `test/` directory using pytest
- Key test validates that recursive and matrix methods produce identical results
- Tests verify probability calculations sum to 1.0 (all outcomes accounted for)

### Dependencies

- **numpy**: For matrix operations and numerical calculations
- **matplotlib**: For generating probability distribution charts
- **pytest**: For running tests (implied by test structure)

### Project Context

This is a learning project focused on:
- Building cross-platform mobile app capabilities
- Understanding app development fundamentals
- Implementing mathematical probability calculations
- Creating intuitive UIs for probability visualization

The current implementation is a Python proof-of-concept that calculates and visualizes Risk battle probabilities, with plans to evolve into a mobile application.