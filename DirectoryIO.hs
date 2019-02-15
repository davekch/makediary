module DirectoryIO
( getTexFilesList ) where

import System.Directory.Tree
import System.FilePath (takeExtension)

texFilesTree :: FilePath -> IO (DirTree FilePath)
texFilesTree path = do
    _:/tree <- readDirectoryWith return path
    return $ filterDir findTex tree
  where findTex (Dir ('.':_) _) = False
        findTex (File ('.':_) _) = False
        findTex _ = True

texFilesList :: DirTree FilePath -> [DirTree FilePath]
texFilesList = filter isFile . flattenDir
  where
    isFile (File _ _) = True
    isFile _ = False

getTexFilesList :: FilePath -> IO [DirTree FilePath]
getTexFilesList path = do
  tree <- texFilesTree path
  return $ texFilesList tree
