module LogTex
( createEntry
, dateListToTex
) where

import Date
import Data.List
import Data.List.Split
import Data.Function (on)

createEntry :: [String] -> (String, String) -> [String]
createEntry [] _ = [""]
createEntry (line:template) f@(path, name) = alteredLine : createEntry template f
  where
    flags = [("#DATE", date), ("#FILENAME", name), ("#FILEPATH", path)]
    date = prettyPrint DDMMYYYY $ nameToDate name
    alteredLine = foldl (\l (flag,x) -> replace flag x l) line flags
    replace old new = intercalate new . splitOn old

dateListToTex :: [(Date,String)] -> String
dateListToTex datelist = concat $ map snd sorted
  where
    sorted = sortBy (compare `on` fst) datelist
