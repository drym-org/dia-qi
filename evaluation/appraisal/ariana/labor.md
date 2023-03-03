* Qi
	* (30%) Initial work / foundation
		* (50%) The language was designed
		* (50%) The initial implementation was written
	* (20%) Promotion / getting the word out / community
		* (5%) The initial author was invited to give a talk at RacketCon
		* (2%) The initial author received feedback on drafts of the talk
		* (17%) The initial author gave a talk at RacketCon
		* (3%) A Q&A was held after the talk
		* (3%) An early adopter advocated for the project
		* (3%) An early adopter advocated for the project
		* (3%) An early adopter advocated for the project
		* (5%) Advent of Code was solved using Qi
		* (2%) The idea of a Qi-themed event was suggested
		* (7%) The Qi design challenge was organized
		* (14%) A weekly meetup for the project was started
		* (14%) The project benefited from general support from the Racket community
		* (10%) The first library extending Qi functionality was written
		* (2%) There was a suggestion to write a tutorial
		* (10%) An interactive tutorial was written using racket templates
	* (10%) Documentation
		* (5%) A quickscript for interactive evaluation in DrRacket was added to support the Qi tutorial
		* (2%) A broken link in the documentation was reported
		* (5%) There was a suggestion to create a wiki for Qi
		* (20%) The wiki was created
		* (20%) A Developer's Guide containing developer documentation was written
		* (50%) Documentation was written for Qi
		* (3%) Some formatting and typos in the docs were fixed
	* (10%) Improving usability / ease of adoption:
		* (55%) Racket templates
			* There was a suggestion to distribute a Qi template using racket templates
			* There was a suggestion to decompose the package into lib/test/doc packages for more flexible development and distribution
			* The package was decomposed into lib/test/doc packages
			* An installation issue was reported
		* (20%) IDE support
			* A quickscript for entering unicode in DrRacket was written
			* A flow-oriented debugger was added
		* (10%) The package config was modified so that Qi appears in the languages section of the docs
		* (5%) A recipe for hosting backup documentation in case the package index is unavailable was provided
		* (5%) The backup docs workflow following the recipe was added
		* (5%) The repo was migrated to an organization account
	* Implementation (20%)
		* (15%) The core macro was refactored into separate expansion and compilation stages
		* (30%) Macro extensibility
			* (30%) A simple macro extensibility based on prefix matching was designed, to allow users to extend the syntax of the language in a rudimentary way
			* (20%) An implementation for the prefix matching macro extensibility scheme was provided
			* (10%) Many options for proper macro extensibility were suggested
			* (40%) "First class" macro extensibility was implemented, allowing users to seamlessly extend the syntax of the language
		* (50%) Form improvements
			* (12%) Switch form
				* (15%) Improvements to the switch form were suggested
				* (70%) Improvements to switch were implemented
				* (15%) Some bugs in switch were fixed
			* (12%) Clos form
				* (50%) A design example was provided to motivate adding closures (the clos form) to Qi
				* (50%) The name clos was suggested for this form
			* (12%) Threading form error message
				* (20%) A confusing error message in the threading form was reported and a way to handle it was suggested
				* (20%) The suggested error message fix was implemented
				* (20%) Threading form bug
				* (20%) An elusive bug was identified that was causing performance degradation in the threading form
				* (20%) A hygiene issue related to the same bug was identified that could have caused other bugs in the future
			* (12%) Feedback form design improvements
				* (15%) An example implementation to motivate design improvements in feedback was provided
				* (70%) The design of feedback was improved
				* (15%) The feedback PR was reviewed
			* (12%) Restricting fancy-app
				* (15%) There was a suggestion to restrict fancy-app's (a templatized function application library) scope in Qi to avoid tricky bugs in handling user input
				* (70%) fancy-app was restricted to just the fine-grained application form
				* (15%) The fancy-app PR was reviewed
			* (12%) Optimizing fanout
				* (10%) It was pointed out that fanout does not accept arbitrary Racket expressions for N
				* (10%) An optimized implementation was suggested for fanout
				* (70%) fanout was modified to support arbitrary expressions for N and have an optimized implementation
				* (10%) The fanout PR was reviewed
			* (12%) Partition
				* (80%) partition was added, which is a generalized version of the sieve form
				* (20%) The partition PR was reviewed
			* (3%) The ability to support the _ template in the function position was added
			* (3%) Support for keyword arguments to add bindings in lambda forms of the language was added
		* (5%) Reducing tech debt
			* (33%) Uses of deprecated macro form ~or were updated to ~or*
			* (33%) The unused let/flow and let/switch macros were removed
			* (34%) The organization of some tests was improved
	* (10%) Operational excellence
		* (50%) Performance
			* (10%) The partition implementation was optimized
			* (20%) Benchmarking scripts were added
			* (10%) The performance benchmarks were audited for accuracy
			* (10%) The benchmarks were fixed according to the audit
			* (10%) The number of dependencies was reduced
			* (10%) These tools were used to identify and remove all heavy dependencies and dramatically reduce load-time latency
			* (10%) The performance of any?, all?, and none? were significantly improved
			* (10%) There was a suggestion to use indirect documentation links to reduce build times
			* (10%) Some improvements were suggested to reduce memory consumption in building docs
		* (50%) Dev Tools
			* (20%) CI was set up for the project repository
			* (15%) Performance benchmarking was added to CI
			* (20%) A dependency profiler tool was written to identify heavy dependencies
			* (5%) A way to measure load-time latency was suggested
			* (20%) A script to measure load-time latency following that approach was written
			* (5%) The load-time latency PR was reviewed
			* (15%) The benchmarks runner config was modified to avoid reporting success when it failed
