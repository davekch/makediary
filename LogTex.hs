module LogTex
( createEntry
, dateListToTex
) where

import Date
import Data.List
import Data.Function (on)

createEntry :: Style -> (String, String) -> String
createEntry style (dir, filename) =
  "%" ++ show (nameToDate filename) ++ "\n"
  ++ "\\begin{loggentry}{" ++ dateStr ++ "}\n"
  ++ "  \\input{" ++ dir ++ "}\n"
  ++ "\\end{loggentry}\n\n"
  where
    dateStr = prettyPrint style $ nameToDate filename

dateListToTex :: [(Date,String)] -> String
dateListToTex datelist = concat $ map snd sorted
  where
    sorted = sortBy (compare `on` fst) datelist
