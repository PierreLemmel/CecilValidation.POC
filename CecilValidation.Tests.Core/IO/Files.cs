using System;
using System.Collections.Generic;
using System.IO;

namespace CecilValidation.Tests.IO
{
    public static class Files
    {
        public static void ClearDirectory(string path)
        {
            Directory.Delete(path, true);
        }

        public static void CopyDirectoryContent(string source, string destination)
        {
            IEnumerable<string> directories = Directory.GetDirectories(source, "*", SearchOption.AllDirectories);
            foreach (string dirPath in directories)
                Directory.CreateDirectory(dirPath.Replace(source, destination));

            IEnumerable<string> files = Directory.GetFiles(source, "*.*", SearchOption.AllDirectories);
            foreach (string newPath in files)
                File.Copy(newPath, newPath.Replace(source, destination), true);
        }
    }
}
