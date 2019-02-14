import System.IO
import System.Directory
import System.Directory.Tree
import System.Environment
import Data.List

import LogTex
import Date
import DirectoryIO

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
  filelist <- getTexFilesList dir
  let alreadythere = map fst datelist
      uptodate = if length filelist /= length alreadythere
        then False
        else foldl (\acc (File x _) -> (nameToDate x) `elem` alreadythere && acc) True filelist
  if uptodate
    then putStrLn "We're up-to-date!"
    else putStrLn $ texfile ++ " is behind!"

updateTexFile :: [String] -> IO ()
updateTexFile [texfile, dir] = do
  filelist <- getTexFilesList dir
  let datelist = [(nameToDate name, createEntry DDMMYYYY (path, name)) | (File name path) <- filelist]
  writeTex texfile datelist


----------------------------------------------------------------
-- helper funcs

getDateList :: String -> IO [(Date, String)]
getDateList filename = do
  contents <- readFile filename
  return . texToDateList . lines $ contents

writeTex :: String -> [(Date,String)] -> IO ()
writeTex filename dateList = do writeFile filename $ dateListToTex dateList
