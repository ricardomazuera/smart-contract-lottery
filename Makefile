
run-tests:
	@echo "Formatting code..."
	forge fmt
	@echo "Running tests"
	forge coverage
	@echo "Exporting coverage report"
	forge coverage --report debug > coverage.txt