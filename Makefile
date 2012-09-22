TESTS = test/*.js
TESTTIMEOUT = 1000
REPORTER = progress
SUPPORT_VERSIONS := 1.9.2 1.9.1 1.9.0 1.8.0 1.8.5 1.8.6 1.8.7 \
	2.2.0 2.2.1 2.2.2 \
	2.3.0 2.3.1 2.3.2 2.3.3 2.3.4 2.3.5 2.3.6 2.3.7 2.3.8 2.3.9 \
	2.4.0 2.4.1 2.4.2 2.4.3 2.4.4 2.4.5 2.4.6

test:
	@NODE_ENV=test ./node_modules/.bin/mocha -R $(REPORTER) --timeout $(TESTTIMEOUT) $(TESTS)

test-cov: lib-cov
	@URLROUTER_COV=1 $(MAKE) test REPORTER=html-cov > coverage.html
	@$(MAKE) test-results

test-results:
	@$(MAKE) test REPORTER=markdown > test_results.md

lib-cov:
	@rm -rf ./$@
	@jscoverage lib $@

clean:
	@rm -rf lib-cov
	@rm -f coverage.html

test-version:
	@for version in $(SUPPORT_VERSIONS); do \
		npm install connect@$$version --loglevel=warn; \
		$(MAKE) test; \
	done

.PHONY: test test-cov clean lib-cov test-version test-results