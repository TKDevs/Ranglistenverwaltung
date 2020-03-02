# Turnierauswertung

	Ein Projekt für das Fach Informatiksysteme von Jonas Tröger und Paul Kern.
	Eingebundene Themengebiete sind Datenbanken und Softwareentwicklung.
	
## Notes:
	Keine Änderungen im Objektinspector außer Name!
	https://confluence.atlassian.com/bitbucketserver/basic-git-commands-776639767.html
	
## Naming conventions:
	Names should be descriptive; avoid abbreviation.
	Give as descriptive a name as possible, within reason. Do not worry about saving horizontal space as it is far more important to make your code immediately understandable by a new reader. Do not use abbreviations that are ambiguous or unfamiliar to readers outside your project, and do not abbreviate by deleting letters within a word. Abbreviations that would be familiar to someone outside your project with relevant domain knowledge are OK. As a rule of thumb, an abbreviation is probably OK if it's listed in Wikipedia.
	For some symbols, this style guide recommends names to start with a capital letter and to have a capital letter for each new word (a.k.a. "Camel Case" or "Pascal case"). When abbreviations or acronyms appear in such names, prefer to capitalize the abbreviations or acronyms as single words (i.e StartRpc(), not StartRPC()).

	Good:
	int price_count_reader;    // No abbreviation.
	int num_errors;            // "num" is a widespread convention.
	int num_dns_connections;   // Most people know what "DNS" stands for.
	int lstm_size;             // "LSTM" is a common machine learning abbreviation.

	Bad:
	int n;                     // Meaningless.
	int nerr;                  // Ambiguous abbreviation.
	int n_comp_conns;          // Ambiguous abbreviation.
	int wgc_connections;       // Only your group knows what this stands for.
	int pc_reader;             // Lots of things can be abbreviated "pc".
	int cstmr_id;              // Deletes internal letters.
	FooBarRequestInfo fbri;    // Not even a word.

	------------------------------------------------------------------------------------
	File Names

	Filenames should be all lowercase and can include underscores (_) or dashes (-). Follow the convention that your project uses. If there is no consistent local pattern to follow, prefer "_".

	Good:
	my_useful_class.cc
	my-useful-class.cc
	myusefulclass.cc

	------------------------------------------------------------------------------------
	Variable Names

	The names of variables (including function parameters) and data members are all lowercase, with underscores between words. Data members of classes (but not structs) additionally have trailing underscores. For instance: a_local_variable, a_struct_data_member, a_class_data_member_.

	Good:
	string table_name;  // OK - uses underscore.
	string tablename;   // OK - all lowercase.

	Bad:
	string tableName;   // Bad - mixed case.

	------------------------------------------------------------------------------------
	Class Data Members

	Data members of classes, both static and non-static, are named like ordinary nonmember variables, but with a trailing underscore.

	class TableInfo {
	  ...
	 private:
	  string table_name_;  // OK - underscore at end.
	  string tablename_;   // OK.
	  static Pool<TableInfo>* pool_;  // OK.
	};

	------------------------------------------------------------------------------------
	Constant Names

	Variables declared constexpr or const, and whose value is fixed for the duration of the program, are named with a leading "k" followed by mixed case. Underscores can be used as separators in the rare cases where capitalization cannot be used for separation. For example:
	const int kDaysInAWeek = 7;
	const int kAndroid8_0_0 = 24;  // Android 8.0.0

	------------------------------------------------------------------------------------
	Function Names

	Regular functions have mixed case; accessors and mutators may be named like variables.
	Ordinarily, functions should start with a capital letter and have a capital letter for each new word.

	AddTableEntry()
	DeleteUrl()
	OpenFileOrDie()
