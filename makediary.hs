import System.IO
import System.Directory
import System.Directory.Tree
import System.Environment
import Data.List

import LogTex
import Date
import DirectoryIO


main = do
  args <- getArgs
  updateTexFile args


updateTexFile :: [String] -> IO ()
updateTexFile [template, texfile, dir] = do
  filelist <- getTexFilesList dir
  templ <- readFile template
  let entry = unlines . createEntry (lines templ)
      datelist = [(nameToDate name, entry (path, name)) | (File name path) <- filelist]
  writeTex texfile datelist

writeTex :: String -> [(Date,String)] -> IO ()
writeTex filename dateList = do writeFile filename $ dateListToTex dateList
