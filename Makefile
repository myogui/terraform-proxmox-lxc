SHELL:=/bin/sh
.SILENT:

.PHONY: docs hooks
docs:
	terraform-docs markdown --config .docs/terraform-docs.yml .

hooks:
	cp .githooks/pre-commit .git/hooks/pre-commit
	chmod +x .git/hooks/pre-commit
