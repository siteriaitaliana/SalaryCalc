Feature: Check normal execution
	In order to see the file being created and processed
	
Scenario:	launch the cli command
	When I run "ruby main.rb"
	Then I should see:
	"""
	Specify your .csv filename (default payroll.csv):
	"""