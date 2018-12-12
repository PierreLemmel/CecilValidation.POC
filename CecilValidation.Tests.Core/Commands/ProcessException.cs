using System;

namespace CecilValidation.Tests.Commands
{
    public class ProcessException : Exception
    {
        public string ErrorContent { get; }

        public ProcessException(string message, string errorContent)
        {
            ErrorContent = errorContent;
        }
    }
}
