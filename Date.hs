module Date
( Date(..)
, Style(..)
, nameToDate
, prettyPrint
) where

import Data.Char
import Data.Function (on)
import Data.List

data Style = DDMMYYYY | DDMonYY deriving (Eq)

type Year = Int
type Day = Int
type Month = Int

data Date = Date Year Month Day deriving (Eq)

instance Show Date where
  show (Date y m d) = intercalate "-" $ map show [y,m,d]

instance Ord Date where
  compare (Date y1 m1 d1) (Date y2 m2 d2)
    | y1==y2 && m1==m2 = compare d1 d2
    | y1==y2 = compare m1 m2
    | otherwise = compare y1 y2


-- converts "2014-4-2.tex" to Date 2014 4 2
nameToDate :: String -> Date
nameToDate name = Date (date!!0) (date!!1) (date!!2)
  where
    -- take name, group by digits and throw away everything which doesnt start with a digit,
    -- then map read over it to get Ints
    date = map read $ filter (isDigit . (!!0)) $ groupBy ((==) `on` isDigit) name :: [Int]

prettyPrint :: Style -> Date -> String
prettyPrint style (Date y m d)
  | style==DDMMYYYY = intercalate ".\\," $ map show [d,m,y]
  | style==DDMonYY  = intercalate ".\\," $ [show d, mon, show sy]
  where
    mon = ["Jan","Feb","Mär","Apr","Mai","Jun","Jul","Aug","Okt","Nov","Dez"]!!(m-1)
    sy = y `mod` 100
