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
updateTexFile [texfile, dir] = do
  filelist <- getTexFilesList dir
  let datelist = [(nameToDate name, createEntry DDMMYYYY (path, name)) | (File name path) <- filelist]
  writeTex texfile datelist

writeTex :: String -> [(Date,String)] -> IO ()
writeTex filename dateList = do writeFile filename $ dateListToTex dateList
