using System;

namespace CecilValidation.Tests.IL
{
    public class ILProvider
    {
        private readonly ILReader reader;
        private readonly ILCommentsCleaner cleaner;

        internal ILProvider(ILReader reader, ILCommentsCleaner cleaner)
        {
            this.reader = reader ?? throw new ArgumentNullException(nameof(reader));
            this.cleaner = cleaner ?? throw new ArgumentNullException(nameof(cleaner));
        }

        public string GetILCodeFromPath(string relativePath)
        {
            string rawILCode = reader.ReadILCodeFromAssembly(relativePath);
            string resultILCode = cleaner.CleanCommentsFromILCode(rawILCode);

            return resultILCode;
        }
    }
}
