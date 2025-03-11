## Not so reproducible astronaut data analysis code

This repository contains a helper software project with some code to be used 
for the [Advanced R - Reproducibility with R course](https://github.com/bham-carpentries/2025-03-10-r-advanced). 

This repository is an example of "not so reproducible" code project that is meant to be improved over the course to show examples of reproducible coding practices. 

Various branches of this repository represent the state of the code as it should be at the start of each of the course episodes:

- Episodes ["1. Course introduction"](https://github.com/bham-carpentries/2025-03-10-r-advanced/01-introduction.html), ["2. Good Practices"](https://github.com/bham-carpentries/2025-03-10-r-advanced/02-good-practices.html) are not making changes to the software
- [branch 03-code-readability](https://github.com/bham-carpentries/2025-03-10-r-advanced/03-code-readability.html) matches the code at the start of episode ["3. Code Readability"](https://github.com/bham-carpentries/2025-03-10-r-advanced/03-code-readability.html)
- [branch 04-code-readability](https://github.com/bham-carpentries/2025-03-10-r-advanced/03-code-readability.html) matches the code at the start of episode ["4. Project Structure"](https://github.com/bham-carpentries/2025-03-10-r-advanced/04-project-structure.html)
- [branch 05-code-documentation](https://github.com/bham-carpentries/2025-03-10-r-advanced/05-code-readability.html) matches the code at the start of episode ["5. Code Documentation"](https://github.com/bham-carpentries/2025-03-10-r-advanced/05-code-readability.html)
- [branch 06-code-correctness](https://github.com/bham-carpentries/2025-03-10-r-advanced/06-code-correctness.html) matches the code at the start of episode ["6. Code Correctness"](https://github.com/bham-carpentries/2025-03-10-r-advanced/06-code-correctness.html)
- [branch 07-code-environment](https://github.com/bham-carpentries/2025-03-10-r-advanced/07-code-environment.html) matches the code at the start of episode ["7. Code Environment"](https://github.com/bham-carpentries/2025-03-10-r-advanced/07-code-environment.html)
- [branch 08-wrap-up](https://github.com/bham-carpentries/2025-03-10-r-advanced/08-wrap-up.html) matches the code at the start of episode ["3. Code Readability"](https://github.com/bham-carpentries/2025-03-10-r-advanced/08-wrap-up.html)


### What the code does
The code uses the [NASA data on human space walks (Extravehicular activities - EVAs)](https://data.nasa.gov/Raw-Data/Extra-vehicular-Activity-EVA-US-and-Russia/9kcy-zwvn/data_preview), 
exported/downloaded in JSON format, does some analysis over this data, plots a few graphs and saves the data in CSV format. 

### Better code
An example of better and more reproducible code that participants should strive to achieve when writing their reseach software 
can be found on the final branch [branch 08-wrap-up](https://github.com/bham-carpentries/2025-03-10-r-advanced/08-wrap-up.html).

### Acknowledgements

#### Data

The data used on in this project was obtained from NASA as follows.

Data source: https://data.nasa.gov/Raw-Data/Extra-vehicular-Activity-EVA-US-and-Russia/9kcy-zwvn/about_data.

Either export data from the above page using the `Export` button or download in JSON format from command line as: 

`curl https://data.nasa.gov/resource/eva.json --output eva-data.json`

**Note: the original data has been modified for the purposes of this tutorial by inserting a semicolon separator after each name in the `crew` field.**

#### Attribution
This repository is an R-port (with modifications to match the flow of our course) of the [helper software code](https://github.com/carpentries-incubator/astronaut-data-analysis-not-so-fair/tree/main) 
from the [FAIR research software course](https://github.com/carpentries-incubator/fair-research-software). 
reused and modified under MIT license.  

##### 
The original licence text from the [helper software code](https://github.com/carpentries-incubator/astronaut-data-analysis-not-so-fair/tree/main) is
provided here:

MIT License

Copyright (c) 2024 carpentries-incubator

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.

See
[![DOI](https://zenodo.org/badge/776011771.svg)](https://zenodo.org/doi/10.5281/zenodo.12699084)

