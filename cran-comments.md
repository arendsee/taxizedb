## Test environments

* local OS X install, R 3.4.0 patched
* ubuntu 12.04 (on travis-ci), R 3.4.0
* win-builder (devel and release)

## R CMD check results

0 errors | 0 warnings | 1 note

* Note about license:
License components with restrictions and base license permitting such:
  MIT + file LICENSE
File 'LICENSE':
  YEAR: 2017
  COPYRIGHT HOLDER: Scott Chamberlain

## Reverse dependencies

There are no reverse dependencies.

---

This version fixes SQL database connection functions for changes in `dplyr`, 
which now requires the new `dbplyr` package.

Thanks!
Scott Chamberlain
