# makediary
Little program to help you organize a diary-like structured document with LaTex.

### Usage
Running `makediary mydiary.tex diaryfolder` will look up every `.tex` file inside the diaryfolder that is named like `YYYY-MM-DD.tex` (the seperator actually doesn't need to be a `-`), sorts them by date and creates the file `mydiary.tex`.
This file contains include-statements to every found tex-file, respecting its path.

For example f you have a directory that is somewhat structured like this
```
diary
├── 2017
│   ├── 2017-04-03.tex
│   ├── 2017-09-10.tex
│   └── 2017-11-12.tex
└── 2018
    ├── 2018-06-18.tex
    └── 2018-12-30.tex

```
`makediary mydiary.tex diary` will create the file `mydiary.tex` that contains a log-entry for every `.tex`-file inside the diary directory, sorted by date.

You could also do `makediary update mydiary_18.tex diary/2018` to only collect entries from 2018.
