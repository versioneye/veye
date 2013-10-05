dep-doc:
	veye check Gemfile.lock --format=table > DEPENDENCIES.md
