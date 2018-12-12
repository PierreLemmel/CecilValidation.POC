using System.Diagnostics;
using System.Text;

namespace CecilValidation.Tests.Commands
{
    internal class ProcessRunner
    {
        public string ExecuteCommand(string command)
        {
            ProcessStartInfo procStartInfo = new ProcessStartInfo("cmd", "/c " + command)
            {
                RedirectStandardOutput = true,
                RedirectStandardError = true,
                UseShellExecute = false,
                CreateNoWindow = true
            };

            using (Process proc = Process.Start(procStartInfo))
            {
                StringBuilder errorBuilder = new StringBuilder();
                StringBuilder outputBuilder = new StringBuilder();

                proc.BeginOutputReadLine();
                proc.BeginErrorReadLine();

                proc.ErrorDataReceived += (object sender, DataReceivedEventArgs e) => errorBuilder.AppendLine(e.Data);
                proc.OutputDataReceived += (object sender, DataReceivedEventArgs e) => outputBuilder.AppendLine(e.Data); ;

                proc.WaitForExit();

                string error = errorBuilder.ToString().Trim();
                if (!string.IsNullOrEmpty(error))
                    throw new ProcessException("Error while running process. See error content for furter details", error);

                string result = outputBuilder.ToString().Trim();

                return result; 
            }
        }
    }
}
