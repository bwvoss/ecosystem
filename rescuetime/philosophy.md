### Constraint Driven Development
- constraints must be enforcable via automated tasks, like a ci server could do.

Rubocop -- no violations
Flog -- cannot break 30
heckle and simplecov?
average test time, no test greater than N ms, or if a test is greater than 1 second to run
probably will need some sort of slow suite for longer tests, though they shouldn't be necessary
to run for usual development

### Test db constraints explicitly

### 1 Depth chain of responsibility

### Monitoring, Exception handling and the chocolate shell

### Failing
http://joearms.github.io/2013/04/28/Fail-fast-noisely-and-politely.html

fails with two error messages -- one for the programmer and log file for post-mortem
one for the user, polite and smooth for UX

### Test Performance

Think of the tests as the developer's UI.  This is the same position an average human being is in when visiting a website -- UX and performance are important, otherwise usage will drop.

http://blog.codinghorror.com/speed-still-matters/
http://blog.codinghorror.com/performance-is-a-feature/

Under 1 second, 0.1 feels instant.  Breakdown based on level, with avg. test time and outliers.
Also save a history based on commit.  Default test suite must be TIME sec or less.

I care about a threshold for a single spec time -- nothing over 0.5 second
What to do with the slow ones that I still need but definitely don't need to run everytime?
Full suite can be run in parallel -- I want a breakdown of total suite time per section, which shouldn't be hard by doing it with time and --profiler

### Test Printout

Write a script that parses the tests and prints it out in HTML -- this will probably depend on a specific convention being followed in how tests are written.

### Live SLA

Link to specific page showing statuses for features; and total uptime %.
Should show dependent service uptime, too?
eg for rescuetime sync service show your uptime, then how rescuetime impacted it, and total time to resolution...maybe benchmark-like analysis for service?

SLA is a legal agreement, but we can automate it just like business requirements for a project can be seen as a legal agreement as well, yet we automate the delivery of these through end-to-end testing.
