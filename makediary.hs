import System.IO
import System.Directory
import System.Environment
import Data.Function (on)
import Data.List
import Data.Char (isDigit)
import Control.Monad (filterM)
import LogTex
import Date

commands :: [(String, [String] -> IO ())]
commands = [ ("check", check)
           , ("update", updateTexFile)]

main = do
  (command:args) <- getArgs
  let (Just action) = lookup command commands
  action args

-- checks if the texfile is up-to-date with the existing diary files
check :: [String] -> IO ()
check [texfile, dir] = do
  datelist <- getDateList texfile
  filelist <- getDiaryFiles dir
  let alreadythere = map fst datelist
      uptodate = if length filelist /= length alreadythere
        then False
        else foldl (\acc (_,x) -> (nameToDate x) `elem` alreadythere && acc) True filelist
  if uptodate
    then putStrLn "We're up-to-date!"
    else putStrLn $ texfile ++ " is behind!"

updateTexFile :: [String] -> IO ()
updateTexFile [texfile, dir] = do
  filelist <- getDiaryFiles dir
  let datelist = [(nameToDate filename, createEntry DDMMYYYY day) | day@(_,filename) <- filelist]
  writeTex texfile datelist


----------------------------------------------------------------
-- helper funcs

getDateList :: String -> IO [(Date, String)]
getDateList filename = do
  contents <- readFile filename
  return . texToDateList . lines $ contents

writeTex :: String -> [(Date,String)] -> IO ()
writeTex filename dateList = do writeFile filename $ dateListToTex dateList

getYearDirs :: String -> IO [String]
getYearDirs rootdir = do
  contents <- listDirectory rootdir
  dirs <- filterM doesDirectoryExist contents
  return $ filter (all isDigit) dirs

-- returns list of all .tex files in year-subdirectories
getDiaryFiles :: String -> IO [(String, String)]
getDiaryFiles rootdir = do
  years <- getYearDirs rootdir
  files <- mapM listDirectory years
  -- return tuple of folder and filename
  let paths = zipWith (\y f -> (map (\x -> (y,x)) f)) years files
  return . filter ((".tex" `isSuffixOf`) . snd) . concat $ paths
