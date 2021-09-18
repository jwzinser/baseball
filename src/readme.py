readme = """This data release lives at https://kaggle.com/seanlahman/baseball and was created by code at https://github.com/benhamner/baseball.

It is a processed version of the 2015 data at www.seanlahman.com/baseball-archive/statistics/.

The original database was copyright 1996-2015 by Sean Lahman and licensed under a Creative Commons Attribution-ShareAlike 3.0 Unported License.  For details see: http://creativecommons.org/licenses/by-sa/3.0/

Likewise, this modified version is released under a Creative Commons Attribution-ShareAlike 3.0 Unported License.  For details see: http://creativecommons.org/licenses/by-sa/3.0/

The two key modifications from the original database were:

 - we updated column names to have consistent formatting and naming
 - we created a SQLite datbase in addition to the original CSV files

Below, we're copying README.txt and readme2014.txt from the original 2015 database. Note that the column names may have been modified from the ones stated in readme2014.txt. See https://github.com/benhamner/baseball/blob/master/src/process.py#L43 for the modifications to column names.

README.txt
==============================================================

%s

readme2014.txt
==============================================================

%s
""" % (open("input/baseballdatabank-master/README.txt").read(),
       open("input/baseballdatabank-master/core/readme2014.txt").read())

open("output/readme.txt", "w").write(readme)