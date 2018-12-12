using CecilValidation.Tests.Commands;
using System;
using System.IO;
using System.Reflection;

namespace CecilValidation.Tests.IL
{
    internal class ILReader
    {
        private readonly ProcessRunner processRunner;

        internal ILReader(ProcessRunner processRunner)
        {
            this.processRunner = processRunner ?? throw new ArgumentNullException(nameof(processRunner));
        }

        public string ReadILCodeFromAssembly(string relativePath)
        {
            if (!File.Exists(relativePath))
                throw new FileNotFoundException();

            string executingPath = GetExecutingAssemblyPath();
            string ilspycmdPath = Path.Combine(executingPath, "ilspycmd", "ilspycmd.dll");
            string fullPath = Path.Combine(executingPath, relativePath);

            string command = BuildCommandFromPath(ilspycmdPath, fullPath);
            string output = processRunner.ExecuteCommand(command);

            return output;
        }

        private string GetExecutingAssemblyPath()
        {
            string codeBase = Assembly.GetExecutingAssembly().CodeBase;
            UriBuilder uri = new UriBuilder(codeBase);

            return Path.GetDirectoryName(Uri.UnescapeDataString(uri.Path));
        }

        private string BuildCommandFromPath(string ilspycmdPath, string fullPath) => $"dotnet {ilspycmdPath} --ilcode {fullPath}";
    }
}
