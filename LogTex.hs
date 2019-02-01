module LogTex
( createEntry
, texToDateList
, dateListToTex
) where

import Date
import Data.List
import Data.Function (on)

createEntry :: Style -> (String, String) -> String
createEntry style (dir, filename) =
  "%" ++ show (nameToDate filename) ++ "\n"
  ++ "\\begin{loggentry}{" ++ dateStr ++ "}\n"
  ++ "  \\input{" ++ dir ++ "/" ++ filename ++ "}\n"
  ++ "\\end{loggentry}\n\n"
  where
    dateStr = prettyPrint style $ nameToDate filename

-- expects a latex string split into lines, blocks seperated by empty lines
texToDateList :: [String] -> [(Date,String)]
texToDateList = parseBlockList . makeBlockList
  where
    -- extract blocks and remove empty lines between them
    makeBlockList = filter (not . ("" `elem`)) . groupBy ((==) `on` (/=""))
    parseBlockList [] = []
    -- take a list of blocks, for each block find the date and append tuple (date, block)
    parseBlockList (x:xs) = (date, unlines x):parseBlockList xs
      where
        date = nameToDate datecomment
        (Just datecomment) = find (\x -> x!!0=='%') x

dateListToTex :: [(Date,String)] -> String
dateListToTex datelist = concat $ map snd sorted
  where
    sorted = sortBy (compare `on` fst) datelist
