using System.Text.RegularExpressions;

namespace CecilValidation.Tests.IL
{
    internal class ILCommentsCleaner
    {
        public string CleanCommentsFromILCode(string ilCode)
        {
            string temp = ilCode;

            const string wholeLineCommentPattern = @"^[ \t]*//.*\r\n";
            temp = Regex.Replace(temp, wholeLineCommentPattern, "", RegexOptions.Multiline);

            const string endOfLineCommentPattern = @"[ \t]*//.*";
            temp = Regex.Replace(temp, endOfLineCommentPattern, "\r", RegexOptions.Multiline);

            return temp.TrimEnd();
        }
    }
}
